<?php
declare(strict_types=1);

session_start();

require_once __DIR__ . '/applications/scielo-org/includes/phpmailer/class.phpmailer.php';

const REPORT_ERROR_MAX_MESSAGE_LENGTH = 10000;
const REPORT_ERROR_RATE_LIMIT_SECONDS = 300;
const REPORT_ERROR_RATE_LIMIT_MAX = 3;

function report_error_json(array $payload, int $status = 200): void
{
    http_response_code($status);
    header('Content-Type: application/json; charset=UTF-8');
    echo json_encode($payload, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
    exit;
}

function report_error_language(string $language): string
{
    $language = strtolower(substr($language, 0, 2));
    return in_array($language, ['pt', 'en', 'es'], true) ? $language : 'pt';
}

function report_error_client_ip(): string
{
    return isset($_SERVER['REMOTE_ADDR']) && filter_var($_SERVER['REMOTE_ADDR'], FILTER_VALIDATE_IP)
        ? $_SERVER['REMOTE_ADDR']
        : 'unknown';
}

function report_error_audit(string $result, string $resourceId, string $reason = ''): void
{
    $event = [
        'timestamp' => gmdate('c'),
        'user_id' => null,
        'ip_address' => report_error_client_ip(),
        'session_id' => session_id() ?: null,
        'action' => 'report_error.submit',
        'resource' => 'report_error',
        'resource_id' => $resourceId ?: null,
        'result' => $result,
    ];
    if ($reason !== '') {
        $event['reason'] = $reason;
    }
    error_log(json_encode($event, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES));
}

function report_error_text(string $language, string $key): string
{
    $labels = [
        'pt' => [
            'title' => 'Reportar erro',
            'intro' => 'Informe um problema encontrado nesta página.',
            'message' => 'O que aconteceu?',
            'email' => 'Seu e-mail (opcional)',
            'email_help' => 'Informe seu e-mail se desejar receber um retorno.',
            'send' => 'Enviar relato',
            'cancel' => 'Voltar',
            'success' => 'Relato enviado. Obrigado pela contribuição.',
            'error' => 'Não foi possível enviar o relato. Tente novamente mais tarde.',
            'required' => 'Descreva o problema antes de enviar.',
            'captcha' => 'Confirme que você não é um robô.',
        ],
        'en' => [
            'title' => 'Report an error',
            'intro' => 'Tell us about a problem found on this page.',
            'message' => 'What happened?',
            'email' => 'Your email (optional)',
            'email_help' => 'Add your email if you would like a reply.',
            'send' => 'Send report',
            'cancel' => 'Back',
            'success' => 'Report sent. Thank you for your contribution.',
            'error' => 'The report could not be sent. Please try again later.',
            'required' => 'Describe the problem before sending.',
            'captcha' => 'Please confirm that you are not a robot.',
        ],
        'es' => [
            'title' => 'Reportar error',
            'intro' => 'Informe un problema encontrado en esta página.',
            'message' => '¿Qué ocurrió?',
            'email' => 'Su correo electrónico (opcional)',
            'email_help' => 'Informe su correo si desea recibir una respuesta.',
            'send' => 'Enviar informe',
            'cancel' => 'Volver',
            'success' => 'Informe enviado. Gracias por su contribución.',
            'error' => 'No fue posible enviar el informe. Inténtelo nuevamente más tarde.',
            'required' => 'Describa el problema antes de enviar.',
            'captcha' => 'Confirme que no es un robot.',
        ],
    ];
    return $labels[$language][$key] ?? $labels['pt'][$key];
}

function report_error_verify_turnstile(string $token, string $remoteIp): bool
{
    $secret = trim((string)getenv('REPORT_ERROR_TURNSTILE_SECRET'));
    if ($secret === '' || $token === '') {
        return false;
    }

    $context = stream_context_create([
        'http' => [
            'method' => 'POST',
            'header' => "Content-Type: application/x-www-form-urlencoded\r\n",
            'content' => http_build_query([
                'secret' => $secret,
                'response' => $token,
                'remoteip' => $remoteIp,
            ]),
            'timeout' => 5,
            'ignore_errors' => true,
        ],
    ]);
    $response = @file_get_contents('https://challenges.cloudflare.com/turnstile/v0/siteverify', false, $context);
    if ($response === false) {
        return false;
    }
    $decoded = json_decode($response, true);
    return is_array($decoded) && !empty($decoded['success']);
}

function report_error_rate_limited(string $ip): bool
{
    $dir = sys_get_temp_dir() . '/educa-report-error-rate';
    if (!is_dir($dir) && !@mkdir($dir, 0700, true) && !is_dir($dir)) {
        return false;
    }
    $file = $dir . '/' . hash('sha256', $ip) . '.json';
    $now = time();
    $entries = [];
    if (is_file($file)) {
        $stored = json_decode((string)@file_get_contents($file), true);
        if (is_array($stored)) {
            $entries = array_values(array_filter($stored, static function ($timestamp) use ($now): bool {
                return is_int($timestamp) && ($now - $timestamp) < REPORT_ERROR_RATE_LIMIT_SECONDS;
            }));
        }
    }
    if (count($entries) >= REPORT_ERROR_RATE_LIMIT_MAX) {
        return true;
    }
    $entries[] = $now;
    @file_put_contents($file, json_encode($entries), LOCK_EX);
    return false;
}

function report_error_send_mail(string $subject, string $body, string $replyTo = ''): bool
{
    $host = trim((string)getenv('REPORT_ERROR_SMTP_HOST'));
    $port = (int)(getenv('REPORT_ERROR_SMTP_PORT') ?: 25);
    $from = trim((string)(getenv('REPORT_ERROR_FROM') ?: 'educ@fcc.org.br'));
    $to = trim((string)(getenv('REPORT_ERROR_TO') ?: 'educ@fcc.org.br'));
    if ($host === '' || !filter_var($from, FILTER_VALIDATE_EMAIL) || !filter_var($to, FILTER_VALIDATE_EMAIL)) {
        return false;
    }

    $mail = new PHPMailer();
    $mail->isSMTP();
    $mail->SMTPAuth = false;
    $mail->Host = $host;
    $mail->Port = $port > 0 ? $port : 25;
    $mail->SMTPSecure = '';
    $mail->CharSet = 'UTF-8';
    $mail->From = $from;
    $mail->FromName = 'Educ@';
    $mail->Subject = $subject;
    $mail->Body = $body;
    $mail->AltBody = $body;
    $mail->isHTML(false);
    $mail->AddAddress($to);
    if ($replyTo !== '' && filter_var($replyTo, FILTER_VALIDATE_EMAIL)) {
        $mail->AddReplyTo($replyTo);
    }
    return (bool)$mail->Send();
}

$language = report_error_language((string)($_REQUEST['lang'] ?? 'pt'));
$pid = preg_match('/^[A-Za-z0-9._-]{1,120}$/', (string)($_REQUEST['pid'] ?? ''))
    ? (string)$_REQUEST['pid']
    : '';
$pageUrl = filter_var((string)($_REQUEST['url'] ?? ''), FILTER_VALIDATE_URL) ?: '';
$siteKey = trim((string)getenv('REPORT_ERROR_TURNSTILE_SITE_KEY'));
$embedded = (string)($_REQUEST['embedded'] ?? '') === '1';
$message = '';
$success = false;

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $postedPid = preg_match('/^[A-Za-z0-9._-]{1,120}$/', (string)($_POST['pid'] ?? ''))
        ? (string)$_POST['pid']
        : '';
    $postedUrl = filter_var((string)($_POST['page_url'] ?? ''), FILTER_VALIDATE_URL) ?: '';
    $pid = $postedPid ?: $pid;
    $pageUrl = $postedUrl ?: $pageUrl;
    $report = trim((string)($_POST['report'] ?? ''));
    $email = trim((string)($_POST['email'] ?? ''));
    $honeypot = trim((string)($_POST['website'] ?? ''));
    $csrf = (string)($_POST['csrf_token'] ?? '');
    $token = (string)($_POST['cf-turnstile-response'] ?? '');

    if ($honeypot !== '' || !hash_equals((string)($_SESSION['report_error_csrf'] ?? ''), $csrf)) {
        report_error_audit('failure', $pid, 'invalid_request');
        $message = report_error_text($language, 'error');
    } elseif ($report === '' || strlen($report) > REPORT_ERROR_MAX_MESSAGE_LENGTH) {
        $message = report_error_text($language, 'required');
    } elseif (!empty($email) && !filter_var($email, FILTER_VALIDATE_EMAIL)) {
        $message = report_error_text($language, 'error');
    } elseif (report_error_rate_limited(report_error_client_ip())) {
        report_error_audit('failure', $pid, 'rate_limited');
        $message = report_error_text($language, 'error');
    } elseif (!report_error_verify_turnstile($token, report_error_client_ip())) {
        report_error_audit('failure', $pid, 'captcha_failed');
        $message = report_error_text($language, 'captcha');
    } else {
        $subject = 'Reportar erro' . ($pid !== '' ? ' - ' . $pid : '');
        $body = "Relato recebido pelo formulário Educ@\n\n" .
            'URL: ' . ($pageUrl ?: 'não informada') . "\n" .
            'ISSN: ' . ($pid ?: 'não informado') . "\n" .
            'Idioma: ' . $language . "\n" .
            'E-mail para retorno: ' . ($email ?: 'não informado') . "\n\n" .
            "Descrição do problema:\n" . $report . "\n";
        $success = report_error_send_mail($subject, $body, $email);
        report_error_audit($success ? 'success' : 'failure', $pid, $success ? '' : 'mail_failed');
        $message = $success ? report_error_text($language, 'success') : report_error_text($language, 'error');
    }
}

$_SESSION['report_error_csrf'] = bin2hex(random_bytes(32));
$csrfToken = $_SESSION['report_error_csrf'];
?><!doctype html>
<html lang="<?= htmlspecialchars($language, ENT_QUOTES, 'UTF-8') ?>">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title><?= htmlspecialchars(report_error_text($language, 'title'), ENT_QUOTES, 'UTF-8') ?> - Educ@</title>
  <?php if ($siteKey !== ''): ?><script src="https://challenges.cloudflare.com/turnstile/v0/api.js" async defer></script><?php endif; ?>
  <style>
    :root { color-scheme: light; font-family: Arial, sans-serif; color: #323f48; }
    body { margin: 0; background: #f3f4f5; }
    .report-shell { max-width: 760px; margin: 48px auto; padding: 0 20px; }
    .report-card { background: #fff; border: 1px solid #d9dde0; border-radius: 8px; box-shadow: 0 8px 24px rgba(50, 63, 72, .08); padding: 32px; }
    .report-brand { display: block; max-width: 150px; height: auto; margin: 0 auto 24px; }
    h1 { color: #323f48; font-size: 28px; margin: 0 0 8px; text-align: center; }
    .report-intro, .report-context { color: #5b6670; line-height: 1.5; }
    .report-context { background: #f7f8f9; border-left: 3px solid #8c1738; padding: 12px 16px; overflow-wrap: anywhere; }
    label { display: block; font-weight: 700; margin: 22px 0 8px; }
    textarea, input[type=email] { box-sizing: border-box; width: 100%; border: 1px solid #b8c0c6; border-radius: 4px; font: inherit; padding: 11px 12px; }
    textarea { min-height: 170px; resize: vertical; }
    .report-help { color: #66727b; font-size: 14px; margin-top: 6px; }
    .report-actions { align-items: center; display: flex; gap: 12px; justify-content: flex-end; margin-top: 24px; }
    .report-button { background: #8c1738; border: 1px solid #8c1738; border-radius: 4px; color: #fff; cursor: pointer; font: inherit; font-weight: 700; padding: 11px 18px; }
    .report-cancel { color: #323f48; text-decoration: none; }
    .report-status { background: #f7f8f9; border-left: 3px solid #8c1738; margin: 20px 0; padding: 12px 16px; }
    .report-status.success { border-left-color: #28734a; }
    .report-honeypot { left: -10000px; position: absolute; }
    @media (max-width: 600px) { .report-shell { margin: 20px auto; } .report-card { padding: 22px 18px; } .report-actions { align-items: stretch; flex-direction: column-reverse; } .report-cancel { text-align: center; } }
  </style>
</head>
<body>
  <main class="report-shell">
    <section class="report-card" aria-labelledby="report-title">
      <img class="report-brand" src="/img/pt/scielobre.gif" alt="Educ@">
      <h1 id="report-title"><?= htmlspecialchars(report_error_text($language, 'title'), ENT_QUOTES, 'UTF-8') ?></h1>
      <p class="report-intro"><?= htmlspecialchars(report_error_text($language, 'intro'), ENT_QUOTES, 'UTF-8') ?></p>
      <?php if ($message !== ''): ?><p class="report-status<?= $success ? ' success' : '' ?>" role="status"><?= htmlspecialchars($message, ENT_QUOTES, 'UTF-8') ?></p><?php endif; ?>
      <?php if (!$success): ?>
      <p class="report-context"><strong>URL:</strong> <?= htmlspecialchars($pageUrl ?: 'não informada', ENT_QUOTES, 'UTF-8') ?><br><strong>ISSN:</strong> <?= htmlspecialchars($pid ?: 'não informado', ENT_QUOTES, 'UTF-8') ?></p>
      <form method="post" action="/report_error.php">
        <input type="hidden" name="pid" value="<?= htmlspecialchars($pid, ENT_QUOTES, 'UTF-8') ?>">
        <input type="hidden" name="page_url" value="<?= htmlspecialchars($pageUrl, ENT_QUOTES, 'UTF-8') ?>">
        <input type="hidden" name="lang" value="<?= htmlspecialchars($language, ENT_QUOTES, 'UTF-8') ?>">
        <input type="hidden" name="embedded" value="<?= $embedded ? '1' : '0' ?>">
        <input type="hidden" name="csrf_token" value="<?= htmlspecialchars($csrfToken, ENT_QUOTES, 'UTF-8') ?>">
        <label class="report-honeypot" aria-hidden="true">Website<input type="text" name="website" tabindex="-1" autocomplete="off"></label>
        <label for="report-message"><?= htmlspecialchars(report_error_text($language, 'message'), ENT_QUOTES, 'UTF-8') ?></label>
        <textarea id="report-message" name="report" maxlength="<?= REPORT_ERROR_MAX_MESSAGE_LENGTH ?>" required></textarea>
        <label for="report-email"><?= htmlspecialchars(report_error_text($language, 'email'), ENT_QUOTES, 'UTF-8') ?></label>
        <input id="report-email" type="email" name="email" maxlength="254">
        <p class="report-help"><?= htmlspecialchars(report_error_text($language, 'email_help'), ENT_QUOTES, 'UTF-8') ?></p>
        <?php if ($siteKey !== ''): ?><div class="cf-turnstile" data-sitekey="<?= htmlspecialchars($siteKey, ENT_QUOTES, 'UTF-8') ?>"></div><?php endif; ?>
        <div class="report-actions"><a class="report-cancel" href="<?= $embedded ? '#' : 'javascript:history.back()' ?>"<?= $embedded ? ' onclick="window.parent.postMessage({type: \'educa-report-close\'}, window.location.origin); return false;"' : '' ?>><?= htmlspecialchars(report_error_text($language, 'cancel'), ENT_QUOTES, 'UTF-8') ?></a><button class="report-button" type="submit"><?= htmlspecialchars(report_error_text($language, 'send'), ENT_QUOTES, 'UTF-8') ?></button></div>
      </form>
      <?php endif; ?>
    </section>
  </main>
</body>
</html>
