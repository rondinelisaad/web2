<?php

$pid = isset($_GET['pid']) ? trim($_GET['pid']) : '';
$page = isset($_GET['page']) ? trim($_GET['page']) : 'home';
$lang = isset($_GET['lng']) ? trim($_GET['lng']) : 'pt';
$nrm = isset($_GET['nrm']) ? trim($_GET['nrm']) : 'iso';

if (!preg_match('/^[0-9Xx-]{8,10}$/', $pid)) {
    http_response_code(404);
    echo 'Not found';
    exit;
}

if (!in_array($lang, array('pt', 'en', 'es'), true)) {
    $lang = 'pt';
}
if (!preg_match('/^[A-Za-z0-9_-]+$/', $nrm)) {
    $nrm = 'iso';
}

function serial_url($pid, $lang, $nrm) {
    return '/scielo.php?script=sci_serial&pid=' . rawurlencode($pid) . '&lng=' . rawurlencode($lang) . '&nrm=' . rawurlencode($nrm);
}

function issues_url($pid, $lang, $nrm) {
    return '/scielo.php?script=sci_issues&pid=' . rawurlencode($pid) . '&lng=' . rawurlencode($lang) . '&nrm=' . rawurlencode($nrm);
}

function read_file_text($path) {
    $text = @file_get_contents($path);
    return is_string($text) ? $text : '';
}

function page_has_pid($text, $pid) {
    $quoted = preg_quote($pid, '/');
    return preg_match('/pid=' . $quoted . '(?:&|&amp;|["\'])/i', $text)
        || preg_match('/var\s+pid\s*=\s*["\']' . $quoted . '["\']/i', $text)
        || preg_match('/ISSN(?:<\/span>)?:?\s*' . $quoted . '/i', strip_tags($text));
}

function find_journal_dir($pid) {
    static $cache = array();
    if (isset($cache[$pid])) {
        return $cache[$pid];
    }

    $base = __DIR__ . '/revistas';
    $iterator = new RecursiveIteratorIterator(
        new RecursiveDirectoryIterator($base, FilesystemIterator::SKIP_DOTS)
    );

    $matches = array();
    foreach ($iterator as $file) {
        if (!$file->isFile() || $file->getFilename() !== 'paboutj.htm') {
            continue;
        }
        $path = $file->getPathname();
        if (strpos($path, 'Paginas PrincipaisMODELO') !== false) {
            continue;
        }
        $text = read_file_text($path);
        if (page_has_pid($text, $pid)) {
            $matches[] = dirname($path);
        }
    }

    usort($matches, function ($a, $b) {
        $depthA = substr_count(str_replace('\\', '/', $a), '/');
        $depthB = substr_count(str_replace('\\', '/', $b), '/');
        if ($depthA === $depthB) {
            return strcmp($a, $b);
        }
        return $depthA - $depthB;
    });

    $cache[$pid] = isset($matches[0]) ? $matches[0] : '';
    return $cache[$pid];
}

function public_path($absolutePath) {
    return str_replace(__DIR__, '', $absolutePath);
}

function first_side_link($dir, $label) {
    $text = read_file_text($dir . '/paboutj.htm');
    if (!$text) {
        return '';
    }
    $pattern = '/<a\b[^>]*class=["\'][^"\']*list-group-item[^"\']*["\'][^>]*href=["\']([^"\']+)["\'][^>]*>(.*?)<\/a>/is';
    if (preg_match_all($pattern, $text, $matches, PREG_SET_ORDER)) {
        foreach ($matches as $match) {
            $linkText = trim(preg_replace('/\s+/', ' ', strip_tags($match[2])));
            if (stripos($linkText, $label) !== false) {
                return html_entity_decode($match[1], ENT_QUOTES | ENT_HTML5, 'UTF-8');
            }
        }
    }
    return '';
}

$allowedPages = array('home', 'site', 'about', 'policy', 'issues', 'board', 'instructions', 'contact', 'metrics');
if (!in_array($page, $allowedPages, true)) {
    $page = 'home';
}

$dir = find_journal_dir($pid);
$target = '';

if ($page === 'home') {
    $target = serial_url($pid, $lang, $nrm);
} elseif ($page === 'issues') {
    $target = issues_url($pid, $lang, $nrm);
} elseif ($page === 'metrics') {
    $target = 'https://educa.fcc.org.br/metricas/?lang=pt';
} elseif ($dir) {
    if ($page === 'about' || $page === 'policy') {
        $target = public_path($dir . '/paboutj.htm');
    } elseif ($page === 'board') {
        $target = public_path($dir . '/pedboard.htm');
    } elseif ($page === 'instructions') {
        $target = public_path($dir . '/pinstruc.htm');
    } elseif ($page === 'site') {
        $target = first_side_link($dir, 'Site do periódico');
        if (!$target) {
            $target = serial_url($pid, $lang, $nrm);
        }
    } elseif ($page === 'contact') {
        $target = first_side_link($dir, 'Contato');
        if (!$target) {
            $target = 'mailto:educ@fcc.org.br';
        }
    }
}

if (!$target) {
    $target = serial_url($pid, $lang, $nrm);
}

header('Location: ' . $target, true, 302);
exit;
