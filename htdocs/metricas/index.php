<?php
declare(strict_types=1);

$lang = isset($_GET['lang']) ? strtolower((string)$_GET['lang']) : 'pt';
if (!in_array($lang, ['pt', 'es', 'en'], true)) {
    $lang = 'pt';
}

$content = [
    'pt' => [
        'title' => 'Sistema de Métricas e Indicadores',
        'subtitle' => 'Página em desenvolvimento',
        'message' => 'O Sistema de Métricas e Indicadores do Educ@ está em desenvolvimento. Em breve esta página reunirá informações de uso, indicadores e relatórios da coleção.',
        'home' => 'Voltar para a página inicial',
        'journals' => 'Lista de periódicos',
        'search' => 'Busca',
        'evaluation' => 'Avaliação de periódicos',
        'about' => 'Sobre o Educ@',
        'team' => 'Equipe Educ@',
    ],
    'es' => [
        'title' => 'Sistema de Métricas e Indicadores',
        'subtitle' => 'Página en desarrollo',
        'message' => 'El Sistema de Métricas e Indicadores de Educ@ está en desarrollo. Próximamente esta página reunirá información de uso, indicadores e informes de la colección.',
        'home' => 'Volver al inicio',
        'journals' => 'Lista de revistas',
        'search' => 'Búsqueda',
        'evaluation' => 'Evaluación de Revistas',
        'about' => 'Acerca de Educ@',
        'team' => 'Equipo Educ@',
    ],
    'en' => [
        'title' => 'Metrics and Indicators System',
        'subtitle' => 'Page under development',
        'message' => 'The Educ@ Metrics and Indicators System is under development. This page will soon provide usage information, indicators and collection reports.',
        'home' => 'Back to home',
        'journals' => 'Journal list',
        'search' => 'Search',
        'evaluation' => 'Journal Evaluation',
        'about' => 'About Educ@',
        'team' => 'Educ@ Team',
    ],
];

$page = $content[$lang];
$currentLangLabel = ['pt' => 'Português', 'es' => 'Español', 'en' => 'English'][$lang];
$langNames = [
    'pt' => ['pt' => 'Português', 'es' => 'Espanhol', 'en' => 'Inglês'],
    'es' => ['pt' => 'Portugués', 'es' => 'Español', 'en' => 'Inglés'],
    'en' => ['pt' => 'Portuguese', 'es' => 'Spanish', 'en' => 'English'],
][$lang];

$host = $_SERVER['HTTP_HOST'] ?? '127.0.0.1:8090';
$scheme = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off') ? 'https' : 'http';
$pageUrl = $scheme . '://' . $host . '/metricas/?lang=' . rawurlencode($lang);

function esc(string $value): string
{
    return htmlspecialchars($value, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8');
}

header('Content-Type: text/html; charset=UTF-8');
?>
<!doctype html>
<html lang="<?= esc($lang) ?>">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title><?= esc($page['title']) ?> - Educ@</title>
  <link rel="stylesheet" type="text/css" href="/design-system/1.0.0/css/bootstrap.css">
  <link rel="stylesheet" type="text/css" href="/design-system/1.0.0/css/article.css">
  <link rel="stylesheet" type="text/css" href="/css/scielo-ds-bridge.css?v=metricas-20260704-1">
  <?php include __DIR__ . '/../includes/google_tag.php'; ?>
</head>
<body class="serials-page about-page metricas-page" link="#0000ff" vlink="#800080" bgcolor="#ffffff">
  <a class="skip-link" href="#main-content">Ir para o conteúdo principal</a>
  <header class="serials-top-header" id="top">
    <div class="serials-topbar">
      <details class="home-main-menu">
        <summary class="serials-ghost-btn">&#9776; Menu</summary>
        <ul class="home-main-dropdown">
          <li><a href="/search_mvp.php?lang=<?= esc($lang) ?>"><?= esc($page['search']) ?></a></li>
          <li><a href="/scielo.php?script=sci_alphabetic&amp;lng=<?= esc($lang) ?>&amp;nrm=iso"><?= esc($page['journals']) ?></a></li>
          <li><a href="/avaliacao/?lang=<?= esc($lang) ?>"><?= esc($page['evaluation']) ?></a></li>
          <li><a href="https://educa.fcc.org.br/metricas/?lang=pt">Métricas e Indicadores</a></li>
          <li><a href="/about/?lang=<?= esc($lang) ?>"><?= esc($page['about']) ?></a></li>
          <li><a href="/equipe/equipe_p.htm"><?= esc($page['team']) ?></a></li>
        </ul>
      </details>
      <div class="serials-lang-menu">
        <button class="serials-ghost-btn serials-lang-btn" type="button" aria-haspopup="true" aria-expanded="false" aria-label="Language selector">
          &#127760; <?= esc($currentLangLabel) ?> &#9662;
        </button>
        <ul class="serials-lang-dropdown">
          <li><a href="/metricas/?lang=pt"><?= esc($langNames['pt']) ?></a></li>
          <li><a href="/metricas/?lang=es"><?= esc($langNames['es']) ?></a></li>
          <li><a href="/metricas/?lang=en"><?= esc($langNames['en']) ?></a></li>
        </ul>
      </div>
    </div>
    <div class="serials-branding">
      <a href="/scielo.php?lng=<?= esc($lang) ?>">
        <img alt="Educ@" src="/img/pt/scielobre.gif">
      </a>
    </div>
  </header>

  <section class="serials-breadcrumb">
    <div class="serials-breadcrumb-inner">
      <ol class="breadcrumb mb-0 ps-0">
        <li class="breadcrumb-item">
          <a href="/scielo.php?lng=<?= esc($lang) ?>" aria-label="Home">
            <svg class="serial-home-icon serial-home-icon-breadcrumb" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
              <path d="M3 11.5L12 4l9 7.5"></path>
              <path d="M5.5 10.5V20h5v-6h3v6h5v-9.5"></path>
            </svg>
          </a>
        </li>
        <li class="breadcrumb-item"><?= esc($page['title']) ?></li>
      </ol>
      <a class="btn btn-sm btn-secondary scielo__btn-with-icon--only serial-share-btn" href="mailto:?subject=<?= rawurlencode($page['title']) ?>&amp;body=<?= rawurlencode($pageUrl) ?>" aria-label="Compartilhar">
        <svg class="serial-share-icon" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
          <circle cx="18" cy="5" r="2.4"></circle>
          <circle cx="6" cy="12" r="2.4"></circle>
          <circle cx="18" cy="19" r="2.4"></circle>
          <path d="M8.2 11l7.6-4.4"></path>
          <path d="M8.2 13l7.6 4.4"></path>
        </svg>
        <span class="serial-share-caret">&#9662;</span>
      </a>
    </div>
  </section>

  <main id="main-content" tabindex="-1" class="serials-content about-wrap">
    <section class="about-intro">
      <h1><?= esc($page['title']) ?></h1>
      <p><?= esc($page['subtitle']) ?></p>
    </section>

    <section class="about-links about-content">
      <article class="about-section">
        <h2><?= esc($page['subtitle']) ?></h2>
        <p><?= esc($page['message']) ?></p>
        <p><a href="/scielo.php?lng=<?= esc($lang) ?>"><?= esc($page['home']) ?></a></p>
      </article>
    </section>

    <footer class="serials-footer">
      <div class="serials-footer-top">
        <div class="serials-footer-brand">
          <img alt="Educ@" src="/img/pt/scielobre.gif">
        </div>
        <div class="serials-footer-meta">
          <div class="name"><strong>Educ@</strong></div>
          <div class="serials-footer-fcc-brand"><img alt="Fundação Carlos Chagas" src="/img/fcc.png"></div>
          <div>Av. Prof. Francisco Morato, 1565 - Jd. Guedala</div>
          <div>05513-900 São Paulo - SP - Brasil</div>
          <div>
            <a class="email journal-footer-email serials-footer-email" href="mailto:educ@fcc.org.br">
              <svg class="journal-footer-email-icon" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
                <rect x="3" y="5" width="18" height="14" rx="2"></rect>
                <path d="M3 7l9 6 9-6"></path>
              </svg>
              <span>educ@fcc.org.br</span>
            </a>
          </div>
          <div class="social">
            <a class="social-link" aria-label="Instagram" href="https://www.instagram.com/fundacaocarloschagas/" target="_blank" rel="noopener noreferrer"><span class="social-icon social-instagram"></span></a>
            <a class="social-link" aria-label="LinkedIn" href="https://br.linkedin.com/company/fundacaocarloschagas" target="_blank" rel="noopener noreferrer"><span class="social-icon social-linkedin"></span></a>
            <a class="social-link" aria-label="Facebook" href="https://www.facebook.com/FundacaoCarlosChagasFCC/" target="_blank" rel="noopener noreferrer"><span class="social-icon social-facebook"></span></a>
            <a class="social-link" aria-label="YouTube" href="https://www.youtube.com/c/Funda%C3%A7%C3%A3oCarlosChagas-FCC" target="_blank" rel="noopener noreferrer"><span class="social-icon social-youtube"></span></a>
          </div>
        </div>
        <div class="serials-footer-license">
					<a href="https://creativecommons.org/licenses/by/4.0/" target="_blank" rel="license noopener noreferrer">
						<img alt="CC BY 4.0" src="https://licensebuttons.net/l/by/4.0/88x31.png"/>
					</a>
				</div>
      </div>
      <div class="serials-footer-open-access">
        <img alt="Open Access" src="/design-system/1.0.0/img/logo-open-access.svg">
        <a href="https://www.gov.br/funag/pt-br/centrais-de-conteudo/publicacoes/acesso-aberto" target="_blank" rel="noopener noreferrer">Leia a Declaração de Acesso Aberto</a>
      </div>
    </footer>
  </main>
  <div class="serials-template-utils">
    <a href="mailto:educ@fcc.org.br?subject=Reportar%20erro" class="serials-template-report">Reportar erro</a>
    <a href="#main-content" class="serials-template-accessibility" aria-label="Acessibilidade">A</a>
  </div>
  <script type="text/javascript" src="/js/educa-accessibility.js?v=20260615-details-1"></script>
</body>
</html>
