<?php
declare(strict_types=1);

header('Content-Type: application/json; charset=utf-8');
header('Cache-Control: public, max-age=300');

$lang = isset($_GET['lang']) ? (string)$_GET['lang'] : 'pt';
$limit = isset($_GET['limit']) ? (int)$_GET['limit'] : 8;

if (!in_array($lang, array('pt', 'en', 'es'), true)) {
    $lang = 'pt';
}
if ($limit < 1) {
    $limit = 1;
}
if ($limit > 12) {
    $limit = 12;
}
$refresh = isset($_GET['refresh']) && (string)$_GET['refresh'] === '1';
$cacheTtl = 300;
$cacheFile = rtrim((string)sys_get_temp_dir(), '/\\') . '/fcc_news_cache_' . $lang . '_' . $limit . '.json';
if (!$refresh && is_file($cacheFile) && (time() - (int)@filemtime($cacheFile) <= $cacheTtl)) {
    $cached = @file_get_contents($cacheFile);
    if (is_string($cached) && $cached !== '') {
        echo $cached;
        exit;
    }
}

$url = 'https://www.fcc.org.br/noticias/feed/';
$context = stream_context_create(array(
    'http' => array(
        'method' => 'GET',
        'timeout' => 10,
        'header' => "User-Agent: SciELO-Web/1.0\r\nAccept: application/rss+xml, application/xml, text/xml;q=0.9, */*;q=0.8\r\n",
    ),
));

$posts = array();

function fcc_trim_text(string $text, int $max = 180): string
{
    $text = trim((string)preg_replace('/\s+/', ' ', strip_tags($text)));
    if ($text === '') {
        return '';
    }
    if (function_exists('mb_strlen') && function_exists('mb_substr')) {
        if (mb_strlen($text) > $max) {
            return mb_substr($text, 0, $max - 3) . '...';
        }
        return $text;
    }
    if (strlen($text) > $max) {
        return substr($text, 0, $max - 3) . '...';
    }
    return $text;
}

function fcc_build_link($slug): string
{
    $slug = trim((string)$slug);
    if ($slug === '') {
        return 'https://www.fcc.org.br/noticias/todas';
    }
    if (preg_match('#^https?://#i', $slug)) {
        return $slug;
    }
    if ($slug[0] !== '/') {
        $slug = '/' . $slug;
    }
    return 'https://www.fcc.org.br' . $slug;
}

function fcc_build_image_url($url): string
{
    $url = trim((string)$url);
    if ($url === '') {
        return '';
    }
    if (preg_match('#^https?://#i', $url)) {
        return $url;
    }
    return 'https://cdn.fcc.org.br/PRODUCAO/' . ltrim($url, '/');
}

// Fonte primária: API oficial da FCC usada na página /noticias/todas
$apiUrl = 'https://www.fcc.org.br/apisite/v1/Container/GetFiltroCategoriaChildren?Tema=fcc-noticia&PageNumber=0&PageSize='
    . $limit
    . '&FiltroCategoria=false&FiltroChildren=false&Publicado=true';
$apiRaw = @file_get_contents($apiUrl, false, $context);
$apiData = json_decode((string)$apiRaw, true);
if (is_array($apiData)) {
    $apiItems = array();
    if (isset($apiData['item']) && is_array($apiData['item'])) {
        $apiItems = $apiData['item'];
    } else {
        $apiItems = $apiData;
    }
    foreach ($apiItems as $item) {
        if (!is_array($item)) {
            continue;
        }
        $title = trim((string)($item['titulo'] ?? ''));
        $link = fcc_build_link($item['slug'] ?? '');
        $date = trim((string)($item['dtmanut'] ?? ''));
        $excerpt = fcc_trim_text((string)($item['resumo'] ?? ''));
        $image = '';
        if (isset($item['imagemdestaque'])) {
            if (is_array($item['imagemdestaque'])) {
                $image = fcc_build_image_url($item['imagemdestaque']['url'] ?? '');
            } elseif (is_string($item['imagemdestaque'])) {
                $parsedImg = json_decode($item['imagemdestaque'], true);
                if (is_array($parsedImg)) {
                    $image = fcc_build_image_url($parsedImg['url'] ?? '');
                } else {
                    $image = fcc_build_image_url($item['imagemdestaque']);
                }
            }
        }
        if ($title === '') {
            continue;
        }
        $posts[] = array(
            'title' => $title,
            'link' => $link,
            'date' => $date,
            'image' => $image,
            'excerpt' => $excerpt,
        );
        if (count($posts) >= $limit) {
            break;
        }
    }
}

if (!$posts) {
    // Fallback 1: RSS
    $raw = @file_get_contents($url, false, $context);
    if ($raw !== false) {
        libxml_use_internal_errors(true);
        $xml = simplexml_load_string((string)$raw, 'SimpleXMLElement', LIBXML_NOCDATA);
        libxml_clear_errors();

        if ($xml && isset($xml->channel->item)) {
            foreach ($xml->channel->item as $item) {
                $title = trim((string) $item->title);
                $link = trim((string) $item->link);
                $date = trim((string) $item->pubDate);
                $excerpt = fcc_trim_text((string) $item->description);
                if ($title === '' || $link === '') {
                    continue;
                }
                $posts[] = array(
                    'title' => $title,
                    'link' => $link,
                    'date' => $date,
                    'image' => '',
                    'excerpt' => $excerpt,
                );
                if (count($posts) >= $limit) {
                    break;
                }
            }
        }
    }
}

if (!$posts) {
    // Fallback: tenta endpoint WordPress JSON
    $jsonUrl = 'https://www.fcc.org.br/wp-json/wp/v2/posts?per_page=' . $limit . '&_embed';
    $rawJson = @file_get_contents($jsonUrl, false, $context);
    $decoded = json_decode((string)$rawJson, true);
    if (is_array($decoded)) {
        foreach ($decoded as $item) {
            if (!is_array($item)) {
                continue;
            }

            $title = '';
            if (isset($item['title']) && is_array($item['title']) && isset($item['title']['rendered'])) {
                $title = trim(strip_tags((string) $item['title']['rendered']));
            }

            $excerpt = '';
            if (isset($item['excerpt']) && is_array($item['excerpt']) && isset($item['excerpt']['rendered'])) {
                $excerpt = fcc_trim_text((string) $item['excerpt']['rendered']);
            }

            $link = isset($item['link']) ? (string) $item['link'] : '';
            $date = isset($item['date']) ? (string) $item['date'] : '';
            $image = '';

            if (isset($item['_embedded']['wp:featuredmedia'][0]) && is_array($item['_embedded']['wp:featuredmedia'][0])) {
                $media = $item['_embedded']['wp:featuredmedia'][0];
                if (isset($media['media_details']['sizes']) && is_array($media['media_details']['sizes'])) {
                    $sizes = $media['media_details']['sizes'];
                    if (isset($sizes['medium_large']['source_url'])) {
                        $image = (string) $sizes['medium_large']['source_url'];
                    } elseif (isset($sizes['medium']['source_url'])) {
                        $image = (string) $sizes['medium']['source_url'];
                    } elseif (isset($sizes['thumbnail']['source_url'])) {
                        $image = (string) $sizes['thumbnail']['source_url'];
                    }
                }
                if ($image === '' && isset($media['source_url'])) {
                    $image = (string) $media['source_url'];
                }
            }

            if ($title === '' || $link === '') {
                continue;
            }

            $posts[] = array(
                'title' => $title,
                'link' => $link,
                'date' => $date,
                'image' => $image,
                'excerpt' => $excerpt,
            );
            if (count($posts) >= $limit) {
                break;
            }
        }
    }
}

if (!$posts) {
    // Fallback 2: scraping simples da página de notícias
    $htmlUrl = 'https://www.fcc.org.br/noticias/';
    $htmlContext = stream_context_create(array(
        'http' => array(
            'method' => 'GET',
            'timeout' => 10,
            'header' => "User-Agent: Mozilla/5.0\r\nAccept: text/html,*/*;q=0.8\r\n",
        ),
    ));
    $rawHtml = @file_get_contents($htmlUrl, false, $htmlContext);
    if (is_string($rawHtml) && $rawHtml !== '') {
        libxml_use_internal_errors(true);
        $dom = new DOMDocument();
        if (@$dom->loadHTML($rawHtml)) {
            $xpath = new DOMXPath($dom);
            $nodes = $xpath->query("//a[contains(@href,'/fcc-noticia/') or contains(@href,'/noticias/')]");
            $seen = array();
            if ($nodes) {
                foreach ($nodes as $node) {
                    $href = trim((string)$node->getAttribute('href'));
                    $title = trim(preg_replace('/\s+/', ' ', (string)$node->textContent));
                    if ($title !== '' && function_exists('mb_convert_encoding')) {
                        $title = mb_convert_encoding($title, 'UTF-8', 'UTF-8,ISO-8859-1,Windows-1252');
                    }
                    if (strpos($title, 'Ã') !== false || strpos($title, '�') !== false) {
                        continue;
                    }
                    if ($href === '' || $title === '') {
                        continue;
                    }
                    if (strpos($href, '/noticias') === false && strpos($href, '/fcc-noticia/') === false) {
                        continue;
                    }
                    $href = 'https://www.fcc.org.br/noticias/';
                    $seenKey = function_exists('mb_strtolower')
                        ? mb_strtolower($title, 'UTF-8')
                        : strtolower($title);
                    if (isset($seen[$seenKey])) {
                        continue;
                    }
                    $seen[$seenKey] = true;
                    $posts[] = array(
                        'title' => $title,
                        'link' => $href,
                        'date' => '',
                        'image' => '',
                        'excerpt' => '',
                    );
                    if (count($posts) >= $limit) {
                        break;
                    }
                }
            }
        }
        libxml_clear_errors();
    }
}

if (!$posts) {
    // Fallback final: links estáticos da FCC
    $posts = array();
}

if (count($posts) < $limit) {
    if ($lang === 'en') {
        $defaults = array(
            array('title' => 'Fundação Carlos Chagas News', 'excerpt' => 'Latest institutional updates from Fundação Carlos Chagas.'),
            array('title' => 'Latest FCC news', 'excerpt' => 'Read the latest announcements and highlights from FCC.'),
            array('title' => 'FCC institutional updates', 'excerpt' => 'Important updates, events and initiatives from FCC.'),
            array('title' => 'View all FCC news', 'excerpt' => 'Open the complete news page and browse all posts.'),
        );
    } elseif ($lang === 'es') {
        $defaults = array(
            array('title' => 'Noticias Fundação Carlos Chagas', 'excerpt' => 'Últimas actualizaciones institucionales de la Fundação Carlos Chagas.'),
            array('title' => 'Últimas noticias de la FCC', 'excerpt' => 'Lea los anuncios y destaques más recientes de la FCC.'),
            array('title' => 'Novedades institucionales de la FCC', 'excerpt' => 'Actualizaciones importantes, eventos e iniciativas de la FCC.'),
            array('title' => 'Ver todas las noticias de la FCC', 'excerpt' => 'Abra la página completa de noticias y vea todas las publicaciones.'),
        );
    } else {
        $defaults = array(
            array('title' => 'Notícias Fundação Carlos Chagas', 'excerpt' => 'Últimas atualizações institucionais da Fundação Carlos Chagas.'),
            array('title' => 'Últimas notícias da FCC', 'excerpt' => 'Leia os anúncios e destaques mais recentes da FCC.'),
            array('title' => 'Atualizações institucionais da FCC', 'excerpt' => 'Atualizações importantes, eventos e iniciativas da FCC.'),
            array('title' => 'Ver todas as notícias da FCC', 'excerpt' => 'Abra a página completa de notícias e veja todas as publicações.'),
        );
    }
    $seenTitles = array();
    foreach ($posts as $post) {
        $t = isset($post['title']) ? (string)$post['title'] : '';
        if ($t !== '') {
            $seenTitles[$t] = true;
        }
    }
    foreach ($defaults as $defaultItem) {
        if (count($posts) >= $limit) {
            break;
        }
        $title = isset($defaultItem['title']) ? (string)$defaultItem['title'] : '';
        $excerpt = isset($defaultItem['excerpt']) ? (string)$defaultItem['excerpt'] : '';
        if ($title === '') {
            continue;
        }
        if (isset($seenTitles[$title])) {
            continue;
        }
        $posts[] = array(
            'title' => $title,
            'link' => 'https://www.fcc.org.br/noticias/todas',
            'date' => '',
            'image' => '',
            'excerpt' => $excerpt,
        );
        $seenTitles[$title] = true;
    }
}

$response = json_encode(
    array(
        'lang' => $lang,
        'all_news_url' => 'https://www.fcc.org.br/noticias/todas',
        'posts' => $posts,
    ),
    JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES
);
if (!is_string($response) || $response === '') {
    $response = '{"lang":"' . $lang . '","all_news_url":"https://www.fcc.org.br/noticias/todas","posts":[]}';
}
@file_put_contents($cacheFile, $response, LOCK_EX);
echo $response;
