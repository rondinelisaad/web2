<?php
declare(strict_types=1);

require_once __DIR__ . '/search_mvp_lib.php';

header('Content-Type: application/json; charset=UTF-8');
header('Cache-Control: public, max-age=3600');

function issue_article_count_error(string $message, int $status = 400): void
{
    http_response_code($status);
    echo json_encode(['ok' => false, 'error' => $message], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
    exit;
}

$pid = search_mvp_str((string)($_GET['pid'] ?? ''));
$lang = search_mvp_str((string)($_GET['lang'] ?? 'pt'));

if ($pid === '' || !preg_match('/^[A-Za-z0-9._-]+$/', $pid)) {
    issue_article_count_error('Invalid issue pid.');
}

if (!in_array($lang, ['pt', 'es', 'en'], true)) {
    $lang = 'pt';
}

function issue_article_count_cache_file(string $pid, string $lang): string
{
    return __DIR__ . '/tmpSQL/issue_article_count_' . sha1($pid . '|' . $lang) . '.json';
}

function issue_article_count_from_toc_xml(string $pid, string $lang): ?int
{
    $cacheFile = issue_article_count_cache_file($pid, $lang);
    if (is_file($cacheFile) && (time() - filemtime($cacheFile) < 3600)) {
        $cached = json_decode((string)@file_get_contents($cacheFile), true);
        if (is_array($cached) && isset($cached['count'])) {
            return (int)$cached['count'];
        }
    }

    $url = 'https://127.0.0.1/scielo.php?' . http_build_query([
        'script' => 'sci_issuetoc',
        'pid' => $pid,
        'lng' => $lang,
        'nrm' => 'iso',
        'debug' => 'xml',
    ], '', '&');
    $ctx = stream_context_create([
        'http' => [
            'method' => 'GET',
            'timeout' => 20,
            'ignore_errors' => true,
            'header' => "User-Agent: Educ@-IssueArticleCount/1.0\r\n",
        ],
        'ssl' => [
            'verify_peer' => false,
            'verify_peer_name' => false,
        ],
    ]);
    $xml = @file_get_contents($url, false, $ctx);
    if (!is_string($xml) || $xml === '' || strpos($xml, '<ARTICLE') === false) {
        return null;
    }

    $count = preg_match_all('/<ARTICLE(?:\s|>)/i', $xml);
    if ($count === false || $count < 1) {
        return null;
    }

    @file_put_contents($cacheFile, json_encode([
        'pid' => $pid,
        'lang' => $lang,
        'count' => $count,
        'cached_at' => gmdate('c'),
    ], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES));

    return (int)$count;
}

try {
    $count = issue_article_count_from_toc_xml($pid, $lang);

    $pdo = search_mvp_connect();
    if ($count === null) {
        $stmt = $pdo->prepare(
            "SELECT COUNT(*) FROM search_documents
             WHERE source_issue_pid = :pid"
        );
        $stmt->bindValue(':pid', $pid, PDO::PARAM_STR);
        $stmt->execute();
        $count = (int)$stmt->fetchColumn();
    }

    echo json_encode([
        'ok' => true,
        'pid' => $pid,
        'count' => $count,
    ], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
} catch (Throwable $e) {
    issue_article_count_error('Unable to count articles.', 500);
}
