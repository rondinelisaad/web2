<?php

function article_plus_is_local_debug_enabled() {
    $remoteAddr = isset($_SERVER['REMOTE_ADDR']) ? $_SERVER['REMOTE_ADDR'] : '';
    return getenv('SCIELO_ENABLE_DEBUG') === '1'
        && ($remoteAddr === '127.0.0.1' || $remoteAddr === '::1');
}

$pid = isset($_REQUEST['pid']) && preg_match('/^[A-Za-z0-9._-]+$/', $_REQUEST['pid']) ? $_REQUEST['pid'] : '';
$lng = isset($_REQUEST['lng']) && preg_match('/^[a-z]{2}$/', $_REQUEST['lng']) ? $_REQUEST['lng'] : '';
$tlng = isset($_REQUEST['tlng']) && preg_match('/^[a-z]{2}$/', $_REQUEST['tlng']) ? $_REQUEST['tlng'] : '';
$debug = isset($_REQUEST['debug']) ? $_REQUEST['debug'] : '';

if ($pid && $tlng && $lng){

    $params = array(
        'script' => 'sci_arttext_plus',
        'pid' => $pid,
        'lng' => $lng,
        'tlng' => $tlng,
        'nrm' => 'iso'
    );

    if (($debug == 'XML' || $debug == 'On') && article_plus_is_local_debug_enabled()) {
        $params['debug'] = $debug;
    }

    $url = 'http://' . $_SERVER['SERVER_NAME'] . '/scielo.php?' . http_build_query($params, '', '&');
    $c = file_get_contents($url);
    if (strlen($c) == 0) {
    	header("Location: " . $url);
    } else {
    	echo $c;
    }
 }
?>
