<?php
declare(strict_types=1);

$lang = isset($_GET['lang']) ? strtolower((string)$_GET['lang']) : 'pt';
if (!in_array($lang, ['pt', 'es', 'en'], true)) {
    $lang = 'pt';
}

$formUrl = 'https://docs.google.com/forms/d/e/1FAIpQLSfgz-mb4PfclwUTgKWNJ469H3NmmGQZVsnrsHw8iF26dyKhdw/viewform';
$criteriaUrl = 'https://cdn.fcc.org.br/PRODUCAO/sitefcc/documentos/crit%C3%A9rios%20e%20procedimentos_2026.pdf';

$content = [
    'pt' => [
        'title' => 'Avaliação de periódicos',
        'subtitle' => 'Processo de avaliação para admissão e permanência no Portal Educ@',
        'back' => 'Voltar para a página inicial',
        'lang' => 'Idioma',
        'paragraphs' => [
            'O processo de avaliação de periódicos para admissão ao Portal Educ@ se dá de forma contínua. Com isso, a solicitação de avaliação pode ser feita a qualquer momento por meio do preenchimento do {form}.',
            'Para ingressar no Portal, o periódico deve aceitar e seguir os pré-requisitos e critérios dispostos no documento {criteria}.',
            'A operacionalização do processo de ingresso e de permanência dos periódicos no Educ@ é de responsabilidade da equipe técnica, de pareceristas ad hoc, do Comitê Científico e do Comitê Assessor, com comprovada experiência de produção e divulgação científica na área de educação.',
            'Recomenda-se que, antes de iniciar a submissão, o/a editor/a responsável realize uma autoavaliação do periódico com base nos pré-requisitos e critérios estabelecidos no documento mencionado, a fim de viabilizar o processo, agilizar o cumprimento de aspectos formais e evitar possíveis devoluções e atrasos na avaliação.',
            'Em caso de dúvidas, contate-nos através do e-mail {email}.',
        ],
        'form_label' => 'Formulário para submissão de periódicos',
        'criteria_label' => 'Critérios e procedimentos para a admissão e a permanência de periódicos científicos',
    ],
    'es' => [
        'title' => 'Evaluación de Revistas',
        'subtitle' => 'Proceso de evaluación para admisión y permanencia en el Portal Educ@',
        'back' => 'Volver a la página inicial',
        'lang' => 'Idioma',
        'paragraphs' => [
            'El proceso de evaluación de revistas para admisión al Portal Educ@ se realiza de forma continua. Por lo tanto, la solicitud de evaluación puede realizarse en cualquier momento mediante el llenado del {form}.',
            'Para ingresar al Portal, la revista debe aceptar y seguir los prerrequisitos y criterios establecidos en el documento {criteria}.',
            'La operacionalización del proceso de ingreso y permanencia de las revistas en Educ@ es responsabilidad del equipo técnico, de revisores ad hoc, del Comité Científico y del Comité Asesor, con experiencia comprobada en producción y divulgación científica en el área de educación.',
            'Se recomienda que, antes de iniciar la presentación, el/la editor/a responsable realice una autoevaluación de la revista con base en los prerrequisitos y criterios establecidos en el documento mencionado, con el fin de viabilizar el proceso, agilizar el cumplimiento de aspectos formales y evitar posibles devoluciones y retrasos en la evaluación.',
            'En caso de dudas, contáctenos a través del correo electrónico {email}.',
        ],
        'form_label' => 'Formulario para presentación de revistas',
        'criteria_label' => 'Criterios y procedimientos para la admisión y permanencia de revistas científicas',
    ],
    'en' => [
        'title' => 'Journal Evaluation',
        'subtitle' => 'Evaluation process for admission and permanence in the Educ@ Portal',
        'back' => 'Back to home page',
        'lang' => 'Language',
        'paragraphs' => [
            'The journal evaluation process for admission to the Educ@ Portal is continuous. Therefore, an evaluation request may be submitted at any time by completing the {form}.',
            'To join the Portal, the journal must accept and follow the prerequisites and criteria set out in the document {criteria}.',
            'The operation of the admission and permanence process for journals in Educ@ is the responsibility of the technical team, ad hoc reviewers, the Scientific Committee, and the Advisory Committee, all with proven experience in scientific production and dissemination in the field of education.',
            'Before starting the submission, the responsible editor is advised to conduct a self-evaluation of the journal based on the prerequisites and criteria established in the document mentioned above, in order to support the process, speed up compliance with formal requirements, and avoid possible returns and delays in the evaluation.',
            'If you have questions, contact us by email at {email}.',
        ],
        'form_label' => 'Journal submission form',
        'criteria_label' => 'Criteria and procedures for the admission and permanence of scientific journals',
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
$pageUrl = $scheme . '://' . $host . '/avaliacao/?lang=' . rawurlencode($lang);

function esc(string $value): string
{
    return htmlspecialchars($value, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8');
}

function paragraph_html(string $paragraph, string $formUrl, string $formLabel, string $criteriaUrl, string $criteriaLabel): string
{
    $html = esc($paragraph);
    return strtr($html, [
        '{form}' => '<a href="' . esc($formUrl) . '" target="_blank" rel="noopener noreferrer">' . esc($formLabel) . '</a>',
        '{criteria}' => '<a href="' . esc($criteriaUrl) . '" target="_blank" rel="noopener noreferrer">' . esc($criteriaLabel) . '</a>',
        '{email}' => '<a href="mailto:educ@fcc.org.br">educ@fcc.org.br</a>',
    ]);
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
  <link rel="stylesheet" type="text/css" href="/css/scielo-ds-bridge.css?v=avaliacao-20260615-1">
  <?php include __DIR__ . '/../includes/google_tag.php'; ?>
</head>
<body class="serials-page about-page avaliacao-page" link="#0000ff" vlink="#800080" bgcolor="#ffffff">
  <a class="skip-link" href="#main-content">Ir para o conteúdo principal</a>
  <header class="serials-top-header" id="top">
    <div class="serials-topbar">
      <details class="home-main-menu">
        <summary class="serials-ghost-btn">&#9776; Menu</summary>
        <ul class="home-main-dropdown">
          <li><a href="/search_mvp.php?lang=<?= esc($lang) ?>">Busca</a></li>
          <li><a href="/scielo.php?script=sci_alphabetic&amp;lng=<?= esc($lang) ?>&amp;nrm=iso">Lista alfabética de periódicos</a></li>
          <li><a href="/avaliacao/?lang=<?= esc($lang) ?>">Avaliação de periódicos</a></li>
          <li><a href="https://educa.fcc.org.br/metricas/?lang=pt">Métricas e Indicadores</a></li>
          <li><a href="/about/?lang=<?= esc($lang) ?>">Sobre o Educ@</a></li>
          <li><a href="/equipe/equipe_p.htm">Equipe Educ@</a></li>
        </ul>
      </details>
      <div class="serials-lang-menu">
        <button class="serials-ghost-btn serials-lang-btn" type="button" aria-haspopup="true" aria-expanded="false" aria-label="Language selector">
          &#127760; <?= esc($currentLangLabel) ?> &#9662;
        </button>
        <ul class="serials-lang-dropdown">
          <li><a href="/avaliacao/?lang=pt"><?= esc($langNames['pt']) ?></a></li>
          <li><a href="/avaliacao/?lang=es"><?= esc($langNames['es']) ?></a></li>
          <li><a href="/avaliacao/?lang=en"><?= esc($langNames['en']) ?></a></li>
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
        <h2><?= esc($page['title']) ?></h2>
        <?php foreach ($page['paragraphs'] as $paragraph): ?>
          <p><?= paragraph_html($paragraph, $formUrl, $page['form_label'], $criteriaUrl, $page['criteria_label']) ?></p>
        <?php endforeach; ?>
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
