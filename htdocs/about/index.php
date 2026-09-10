<?php
declare(strict_types=1);

$lang = isset($_GET['lang']) ? strtolower((string)$_GET['lang']) : 'pt';
if (!in_array($lang, ['pt', 'es', 'en'], true)) {
    $lang = 'pt';
}

$t = [
    'pt' => [
        'title' => 'Sobre o Educ@',
        'subtitle' => 'Informações institucionais sobre o indexador Educ@',
        'back' => 'Voltar para a página inicial',
        'lang' => 'Idioma',
        'sections' => [
            [
                'heading' => 'Educ@',
                'paragraphs' => [
                    'O Educ@ está disponível on-line. Trata-se de um indexador que objetiva proporcionar um amplo acesso a coleções de periódicos científicos na área da educação.',
                    'O Educ@ foi implementado em 2010, por iniciativa da Fundação Carlos Chagas (FCC). Utilizando-se da metodologia SciELO para publicação em acesso aberto de periódicos científicos on-line, tem o propósito de ampliar a divulgação da produção acadêmica e científica da área de educação.',
                    'Permite a publicação eletrônica de edições completas de periódicos científicos (revistas, jornais, artigos, etc.), a organização de bases de dados bibliográficas e textos completos, com uma recuperação eficiente e imediata de textos a partir de seus conteúdos, bem como a preservação dos arquivos eletrônicos. Contém ainda procedimentos integrados para medir o uso e o impacto da literatura científica com indicadores estatísticos, a partir dos quais especialistas poderão analisar a literatura incluída na biblioteca. Os relatórios gerados por esses indicadores são baseados em critérios quantitativos e em técnicas e métodos bibliométricos.',
                    'A metodologia também inclui critérios de avaliação de revistas, baseados nos padrões internacionais de comunicação científica.',
                    'Este site usa cookies e outras tecnologias semelhantes para melhorar sua experiência de acordo com nossa Política de Privacidade.',
                ],
            ],
            [
                'heading' => 'Sobre este site',
                'paragraphs' => [
                    'O Educ@ utiliza-se da metodologia SciELO — Scientific Electronic Library Online, que é um modelo para a publicação eletrônica de periódicos científicos na internet. Especialmente desenvolvida para responder às necessidades da comunicação científica nos países em desenvolvimento e particularmente na América Latina e Caribe, a metodologia proporciona uma solução eficiente para assegurar a visibilidade e o acesso universal da literatura científica, contribuindo para a superação do fenômeno conhecido como "ciência perdida".',
                ],
            ],
            [
                'heading' => 'Ajuda',
                'paragraphs' => [
                    'A interface SciELO proporciona acesso à sua coleção de periódicos através de uma lista alfabética de títulos, ou por meio de uma lista de assuntos, ou ainda através de um módulo de pesquisa de títulos dos periódicos, por assunto, pelos nomes das instituições publicadoras e pelo local de publicação.',
                    'A interface também propicia acesso aos textos completos dos artigos através de um índice de autor e um índice de assuntos, ou por meio de um formulário de pesquisa de artigos, que busca os elementos que o compõem, tais como autor, palavras do título, assunto, palavras do texto e ano de publicação.',
                    'Clique nas opções marcadas com links no topo da página para ter acesso às páginas correspondentes.',
                ],
            ],
        ],
    ],
    'es' => [
        'title' => 'Acerca de Educ@',
        'subtitle' => 'Información institucional sobre el indexador Educ@',
        'back' => 'Volver a la página inicial',
        'lang' => 'Idioma',
        'sections' => [
            [
                'heading' => 'Educ@',
                'paragraphs' => [
                    'Educ@ se encuentra disponible en línea. Se trata de un indexador cuyo objetivo es proporcionar un amplio acceso a colecciones de revistas científicas en el área de la educación.',
                    'Educ@ fue implementado en el 2010, por iniciativa de la Fundação Carlos Chagas (FCC). Al utilizar la metodología SciELO para publicación en acceso abierto de revistas científicas en línea, tiene el propósito de ampliar la divulgación de la producción académica y científica del área de la educación.',
                    'Permite la publicación electrónica de ediciones completas de revistas científicas (revistas, diarios, artículos, etc.), la organización de bases de datos bibliográficas y textos completos, con una recuperación eficiente e inmediata de textos a partir de sus contenidos, así como la preservación de los archivos electrónicos. También contiene procedimientos integrados para medir el uso y el impacto de la literatura científica con indicadores estadísticos, a partir de los cuales los expertos podrán analizar la literatura incluida en la biblioteca. Los informes generados por dichos indicadores se basan en criterios cuantitativos y en técnicas y métodos bibliométricos.',
                    'La metodología también incluye criterios de evaluación de revistas en base a los estándares internacionales de comunicación científica.',
                    'Este sitio web utiliza cookies y otras tecnologías similares para mejorar su experiencia de acuerdo con nuestra Política de Privacidad.',
                ],
            ],
            [
                'heading' => 'Acerca de este sitio',
                'paragraphs' => [
                    'Educ@ utiliza la metodología SciELO – Scientific Electronic Library Online, que es un modelo para la publicación electrónica de revistas científicas en la internet. Especialmente desarrollada para responder a las necesidades de la comunicación científica en los países en desarrollo y sobre todo en América Latina y el Caribe, la metodología proporciona una solución eficiente para asegurar la visibilidad y el acceso universal de la literatura científica, contribuyendo así para superar el fenómeno conocido como “ciencia perdida”.',
                ],
            ],
            [
                'heading' => 'Ayuda',
                'paragraphs' => [
                    'La interfaz SciELO proporciona acceso a su colección de revistas a través de una lista alfabética de títulos, o por medio de una lista de temas, o aún a través de un módulo de investigación de títulos de las revistas, por tema, por los nombres de las instituciones publicadoras y por el sitio de publicación.',
                    'La interfaz también propicia acceso a los textos completos de los artículos a través de un índice de autor y un índice de temas, o por medio de un formulario de investigación de artículos, que busca los elementos que los componen, como autor, palabras del título, tema, palabras del texto y año de publicación.',
                    'Haga un clic en las opciones marcadas con enlaces en la parte superior de la página para tener acceso a las páginas correspondientes.',
                ],
            ],
        ],
    ],
    'en' => [
        'title' => 'About Educ@',
        'subtitle' => 'Institutional information about the Educ@ indexing database',
        'back' => 'Back to home page',
        'lang' => 'Language',
        'sections' => [
            [
                'heading' => 'Educ@',
                'paragraphs' => [
                    'Educ@ is available online. It is an indexing database that provides broad access to collections of scholarly journals in education.',
                    'It was implemented in 2010 as an endeavor of Fundação Carlos Chagas (FCC). It uses the SciELO publishing schema to publish online journals on an open access basis in order to enhance the dissemination of academic and scientific output in education.',
                    'The database allows publishing full editions of journals, organizing bibliographic and full-text databases with efficient, immediate retrieval of texts based on their contents, and preserving electronic files. Educ@ includes integrated procedures to measure the use and impact of scientific literature through statistical indices, which can be used by experts to analyze the literature feature in the library. The reports generated through these indices are based on quantitative criteria and bibliometrics techniques and methods.',
                    'The methodology also includes journal evaluation criteria that are based on international standards of scientific communication.',
                    'This website uses cookies and other similar technologies to improve your experience in accordance with our Privacy Policy.',
                ],
            ],
            [
                'heading' => 'About this site',
                'paragraphs' => [
                    'Educ@ uses the SciELO – Scientific Electronic Library Online – publishing schema, which is a model for electronic publication of scholarly journals. Especially designed to meet the scientific communication needs of developing countries, particularly in Latin America and the Caribbean, the methodology provides an efficient solution to ensure visibility for and universal access to scientific literature, thus helping to overcome the “lost science” phenomenon.',
                ],
            ],
            [
                'heading' => 'Help',
                'paragraphs' => [
                    'The SciELO interface allows access to its journal collection through an alphabetical list of titles, list of subjects, or a journal title search module organized by subject, publisher, and place of publication.',
                    'The interface also provides access to the full text of articles through an author index, a subject index, or an article search form that searches for elements such as author, title words, subject, text words, and publication year.',
                    'Click on the links at the top of the page to access the respective pages.',
                ],
            ],
        ],
    ],
];

$page = $t[$lang];
$currentLangLabel = ['pt' => 'Português', 'es' => 'Español', 'en' => 'English'][$lang];
$langNames = [
    'pt' => ['pt' => 'Português', 'es' => 'Espanhol', 'en' => 'Inglês'],
    'es' => ['pt' => 'Portugués', 'es' => 'Español', 'en' => 'Inglés'],
    'en' => ['pt' => 'Portuguese', 'es' => 'Spanish', 'en' => 'English'],
][$lang];
$host = $_SERVER['HTTP_HOST'] ?? '127.0.0.1:8090';
$scheme = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off') ? 'https' : 'http';
$aboutUrl = $scheme . '://' . $host . '/about/?lang=' . rawurlencode($lang);

function about_paragraph_html(string $paragraph): string
{
    $html = htmlspecialchars($paragraph, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8');
    $privacyUrl = 'https://www.fcc.org.br/politicaprivacidade';
    $replacements = [
        'Política de Privacidade' => '<a href="' . $privacyUrl . '" target="_blank" rel="noopener noreferrer">Política de Privacidade</a>',
        'Política de Privacidad' => '<a href="' . $privacyUrl . '" target="_blank" rel="noopener noreferrer">Política de Privacidad</a>',
        'Privacy Policy' => '<a href="' . $privacyUrl . '" target="_blank" rel="noopener noreferrer">Privacy Policy</a>',
    ];
    return strtr($html, $replacements);
}

header('Content-Type: text/html; charset=UTF-8');
?>
<!doctype html>
<html lang="<?php echo htmlspecialchars($lang, ENT_QUOTES, 'UTF-8'); ?>">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title><?php echo htmlspecialchars($page['title'], ENT_QUOTES, 'UTF-8'); ?> - Educ@</title>
  <link rel="stylesheet" type="text/css" href="/design-system/1.0.0/css/bootstrap.css">
  <link rel="stylesheet" type="text/css" href="/design-system/1.0.0/css/article.css">
  <link rel="stylesheet" type="text/css" href="/css/scielo-ds-bridge.css?v=about-20260615-1">
  <?php include __DIR__ . '/../includes/google_tag.php'; ?>
</head>
<body class="serials-page about-page" link="#0000ff" vlink="#800080" bgcolor="#ffffff">
  <a class="skip-link" href="#main-content">Ir para o conteúdo principal</a>
  <header class="serials-top-header" id="top">
    <div class="serials-topbar">
      <details class="home-main-menu">
        <summary class="serials-ghost-btn">&#9776; Menu</summary>
        <ul class="home-main-dropdown">
          <li><a href="/search_mvp.php?lang=<?php echo htmlspecialchars($lang, ENT_QUOTES, 'UTF-8'); ?>">Busca</a></li>
          <li><a href="/scielo.php?script=sci_alphabetic&amp;lng=<?php echo htmlspecialchars($lang, ENT_QUOTES, 'UTF-8'); ?>&amp;nrm=iso">Lista alfabética de periódicos</a></li>
          <li><a href="/avaliacao/">Avaliação de periódicos</a></li>
          <li><a href="https://educa.fcc.org.br/metricas/?lang=pt">Métricas e Indicadores</a></li>
          <li><a href="/about/?lang=<?php echo htmlspecialchars($lang, ENT_QUOTES, 'UTF-8'); ?>">Sobre o Educ@</a></li>
          <li><a href="/equipe/equipe_p.htm">Equipe Educ@</a></li>
        </ul>
      </details>
      <div class="serials-lang-menu">
        <button class="serials-ghost-btn serials-lang-btn" type="button" aria-haspopup="true" aria-expanded="false" aria-label="Language selector">
          &#127760; <?php echo htmlspecialchars($currentLangLabel, ENT_QUOTES, 'UTF-8'); ?> &#9662;
        </button>
        <ul class="serials-lang-dropdown">
          <li><a href="/about/?lang=pt"><?php echo htmlspecialchars($langNames['pt'], ENT_QUOTES, 'UTF-8'); ?></a></li>
          <li><a href="/about/?lang=es"><?php echo htmlspecialchars($langNames['es'], ENT_QUOTES, 'UTF-8'); ?></a></li>
          <li><a href="/about/?lang=en"><?php echo htmlspecialchars($langNames['en'], ENT_QUOTES, 'UTF-8'); ?></a></li>
        </ul>
      </div>
    </div>
    <div class="serials-branding">
      <a href="/scielo.php?lng=<?php echo htmlspecialchars($lang, ENT_QUOTES, 'UTF-8'); ?>">
        <img alt="Educ@" src="/img/pt/scielobre.gif">
      </a>
    </div>
  </header>

  <section class="serials-breadcrumb">
    <div class="serials-breadcrumb-inner">
      <ol class="breadcrumb mb-0 ps-0">
        <li class="breadcrumb-item">
          <a href="/scielo.php?lng=<?php echo htmlspecialchars($lang, ENT_QUOTES, 'UTF-8'); ?>" aria-label="Home">
            <svg class="serial-home-icon serial-home-icon-breadcrumb" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
              <path d="M3 11.5L12 4l9 7.5"></path>
              <path d="M5.5 10.5V20h5v-6h3v6h5v-9.5"></path>
            </svg>
          </a>
        </li>
        <li class="breadcrumb-item"><?php echo htmlspecialchars($page['title'], ENT_QUOTES, 'UTF-8'); ?></li>
      </ol>
      <a class="btn btn-sm btn-secondary scielo__btn-with-icon--only serial-share-btn" href="mailto:?subject=<?php echo rawurlencode($page['title']); ?>&amp;body=<?php echo rawurlencode($aboutUrl); ?>" aria-label="Compartilhar">
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
      <h1><?php echo htmlspecialchars($page['title'], ENT_QUOTES, 'UTF-8'); ?></h1>
      <p><?php echo htmlspecialchars($page['subtitle'], ENT_QUOTES, 'UTF-8'); ?></p>
    </section>

    <section class="about-links about-content">
      <?php foreach ($page['sections'] as $section): ?>
        <article class="about-section">
          <h2><?php echo htmlspecialchars($section['heading'], ENT_QUOTES, 'UTF-8'); ?></h2>
          <?php foreach ($section['paragraphs'] as $paragraph): ?>
            <p><?php echo about_paragraph_html($paragraph); ?></p>
          <?php endforeach; ?>
        </article>
      <?php endforeach; ?>
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
