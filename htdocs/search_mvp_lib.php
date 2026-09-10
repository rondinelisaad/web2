<?php
declare(strict_types=1);

function search_mvp_db_path(): string
{
    return __DIR__ . '/tmpSQL/search_mvp.sqlite';
}

function search_mvp_connect(): PDO
{
    static $pdo = null;
    if ($pdo instanceof PDO) {
        return $pdo;
    }

    $dbPath = search_mvp_db_path();
    $dir = dirname($dbPath);
    if (!is_dir($dir)) {
        mkdir($dir, 0775, true);
    }

    $pdo = new PDO('sqlite:' . $dbPath);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $pdo->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
    if (method_exists($pdo, 'sqliteCreateFunction')) {
        $pdo->sqliteCreateFunction('search_mvp_norm', 'search_mvp_normalize', 1);
    }

    $pdo->exec(
        "CREATE TABLE IF NOT EXISTS search_documents (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            pid TEXT NOT NULL UNIQUE,
            title TEXT NOT NULL DEFAULT '',
            title_norm TEXT NOT NULL DEFAULT '',
            abstract_text TEXT NOT NULL DEFAULT '',
            abstract_text_norm TEXT NOT NULL DEFAULT '',
            authors TEXT NOT NULL DEFAULT '',
            authors_norm TEXT NOT NULL DEFAULT '',
            journal_title TEXT NOT NULL DEFAULT '',
            journal_title_norm TEXT NOT NULL DEFAULT '',
            journal_issn TEXT NOT NULL DEFAULT '',
            journal_issn_norm TEXT NOT NULL DEFAULT '',
            pub_year INTEGER,
            lang TEXT NOT NULL DEFAULT 'en',
            article_url TEXT NOT NULL DEFAULT '',
            abstract_url TEXT NOT NULL DEFAULT '',
            source_issue_pid TEXT NOT NULL DEFAULT '',
            indexed_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
        )"
    );
    search_mvp_upgrade_schema($pdo);
    search_mvp_ensure_fts($pdo);

    return $pdo;
}

function search_mvp_table_columns(PDO $pdo, string $table): array
{
    $stmt = $pdo->query("PRAGMA table_info({$table})");
    $columns = [];
    foreach ($stmt->fetchAll() ?: [] as $row) {
        $columns[(string)$row['name']] = true;
    }
    return $columns;
}

function search_mvp_upgrade_schema(PDO $pdo): void
{
    $columns = search_mvp_table_columns($pdo, 'search_documents');
    $normalColumns = [
        'title_norm',
        'abstract_text_norm',
        'authors_norm',
        'journal_title_norm',
        'journal_issn_norm',
    ];
    foreach ($normalColumns as $column) {
        if (!isset($columns[$column])) {
            $pdo->exec("ALTER TABLE search_documents ADD COLUMN {$column} TEXT NOT NULL DEFAULT ''");
        }
    }

    $pdo->exec("CREATE INDEX IF NOT EXISTS idx_search_documents_lang ON search_documents(lang)");
    $pdo->exec("CREATE INDEX IF NOT EXISTS idx_search_documents_pub_year ON search_documents(pub_year)");
    $pdo->exec("CREATE INDEX IF NOT EXISTS idx_search_documents_journal_issn_norm ON search_documents(journal_issn_norm)");
    $pdo->exec("CREATE INDEX IF NOT EXISTS idx_search_documents_lang_journal_year ON search_documents(lang, journal_issn_norm, pub_year)");
    $pdo->exec("CREATE INDEX IF NOT EXISTS idx_search_documents_source_issue ON search_documents(source_issue_pid)");

    search_mvp_backfill_normalized_columns($pdo);
}

function search_mvp_backfill_normalized_columns(PDO $pdo): void
{
    $stmt = $pdo->query(
        "SELECT id, title, abstract_text, authors, journal_title, journal_issn
         FROM search_documents
         WHERE (title <> '' AND title_norm = '')
            OR (abstract_text <> '' AND abstract_text_norm = '')
            OR (authors <> '' AND authors_norm = '')
            OR (journal_title <> '' AND journal_title_norm = '')
            OR (journal_issn <> '' AND journal_issn_norm = '')
         LIMIT 50000"
    );
    $rows = $stmt->fetchAll() ?: [];
    if (!$rows) {
        return;
    }

    $update = $pdo->prepare(
        "UPDATE search_documents
         SET title_norm = :title_norm,
             abstract_text_norm = :abstract_text_norm,
             authors_norm = :authors_norm,
             journal_title_norm = :journal_title_norm,
             journal_issn_norm = :journal_issn_norm
         WHERE id = :id"
    );

    $pdo->beginTransaction();
    try {
        foreach ($rows as $row) {
            $update->execute([
                ':id' => (int)$row['id'],
                ':title_norm' => search_mvp_normalize((string)$row['title']),
                ':abstract_text_norm' => search_mvp_normalize((string)$row['abstract_text']),
                ':authors_norm' => search_mvp_normalize((string)$row['authors']),
                ':journal_title_norm' => search_mvp_normalize((string)$row['journal_title']),
                ':journal_issn_norm' => search_mvp_normalize((string)$row['journal_issn']),
            ]);
        }
        $pdo->commit();
    } catch (Throwable $e) {
        $pdo->rollBack();
        throw $e;
    }
}

function search_mvp_str(?string $value): string
{
    $value = (string)$value;
    $value = html_entity_decode($value, ENT_QUOTES | ENT_HTML5, 'UTF-8');
    $value = preg_replace('/\s+/u', ' ', trim($value)) ?? '';
    return $value;
}

function search_mvp_normalize(?string $value): string
{
    $value = search_mvp_str($value);
    $value = mb_strtolower($value, 'UTF-8');
    $value = strtr($value, [
        'á' => 'a', 'à' => 'a', 'â' => 'a', 'ã' => 'a', 'ä' => 'a', 'å' => 'a', 'ā' => 'a', 'ă' => 'a', 'ą' => 'a',
        'é' => 'e', 'è' => 'e', 'ê' => 'e', 'ë' => 'e', 'ē' => 'e', 'ĕ' => 'e', 'ė' => 'e', 'ę' => 'e', 'ě' => 'e',
        'í' => 'i', 'ì' => 'i', 'î' => 'i', 'ï' => 'i', 'ī' => 'i', 'ĭ' => 'i', 'į' => 'i', 'ı' => 'i',
        'ó' => 'o', 'ò' => 'o', 'ô' => 'o', 'õ' => 'o', 'ö' => 'o', 'ø' => 'o', 'ō' => 'o', 'ŏ' => 'o', 'ő' => 'o',
        'ú' => 'u', 'ù' => 'u', 'û' => 'u', 'ü' => 'u', 'ū' => 'u', 'ŭ' => 'u', 'ů' => 'u', 'ű' => 'u', 'ų' => 'u',
        'ç' => 'c', 'ñ' => 'n', 'ý' => 'y', 'ÿ' => 'y',
    ]);
    $value = preg_replace('/[^\p{L}\p{N}]+/u', ' ', $value) ?? '';
    return search_mvp_str($value);
}

function search_mvp_ensure_fts(PDO $pdo): bool
{
    static $available = null;
    if ($available !== null) {
        return $available;
    }

    try {
        $pdo->exec(
            "CREATE VIRTUAL TABLE IF NOT EXISTS search_documents_fts USING fts5(
                pid UNINDEXED,
                title,
                abstract_text,
                authors,
                journal_title,
                journal_issn,
                all_text,
                tokenize = 'unicode61'
            )"
        );
        $available = true;
        search_mvp_backfill_fts($pdo);
    } catch (Throwable $e) {
        $available = false;
    }

    return $available;
}

function search_mvp_backfill_fts(PDO $pdo): void
{
    $docCount = (int)$pdo->query("SELECT COUNT(*) FROM search_documents")->fetchColumn();
    if ($docCount < 1) {
        return;
    }

    $ftsCount = (int)$pdo->query("SELECT COUNT(*) FROM search_documents_fts")->fetchColumn();
    if ($ftsCount >= $docCount) {
        return;
    }

    $pdo->exec("DELETE FROM search_documents_fts");
    $stmt = $pdo->query(
        "SELECT pid, title_norm, abstract_text_norm, authors_norm, journal_title_norm, journal_issn_norm
         FROM search_documents"
    );
    $insert = $pdo->prepare(
        "INSERT INTO search_documents_fts
         (pid, title, abstract_text, authors, journal_title, journal_issn, all_text)
         VALUES
         (:pid, :title, :abstract_text, :authors, :journal_title, :journal_issn, :all_text)"
    );

    $pdo->beginTransaction();
    try {
        while (($row = $stmt->fetch()) !== false) {
            search_mvp_fts_insert_row($insert, $row);
        }
        $pdo->commit();
    } catch (Throwable $e) {
        $pdo->rollBack();
        throw $e;
    }
}

function search_mvp_fts_insert_row(PDOStatement $stmt, array $row): void
{
    $title = search_mvp_str((string)($row['title_norm'] ?? ''));
    $abstract = search_mvp_str((string)($row['abstract_text_norm'] ?? ''));
    $authors = search_mvp_str((string)($row['authors_norm'] ?? ''));
    $journalTitle = search_mvp_str((string)($row['journal_title_norm'] ?? ''));
    $journalIssn = search_mvp_str((string)($row['journal_issn_norm'] ?? ''));

    $stmt->execute([
        ':pid' => search_mvp_str((string)($row['pid'] ?? '')),
        ':title' => $title,
        ':abstract_text' => $abstract,
        ':authors' => $authors,
        ':journal_title' => $journalTitle,
        ':journal_issn' => $journalIssn,
        ':all_text' => search_mvp_str($title . ' ' . $abstract . ' ' . $authors . ' ' . $journalTitle . ' ' . $journalIssn),
    ]);
}

function search_mvp_fts_upsert(PDO $pdo, array $doc): void
{
    if (!search_mvp_ensure_fts($pdo)) {
        return;
    }

    $pid = search_mvp_str((string)($doc['pid'] ?? ''));
    if ($pid === '') {
        return;
    }

    $pdo->prepare("DELETE FROM search_documents_fts WHERE pid = :pid")->execute([':pid' => $pid]);
    $insert = $pdo->prepare(
        "INSERT INTO search_documents_fts
         (pid, title, abstract_text, authors, journal_title, journal_issn, all_text)
         VALUES
         (:pid, :title, :abstract_text, :authors, :journal_title, :journal_issn, :all_text)"
    );
    search_mvp_fts_insert_row($insert, $doc);
}

function search_mvp_clear_index(PDO $pdo): void
{
    $pdo->exec("DELETE FROM search_documents");
    if (search_mvp_ensure_fts($pdo)) {
        $pdo->exec("DELETE FROM search_documents_fts");
    }
}

function search_mvp_fts_phrase(string $query): string
{
    $normalized = search_mvp_normalize($query);
    if ($normalized === '') {
        return '';
    }
    return '"' . str_replace('"', '""', $normalized) . '"';
}

function search_mvp_fts_expression(string $field, string $query): string
{
    $phrase = search_mvp_fts_phrase($query);
    if ($phrase === '') {
        return '';
    }

    switch ($field) {
        case 'title':
            return 'title:' . $phrase;
        case 'abstract':
            return 'abstract_text:' . $phrase;
        case 'author':
            return 'authors:' . $phrase;
        case 'journal':
            return '(journal_title:' . $phrase . ' OR journal_issn:' . $phrase . ')';
        default:
            return $phrase;
    }
}

function search_mvp_norm_search_columns(string $field): array
{
    switch ($field) {
        case 'title':
            return ['title_norm'];
        case 'abstract':
            return ['abstract_text_norm'];
        case 'author':
            return ['authors_norm'];
        case 'journal':
            return ['journal_title_norm', 'journal_issn_norm'];
        default:
            return ['title_norm', 'abstract_text_norm', 'authors_norm', 'journal_title_norm', 'journal_issn_norm'];
    }
}

function search_mvp_query_terms(string $query): array
{
    $normalized = search_mvp_normalize($query);
    if ($normalized === '') {
        return [];
    }

    $stopwords = array_flip([
        'a', 'o', 'as', 'os', 'de', 'da', 'do', 'das', 'dos', 'e', 'em', 'na', 'no', 'nas', 'nos',
        'the', 'of', 'and', 'in', 'on',
        'el', 'la', 'los', 'las', 'del', 'de', 'y', 'en',
    ]);
    $terms = [];
    foreach (preg_split('/\s+/', $normalized) ?: [] as $term) {
        if ($term === '' || isset($stopwords[$term])) {
            continue;
        }
        $terms[] = $term;
    }

    return $terms ?: (preg_split('/\s+/', $normalized) ?: []);
}

function search_mvp_search_columns(string $field): array
{
    switch ($field) {
        case 'title':
            return ['title'];
        case 'abstract':
            return ['abstract_text'];
        case 'author':
            return ['authors'];
        case 'journal':
            return ['journal_title', 'journal_issn'];
        default:
            return ['title', 'abstract_text', 'authors', 'journal_title', 'journal_issn'];
    }
}

function search_mvp_phrase_condition(string $field, string $paramName): string
{
    $columns = search_mvp_norm_search_columns($field);
    $parts = [];
    foreach ($columns as $column) {
        $parts[] = 'd.' . $column . ' LIKE ' . $paramName;
    }
    return '(' . implode(' OR ', $parts) . ')';
}

function search_mvp_http_get(string $url): string
{
    $ctx = stream_context_create([
        'http' => [
            'method' => 'GET',
            'timeout' => 20,
            'ignore_errors' => true,
            'header' => "User-Agent: SciELO-MVP-Indexer/1.0\r\n",
        ],
    ]);
    $content = @file_get_contents($url, false, $ctx);
    return $content === false ? '' : $content;
}

function search_mvp_load_xml(string $xmlRaw): ?SimpleXMLElement
{
    if ($xmlRaw === '' || strpos($xmlRaw, '<ERROR></ERROR>') !== false) {
        return null;
    }
    libxml_use_internal_errors(true);
    $xml = simplexml_load_string($xmlRaw);
    if ($xml === false) {
        return null;
    }
    return $xml;
}

function search_mvp_extract_text(SimpleXMLElement $xml, string $xpath): string
{
    $nodes = $xml->xpath($xpath);
    if (!$nodes) {
        return '';
    }
    $parts = [];
    foreach ($nodes as $node) {
        $domNode = dom_import_simplexml($node);
        $parts[] = search_mvp_str($domNode ? $domNode->textContent : (string)$node);
    }
    return search_mvp_str(implode(' ', $parts));
}

function search_mvp_extract_authors(SimpleXMLElement $xml): string
{
    $nodes = $xml->xpath('//ARTICLE/AUTHORS/AUTH_PERS/AUTHOR | //ARTICLE/AUTHORS/AUTH_CORP/AUTHOR');
    if (!$nodes) {
        return '';
    }

    $parts = [];
    $seen = [];
    foreach ($nodes as $node) {
        $surname = search_mvp_str((string)($node->SURNAME ?? ''));
        $name = search_mvp_str((string)($node->NAME ?? ''));
        $orgName = search_mvp_str((string)($node->ORGNAME ?? ''));
        $orgDiv = search_mvp_str((string)($node->ORGDIV ?? ''));
        $search = search_mvp_str((string)($node['SEARCH'] ?? ''));

        $variants = [];
        if ($search !== '') {
            $variants[] = $search;
        }
        if ($surname !== '' || $name !== '') {
            $variants[] = search_mvp_str(trim($surname . ', ' . $name, ' ,'));
            $variants[] = search_mvp_str(trim($name . ' ' . $surname));
        }
        if ($orgName !== '' || $orgDiv !== '') {
            $variants[] = search_mvp_str(trim($orgName . ' ' . $orgDiv));
        }
        if (!$variants) {
            $domNode = dom_import_simplexml($node);
            $variants[] = search_mvp_str($domNode ? $domNode->textContent : (string)$node);
        }

        foreach ($variants as $variant) {
            $variant = search_mvp_str($variant);
            if ($variant === '') {
                continue;
            }
            $key = search_mvp_normalize($variant);
            if ($key === '' || isset($seen[$key])) {
                continue;
            }
            $seen[$key] = true;
            $parts[] = $variant;
        }
    }

    return search_mvp_str(implode('; ', $parts));
}

function search_mvp_author_fallback_query(string $query): string
{
    $query = search_mvp_str($query);
    if ($query === '') {
        return '';
    }
    if (strpos($query, ',') !== false) {
        return search_mvp_str((string)strtok($query, ','));
    }

    $normalized = search_mvp_normalize($query);
    $parts = preg_split('/\s+/', $normalized) ?: [];
    return search_mvp_str((string)($parts[0] ?? ''));
}

function search_mvp_insert_or_update(PDO $pdo, array $doc): void
{
    $doc['title_norm'] = search_mvp_normalize((string)($doc['title'] ?? ''));
    $doc['abstract_text_norm'] = search_mvp_normalize((string)($doc['abstract_text'] ?? ''));
    $doc['authors_norm'] = search_mvp_normalize((string)($doc['authors'] ?? ''));
    $doc['journal_title_norm'] = search_mvp_normalize((string)($doc['journal_title'] ?? ''));
    $doc['journal_issn_norm'] = search_mvp_normalize((string)($doc['journal_issn'] ?? ''));

    $sql = "INSERT INTO search_documents
            (pid, title, title_norm, abstract_text, abstract_text_norm, authors, authors_norm, journal_title, journal_title_norm, journal_issn, journal_issn_norm, pub_year, lang, article_url, abstract_url, source_issue_pid, indexed_at)
            VALUES
            (:pid, :title, :title_norm, :abstract_text, :abstract_text_norm, :authors, :authors_norm, :journal_title, :journal_title_norm, :journal_issn, :journal_issn_norm, :pub_year, :lang, :article_url, :abstract_url, :source_issue_pid, datetime('now'))
            ON CONFLICT(pid) DO UPDATE SET
                title=excluded.title,
                title_norm=excluded.title_norm,
                abstract_text=excluded.abstract_text,
                abstract_text_norm=excluded.abstract_text_norm,
                authors=excluded.authors,
                authors_norm=excluded.authors_norm,
                journal_title=excluded.journal_title,
                journal_title_norm=excluded.journal_title_norm,
                journal_issn=excluded.journal_issn,
                journal_issn_norm=excluded.journal_issn_norm,
                pub_year=excluded.pub_year,
                lang=excluded.lang,
                article_url=excluded.article_url,
                abstract_url=excluded.abstract_url,
                source_issue_pid=excluded.source_issue_pid,
                indexed_at=datetime('now')";

    $stmt = $pdo->prepare($sql);
    $stmt->execute([
        ':pid' => $doc['pid'] ?? '',
        ':title' => $doc['title'] ?? '',
        ':title_norm' => $doc['title_norm'],
        ':abstract_text' => $doc['abstract_text'] ?? '',
        ':abstract_text_norm' => $doc['abstract_text_norm'],
        ':authors' => $doc['authors'] ?? '',
        ':authors_norm' => $doc['authors_norm'],
        ':journal_title' => $doc['journal_title'] ?? '',
        ':journal_title_norm' => $doc['journal_title_norm'],
        ':journal_issn' => $doc['journal_issn'] ?? '',
        ':journal_issn_norm' => $doc['journal_issn_norm'],
        ':pub_year' => $doc['pub_year'] ?? null,
        ':lang' => $doc['lang'] ?? 'en',
        ':article_url' => $doc['article_url'] ?? '',
        ':abstract_url' => $doc['abstract_url'] ?? '',
        ':source_issue_pid' => $doc['source_issue_pid'] ?? '',
    ]);
    search_mvp_fts_upsert($pdo, $doc);
}

function search_mvp_search(array $params): array
{
    $pdo = search_mvp_connect();

    $q = search_mvp_str($params['q'] ?? '');
    $field = search_mvp_str($params['field'] ?? 'all');
    $year = search_mvp_str($params['year'] ?? '');
    $yearFrom = search_mvp_str($params['year_from'] ?? '');
    $yearTo = search_mvp_str($params['year_to'] ?? '');
    $author = search_mvp_str($params['author'] ?? '');
    $journal = search_mvp_str($params['journal'] ?? '');
    $advanced = is_array($params['advanced'] ?? null) ? $params['advanced'] : [];
    $page = max(1, (int)($params['page'] ?? 1));
    $perPage = min(100, max(1, (int)($params['per_page'] ?? 20)));
    $offset = ($page - 1) * $perPage;

    $where = [];
    $bind = [];

    $searchExpression = '';
    $useFts = search_mvp_ensure_fts($pdo);
    if ($q !== '') {
        if ($useFts) {
            $searchExpression = search_mvp_fts_expression($field, $q);
        } else {
            $normalizedQuery = search_mvp_normalize($q);
            if ($normalizedQuery !== '') {
                $bind[':q_phrase'] = '%' . $normalizedQuery . '%';
                $searchExpression = search_mvp_phrase_condition($field, ':q_phrase');
            }
        }
    }

    $allowedOps = ['AND' => 'AND', 'OR' => 'OR', 'AND NOT' => 'AND NOT'];
    foreach ($advanced as $idx => $row) {
        if (!is_array($row)) {
            continue;
        }
        $term = search_mvp_str($row['q'] ?? '');
        $normalizedTerm = search_mvp_normalize($term);
        if ($normalizedTerm === '') {
            continue;
        }
        $op = strtoupper(search_mvp_str($row['op'] ?? 'AND'));
        $op = $allowedOps[$op] ?? 'AND';
        $rowField = search_mvp_str($row['field'] ?? 'title');
        if ($useFts) {
            $condition = search_mvp_fts_expression($rowField, $term);
            if ($condition === '') {
                continue;
            }
        } else {
            $param = ':q_adv_' . (int)$idx;
            $bind[$param] = '%' . $normalizedTerm . '%';
            $condition = search_mvp_phrase_condition($rowField, $param);
        }

        if ($searchExpression === '') {
            if ($op === 'AND NOT' && $useFts) {
                $useFts = false;
                $param = ':q_adv_' . (int)$idx;
                $bind[$param] = '%' . $normalizedTerm . '%';
                $searchExpression = 'NOT ' . search_mvp_phrase_condition($rowField, $param);
            } else {
                $searchExpression = $op === 'AND NOT' ? ('NOT ' . $condition) : $condition;
            }
        } elseif ($op === 'AND NOT') {
            $searchExpression = $useFts
                ? ('(' . $searchExpression . ' NOT ' . $condition . ')')
                : ('(' . $searchExpression . ' AND NOT ' . $condition . ')');
        } else {
            $searchExpression = '(' . $searchExpression . ' ' . $op . ' ' . $condition . ')';
        }
    }

    if ($searchExpression !== '') {
        if ($useFts) {
            $where[] = 'search_documents_fts MATCH :fts_query';
            $bind[':fts_query'] = $searchExpression;
        } else {
            $where[] = '(' . $searchExpression . ')';
        }
    }

    // Keep author clicks as an exact phrase even if an older FTS index tokenizes punctuation.
    if ($q !== '' && $field === 'author') {
        $where[] = 'd.authors_norm LIKE :author_query_phrase';
        $bind[':author_query_phrase'] = '%' . search_mvp_normalize($q) . '%';
    }

    if ($year !== '' && ctype_digit($year)) {
        $where[] = 'd.pub_year = :year';
        $bind[':year'] = (int)$year;
    }

    if ($yearFrom !== '' && ctype_digit($yearFrom)) {
        $where[] = 'd.pub_year >= :year_from';
        $bind[':year_from'] = (int)$yearFrom;
    }

    if ($yearTo !== '' && ctype_digit($yearTo)) {
        $where[] = 'd.pub_year <= :year_to';
        $bind[':year_to'] = (int)$yearTo;
    }

    if ($author !== '') {
        $where[] = 'd.authors_norm LIKE :author';
        $bind[':author'] = '%' . search_mvp_normalize($author) . '%';
    }

    if ($journal !== '') {
        $journalNorm = search_mvp_normalize($journal);
        $where[] = '(d.journal_issn_norm = :journal_exact OR d.journal_title_norm LIKE :journal_like OR d.journal_issn_norm LIKE :journal_like)';
        $bind[':journal_exact'] = $journalNorm;
        $bind[':journal_like'] = '%' . $journalNorm . '%';
    }

    $whereSql = $where ? ('WHERE ' . implode(' AND ', $where)) : '';
    $fromSql = $useFts && isset($bind[':fts_query'])
        ? 'search_documents d JOIN search_documents_fts ON search_documents_fts.pid = d.pid'
        : 'search_documents d';

    $countSql = "SELECT COUNT(*) FROM {$fromSql} {$whereSql}";
    $countStmt = $pdo->prepare($countSql);
    $countStmt->execute($bind);
    $total = (int)$countStmt->fetchColumn();

    $listSql = "SELECT d.pid, d.title, d.abstract_text, d.authors, d.journal_title, d.journal_issn, d.pub_year, d.lang, d.article_url, d.abstract_url, d.source_issue_pid, d.indexed_at
                FROM {$fromSql}
                {$whereSql}
                ORDER BY d.pub_year DESC, d.journal_title ASC, d.title ASC
                LIMIT :limit OFFSET :offset";
    $listStmt = $pdo->prepare($listSql);
    foreach ($bind as $key => $value) {
        $listStmt->bindValue($key, $value);
    }
    $listStmt->bindValue(':limit', $perPage, PDO::PARAM_INT);
    $listStmt->bindValue(':offset', $offset, PDO::PARAM_INT);
    $listStmt->execute();
    $rows = $listStmt->fetchAll();

    return [
        'total' => $total,
        'page' => $page,
        'per_page' => $perPage,
        'pages' => max(1, (int)ceil($total / $perPage)),
        'items' => $rows ?: [],
    ];
}
