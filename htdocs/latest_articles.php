<?php
declare(strict_types=1);

require_once __DIR__ . '/search_mvp_lib.php';

header('Content-Type: application/json; charset=UTF-8');
header('Cache-Control: no-store');

function latest_articles_json_error(string $message, int $status = 400): void
{
    http_response_code($status);
    echo json_encode(['ok' => false, 'error' => $message], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
    exit;
}

$journal = search_mvp_str((string)($_GET['journal'] ?? ''));
$lang = search_mvp_str((string)($_GET['lang'] ?? 'pt'));
$limit = (int)($_GET['limit'] ?? 12);

if ($journal === '' || !preg_match('/^[A-Za-z0-9._ -]+$/', $journal)) {
    latest_articles_json_error('Invalid journal.');
}

if (!in_array($lang, ['pt', 'es', 'en'], true)) {
    $lang = 'pt';
}

$limit = min(20, max(4, $limit));

try {
    $pdo = search_mvp_connect();
    $sql = "SELECT pid, title, journal_title, journal_issn, pub_year, lang, article_url, source_issue_pid
            FROM search_documents
            WHERE (search_mvp_norm(journal_issn) LIKE :journal OR search_mvp_norm(journal_title) LIKE :journal)
              AND (:lang = '' OR lang = :lang)
            ORDER BY COALESCE(pub_year, 0) DESC,
                     source_issue_pid DESC,
                     pid DESC
            LIMIT :limit";
    $stmt = $pdo->prepare($sql);
    $stmt->bindValue(':journal', '%' . search_mvp_normalize($journal) . '%', PDO::PARAM_STR);
    $stmt->bindValue(':lang', $lang, PDO::PARAM_STR);
    $stmt->bindValue(':limit', $limit, PDO::PARAM_INT);
    $stmt->execute();
    $items = $stmt->fetchAll() ?: [];

    $items = array_map(static function (array $row): array {
        $pid = (string)$row['pid'];
        $volume = '';
        $publicationDate = '';
        if ($pid !== '' && preg_match('/^[A-Za-z0-9._-]+$/', $pid)) {
            $xmlRaw = search_mvp_http_get(
                'http://127.0.0.1/scielo.php?script=sci_abstract&pid=' . rawurlencode($pid)
                . '&lng=' . rawurlencode((string)$row['lang'])
                . '&nrm=iso&tlng=' . rawurlencode((string)$row['lang'])
                . '&debug=xml'
            );
            $xml = search_mvp_load_xml($xmlRaw);
            if ($xml) {
                $issueNodes = $xml->xpath('//ISSUEINFO');
                if ($issueNodes) {
                    $issue = $issueNodes[0];
                    $volume = search_mvp_str((string)$issue['VOL']);
                    $year = search_mvp_str((string)$issue['YEAR']);
                    $month = search_mvp_str((string)$issue['MONTH']);
                    $day = search_mvp_str((string)$issue['DAY']);
                    if ($year !== '' && $month !== '' && $month !== '00' && $day !== '') {
                        $publicationDate = sprintf('%04d-%02d-%02d', (int)$year, (int)$month, (int)$day);
                    } elseif ($year !== '' && $month !== '' && $month !== '00') {
                        $publicationDate = sprintf('%04d-%02d', (int)$year, (int)$month);
                    } elseif ($year !== '') {
                        $publicationDate = $year;
                    }
                }
            }
        }

        if ($publicationDate === '' && $row['pub_year'] !== null) {
            $publicationDate = (string)(int)$row['pub_year'];
        }

        return [
            'pid' => $pid,
            'title' => search_mvp_str((string)$row['title']),
            'journal_title' => search_mvp_str((string)$row['journal_title']),
            'journal_issn' => search_mvp_str((string)$row['journal_issn']),
            'volume' => $volume,
            'publication_date' => $publicationDate,
            'pub_year' => $row['pub_year'] !== null ? (int)$row['pub_year'] : null,
            'lang' => search_mvp_str((string)$row['lang']),
            'article_url' => search_mvp_str((string)$row['article_url']),
            'source_issue_pid' => search_mvp_str((string)$row['source_issue_pid']),
        ];
    }, $items);

    echo json_encode([
        'ok' => true,
        'total' => count($items),
        'items' => $items,
    ], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
} catch (Throwable $e) {
    latest_articles_json_error('Unable to load latest articles.', 500);
}
