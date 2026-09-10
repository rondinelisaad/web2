<?php
declare(strict_types=1);

require_once __DIR__ . '/search_mvp_lib.php';

$lang = (string)($_GET['lang'] ?? 'pt');
if (!in_array($lang, ['pt', 'es', 'en'], true)) {
    $lang = 'pt';
}

$labels = [
    'pt' => [
        'title' => 'Busca por Índice',
        'subtitle' => 'Filtro por título, resumo, autor, periódico e ano',
        'back' => 'Voltar para a Home',
        'search' => 'Buscar',
        'term' => 'Digite termo de busca',
        'all_fields' => 'Todos os campos',
        'title_field' => 'Título',
        'abstract_field' => 'Resumo',
        'author_field' => 'Autor',
        'journal_field' => 'Periódico',
        'year' => 'Ano',
        'year_from' => 'Ano inicial',
        'year_to' => 'Ano final',
        'add_field' => 'Adicionar outro campo',
        'boolean' => 'Operador',
        'remove_field' => 'Remover campo',
        'select_result' => 'Selecionar resultado',
        'selected_results' => 'resultados selecionados',
        'share_selected' => 'Compartilhar selecionados',
        'share_whatsapp' => 'WhatsApp',
        'share_telegram' => 'Telegram',
        'share_email' => 'E-mail',
        'export_csv' => 'Exportar CSV',
        'total' => 'Total',
        'page' => 'Página',
        'of' => 'de',
        'pid' => 'PID',
        'journal' => 'Periódico',
        'authors' => 'Autores',
        'prev' => '← Anterior',
        'next' => 'Próxima →',
        'no_results' => 'Nenhum resultado encontrado para os filtros informados.',
    ],
    'es' => [
        'title' => 'Búsqueda por Índice',
        'subtitle' => 'Filtro por título, resumen, autor, revista y año',
        'back' => 'Volver al inicio',
        'search' => 'Buscar',
        'term' => 'Ingrese término de búsqueda',
        'all_fields' => 'Todos los campos',
        'title_field' => 'Título',
        'abstract_field' => 'Resumen',
        'author_field' => 'Autor',
        'journal_field' => 'Revista',
        'year' => 'Año',
        'year_from' => 'Año inicial',
        'year_to' => 'Año final',
        'add_field' => 'Agregar otro campo',
        'boolean' => 'Operador',
        'remove_field' => 'Eliminar campo',
        'select_result' => 'Seleccionar resultado',
        'selected_results' => 'resultados seleccionados',
        'share_selected' => 'Compartir seleccionados',
        'share_whatsapp' => 'WhatsApp',
        'share_telegram' => 'Telegram',
        'share_email' => 'E-mail',
        'export_csv' => 'Exportar CSV',
        'total' => 'Total',
        'page' => 'Página',
        'of' => 'de',
        'pid' => 'PID',
        'journal' => 'Revista',
        'authors' => 'Autores',
        'prev' => '← Anterior',
        'next' => 'Siguiente →',
        'no_results' => 'No se encontraron resultados para los filtros informados.',
    ],
    'en' => [
        'title' => 'Indexed Search',
        'subtitle' => 'Filter by title, abstract, author, journal and year',
        'back' => 'Back to Home',
        'search' => 'Search',
        'term' => 'Enter search term',
        'all_fields' => 'All fields',
        'title_field' => 'Title',
        'abstract_field' => 'Abstract',
        'author_field' => 'Author',
        'journal_field' => 'Journal',
        'year' => 'Year',
        'year_from' => 'Start year',
        'year_to' => 'End year',
        'add_field' => 'Add another field',
        'boolean' => 'Operator',
        'remove_field' => 'Remove field',
        'select_result' => 'Select result',
        'selected_results' => 'selected results',
        'share_selected' => 'Share selected',
        'share_whatsapp' => 'WhatsApp',
        'share_telegram' => 'Telegram',
        'share_email' => 'Email',
        'export_csv' => 'Export CSV',
        'total' => 'Total',
        'page' => 'Page',
        'of' => 'of',
        'pid' => 'PID',
        'journal' => 'Journal',
        'authors' => 'Authors',
        'prev' => '← Previous',
        'next' => 'Next →',
        'no_results' => 'No results found for the selected filters.',
    ],
];
$t = $labels[$lang];

$advanced = [];
$advOps = is_array($_GET['adv_op'] ?? null) ? array_values($_GET['adv_op']) : [];
$advTerms = is_array($_GET['adv_q'] ?? null) ? array_values($_GET['adv_q']) : [];
$advFields = is_array($_GET['adv_field'] ?? null) ? array_values($_GET['adv_field']) : [];
$allowedAdvOps = ['AND', 'OR', 'AND NOT'];
$allowedAdvFields = ['all', 'title', 'abstract', 'author', 'journal'];
$advCount = max(count($advOps), count($advTerms), count($advFields));
for ($i = 0; $i < $advCount; $i++) {
    $term = (string)($advTerms[$i] ?? '');
    if (trim($term) === '') {
        continue;
    }
    $op = strtoupper((string)($advOps[$i] ?? 'AND'));
    if (!in_array($op, $allowedAdvOps, true)) {
        $op = 'AND';
    }
    $field = (string)($advFields[$i] ?? 'title');
    if (!in_array($field, $allowedAdvFields, true)) {
        $field = 'title';
    }
    $advanced[] = [
        'op' => $op,
        'q' => $term,
        'field' => $field,
    ];
}

$query = [
    'q' => (string)($_GET['q'] ?? ''),
    'field' => (string)($_GET['field'] ?? 'all'),
    'year' => (string)($_GET['year'] ?? ''),
    'year_from' => (string)($_GET['year_from'] ?? ''),
    'year_to' => (string)($_GET['year_to'] ?? ''),
    'author' => (string)($_GET['author'] ?? ''),
    'journal' => (string)($_GET['journal'] ?? ''),
    'advanced' => $advanced,
    'page' => (int)($_GET['page'] ?? 1),
    'per_page' => 20,
];

$result = search_mvp_search($query);

function esc(string $v): string
{
    return htmlspecialchars($v, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8');
}

function search_mvp_result_title(string $title): string
{
    $title = preg_replace('#<\s*sup\b[^>]*>.*?<\s*/\s*sup\s*>#isu', '', $title) ?? $title;
    $title = strip_tags($title);
    $title = html_entity_decode($title, ENT_QUOTES | ENT_HTML5, 'UTF-8');
    return preg_replace('/\s+/u', ' ', trim($title)) ?? '';
}

function search_mvp_lang_url(string $targetLang, array $query): string
{
    return '/search_mvp.php?' . http_build_query(search_mvp_request_query($query, [
        'lang' => $targetLang,
        'page' => 1,
    ]));
}

function search_mvp_request_query(array $query, array $extra = []): array
{
    $params = [
        'lang' => $extra['lang'] ?? ($query['lang'] ?? 'pt'),
        'q' => $query['q'],
        'field' => $query['field'],
        'journal' => $query['journal'],
        'year_from' => $query['year_from'],
        'year_to' => $query['year_to'],
        'page' => $extra['page'] ?? ($query['page'] ?? 1),
    ];
    foreach (($query['advanced'] ?? []) as $row) {
        $params['adv_op'][] = $row['op'];
        $params['adv_q'][] = $row['q'];
        $params['adv_field'][] = $row['field'];
    }
    return $params;
}

$languageNames = [
    'pt' => 'Português',
    'es' => 'Español',
    'en' => 'English',
];
$currentLangLabel = $languageNames[$lang];
$langNames = [
    'pt' => ['pt' => 'Português', 'es' => 'Espanhol', 'en' => 'Inglês'],
    'es' => ['pt' => 'Portugués', 'es' => 'Español', 'en' => 'Inglés'],
    'en' => ['pt' => 'Portuguese', 'es' => 'Spanish', 'en' => 'English'],
][$lang];
$host = $_SERVER['HTTP_HOST'] ?? '127.0.0.1:8090';
$scheme = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off') ? 'https' : 'http';
$pageUrl = $scheme . '://' . $host . '/search_mvp.php?' . http_build_query([
    'lang' => $lang,
    'q' => $query['q'],
    'field' => $query['field'],
    'journal' => $query['journal'],
    'year_from' => $query['year_from'],
    'year_to' => $query['year_to'],
    'page' => 1,
] + array_filter([
    'adv_op' => array_column($query['advanced'], 'op'),
    'adv_q' => array_column($query['advanced'], 'q'),
    'adv_field' => array_column($query['advanced'], 'field'),
]));
?>
<!doctype html>
<html lang="<?= esc($lang) ?>">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title><?= esc($t['title']) ?></title>
  <link rel="stylesheet" type="text/css" href="/design-system/1.0.0/css/bootstrap.css">
  <link rel="stylesheet" type="text/css" href="/design-system/1.0.0/css/article.css">
  <link rel="stylesheet" type="text/css" href="/css/scielo-ds-bridge.css?v=search-20260615-3">
  <?php include __DIR__ . '/includes/google_tag.php'; ?>
  <style>
    .mvp-shell { max-width: 1170px; margin: 0 auto; padding: 34px 15px 0; }
    .mvp-title { margin: 0 0 8px; font-size: 38px; line-height: 1.2; color: #00314c; font-weight: 700; }
    .mvp-subtitle { margin: 0; color: #5f6b7a; font-size: 15px; }
    .mvp-intro { margin: 0 0 24px; }
    .mvp-card { border: 1px solid #d6dde7; border-radius: 8px; background: #fff; padding: 16px; margin-bottom: 14px; }
    .mvp-form { display: grid; grid-template-columns: minmax(260px, 2fr) minmax(150px, 1fr) repeat(2, minmax(120px, .75fr)) auto; gap: 8px; }
    .mvp-form input, .mvp-form select, .mvp-form button { height: 40px; border: 1px solid #c7c7c7; border-radius: 4px; font-size: 14px; padding: 0 10px; }
    .mvp-form button { background: #7f1d3a; border-color: #7f1d3a; color: #fff; font-weight: 600; }
    .mvp-form button:hover, .mvp-form button:focus { background: #5f1429; border-color: #5f1429; color: #fff; }
    .mvp-advanced { grid-column: 1 / -1; display: grid; gap: 8px; margin-top: 2px; }
    .mvp-advanced-row { display: grid; grid-template-columns: 130px minmax(220px, 1fr) minmax(140px, 180px) auto; gap: 8px; }
    .mvp-add-field, .mvp-remove-field { justify-self: start; background: #fff !important; border-color: #c7c7c7 !important; color: #333 !important; }
    .mvp-add-field { grid-column: 1 / -1; }
    .mvp-add-field:hover, .mvp-add-field:focus, .mvp-remove-field:hover, .mvp-remove-field:focus { background: #f3f6fb !important; border-color: #9ca8ba !important; color: #00314c !important; }
    .mvp-remove-field { min-width: 40px; padding: 0 12px !important; }
    .mvp-meta { margin-top: 12px; color: #475569; font-size: 14px; }
    .mvp-sharebar { display: flex; flex-wrap: wrap; align-items: center; gap: 8px; margin: 0 0 12px; padding: 10px 12px; border: 1px solid #d6dde7; border-radius: 6px; background: #f8fafc; }
    .mvp-sharebar-title { margin-right: auto; color: #334155; font-size: 14px; font-weight: 700; }
    .mvp-share-action { min-height: 34px; padding: 6px 11px; border: 1px solid #c7c7c7; border-radius: 4px; background: #fff; color: #333; font-size: 14px; font-weight: 600; }
    .mvp-share-action:disabled { opacity: .5; cursor: not-allowed; }
    .mvp-share-action:not(:disabled):hover, .mvp-share-action:not(:disabled):focus { border-color: #9ca8ba; background: #f3f6fb; color: #00314c; }
    .mvp-item { display: grid; grid-template-columns: 28px minmax(0, 1fr); gap: 10px; border-top: 1px solid #e4e9f0; padding: 14px 0; }
    .mvp-item:first-child { border-top: 0; padding-top: 4px; }
    .mvp-item-select { width: 18px; height: 18px; margin-top: 4px; accent-color: #7f1d3a; }
    .mvp-item-body { min-width: 0; }
    .mvp-item-title { margin: 0 0 6px; font-size: 20px; line-height: 1.3; }
    .mvp-item-title a { color: #1f3f88; }
    .mvp-sub { color: #3b4a5e; font-size: 13px; margin-bottom: 4px; }
    .mvp-abs { color: #1f2937; font-size: 14px; line-height: 1.5; }
    .mvp-empty { color: #475569; padding: 8px 0 4px; }
    .mvp-pager { display: flex; flex-wrap: wrap; align-items: center; justify-content: center; gap: 6px; margin: 16px 0 24px; font-size: 14px; }
    .mvp-pager a, .mvp-pager span { display: inline-flex; align-items: center; justify-content: center; min-width: 34px; height: 34px; padding: 0 10px; border: 1px solid #d6dde7; border-radius: 4px; background: #fff; color: #315cad; font-weight: 700; text-decoration: none; }
    .mvp-pager a:hover, .mvp-pager a:focus { border-color: #315cad; background: #f3f6fb; color: #00314c; }
    .mvp-pager .is-current { border-color: #315cad; background: #315cad; color: #fff; }
    .mvp-pager .is-gap { min-width: 28px; border-color: transparent; background: transparent; color: #64748b; }
    @media (max-width: 992px) { .mvp-form, .mvp-advanced-row { grid-template-columns: 1fr; } .mvp-title { font-size: 30px; } }
  </style>
</head>
<body class="serials-page search-page" link="#0000ff" vlink="#800080" bgcolor="#ffffff">
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
          <li><a href="<?= esc(search_mvp_lang_url('pt', $query)) ?>"><?= esc($langNames['pt']) ?></a></li>
          <li><a href="<?= esc(search_mvp_lang_url('es', $query)) ?>"><?= esc($langNames['es']) ?></a></li>
          <li><a href="<?= esc(search_mvp_lang_url('en', $query)) ?>"><?= esc($langNames['en']) ?></a></li>
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
        <li class="breadcrumb-item"><?= esc($t['title']) ?></li>
      </ol>
      <a class="btn btn-sm btn-secondary scielo__btn-with-icon--only serial-share-btn" href="mailto:?subject=<?= rawurlencode($t['title']) ?>&amp;body=<?= rawurlencode($pageUrl) ?>" aria-label="Compartilhar">
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

  <main id="main-content" tabindex="-1" class="serials-content mvp-shell">
    <section class="mvp-intro">
      <h1 class="mvp-title"><?= esc($t['title']) ?></h1>
      <p class="mvp-subtitle"><?= esc($t['subtitle']) ?></p>
    </section>

    <section class="mvp-card">
      <form class="mvp-form" method="get" action="/search_mvp.php">
        <input type="hidden" name="lang" value="<?= esc($lang) ?>">
        <?php if ($query['journal'] !== ''): ?>
          <input type="hidden" name="journal" value="<?= esc($query['journal']) ?>">
        <?php endif; ?>
        <input type="text" name="q" placeholder="<?= esc($t['term']) ?>" value="<?= esc($query['q']) ?>">
        <select name="field">
          <option value="all" <?= $query['field'] === 'all' ? 'selected' : '' ?>><?= esc($t['all_fields']) ?></option>
          <option value="title" <?= $query['field'] === 'title' ? 'selected' : '' ?>><?= esc($t['title_field']) ?></option>
          <option value="abstract" <?= $query['field'] === 'abstract' ? 'selected' : '' ?>><?= esc($t['abstract_field']) ?></option>
          <option value="author" <?= $query['field'] === 'author' ? 'selected' : '' ?>><?= esc($t['author_field']) ?></option>
          <option value="journal" <?= $query['field'] === 'journal' ? 'selected' : '' ?>><?= esc($t['journal_field']) ?></option>
        </select>
        <input type="text" name="year_from" placeholder="<?= esc($t['year_from']) ?>" value="<?= esc($query['year_from']) ?>">
        <input type="text" name="year_to" placeholder="<?= esc($t['year_to']) ?>" value="<?= esc($query['year_to']) ?>">
        <button type="submit"><?= esc($t['search']) ?></button>
        <div class="mvp-advanced" id="mvpAdvancedFields">
          <?php foreach ($query['advanced'] as $row): ?>
            <div class="mvp-advanced-row">
              <select name="adv_op[]" aria-label="<?= esc($t['boolean']) ?>">
                <option value="AND" <?= $row['op'] === 'AND' ? 'selected' : '' ?>>AND</option>
                <option value="OR" <?= $row['op'] === 'OR' ? 'selected' : '' ?>>OR</option>
                <option value="AND NOT" <?= $row['op'] === 'AND NOT' ? 'selected' : '' ?>>AND NOT</option>
              </select>
              <input type="text" name="adv_q[]" placeholder="<?= esc($t['term']) ?>" value="<?= esc($row['q']) ?>">
              <select name="adv_field[]" aria-label="<?= esc($t['field'] ?? '') ?>">
                <option value="all" <?= $row['field'] === 'all' ? 'selected' : '' ?>><?= esc($t['all_fields']) ?></option>
                <option value="title" <?= $row['field'] === 'title' ? 'selected' : '' ?>><?= esc($t['title_field']) ?></option>
                <option value="abstract" <?= $row['field'] === 'abstract' ? 'selected' : '' ?>><?= esc($t['abstract_field']) ?></option>
                <option value="author" <?= $row['field'] === 'author' ? 'selected' : '' ?>><?= esc($t['author_field']) ?></option>
                <option value="journal" <?= $row['field'] === 'journal' ? 'selected' : '' ?>><?= esc($t['journal_field']) ?></option>
              </select>
              <button type="button" class="mvp-remove-field" aria-label="<?= esc($t['remove_field']) ?>">×</button>
            </div>
          <?php endforeach; ?>
        </div>
        <button type="button" class="mvp-add-field" id="mvpAddField"><?= esc($t['add_field']) ?></button>
      </form>
      <div class="mvp-meta">
        <?= esc($t['total']) ?>: <strong><?= (int)$result['total'] ?></strong> |
        <?= esc($t['page']) ?> <strong><?= (int)$result['page'] ?></strong> <?= esc($t['of']) ?> <strong><?= max(1, (int)$result['pages']) ?></strong>
      </div>
    </section>

    <section class="mvp-card">
      <?php if (empty($result['items'])): ?>
        <div class="mvp-empty"><?= esc($t['no_results']) ?></div>
      <?php endif; ?>
      <?php if (!empty($result['items'])): ?>
        <div class="mvp-sharebar" aria-label="<?= esc($t['share_selected']) ?>">
          <span class="mvp-sharebar-title"><span id="mvpSelectedCount">0</span> <?= esc($t['selected_results']) ?></span>
          <button type="button" class="mvp-share-action" data-share-selected="whatsapp" disabled><?= esc($t['share_whatsapp']) ?></button>
          <button type="button" class="mvp-share-action" data-share-selected="telegram" disabled><?= esc($t['share_telegram']) ?></button>
          <button type="button" class="mvp-share-action" data-share-selected="email" disabled><?= esc($t['share_email']) ?></button>
          <button type="button" class="mvp-share-action" data-share-selected="csv" disabled><?= esc($t['export_csv']) ?></button>
        </div>
      <?php endif; ?>
      <?php foreach ($result['items'] as $item): ?>
        <?php $cleanTitle = search_mvp_result_title((string)$item['title']); ?>
        <article class="mvp-item">
          <input
            type="checkbox"
            class="mvp-item-select"
            aria-label="<?= esc($t['select_result']) ?>"
            data-title="<?= esc($cleanTitle) ?>"
            data-url="<?= esc((string)$item['article_url']) ?>"
            data-journal="<?= esc((string)$item['journal_title']) ?>"
            data-year="<?= esc((string)$item['pub_year']) ?>">
          <div class="mvp-item-body">
            <h2 class="mvp-item-title">
              <a href="<?= esc((string)$item['article_url']) ?>" target="_blank" rel="noopener noreferrer">
                <?= esc($cleanTitle) ?>
              </a>
            </h2>
            <div class="mvp-sub">
              <?= esc($t['pid']) ?>: <?= esc((string)$item['pid']) ?> |
              <?= esc($t['journal']) ?>: <?= esc((string)$item['journal_title']) ?> (<?= esc((string)$item['journal_issn']) ?>) |
              <?= esc($t['year']) ?>: <?= esc((string)$item['pub_year']) ?>
            </div>
            <div class="mvp-sub"><?= esc($t['authors']) ?>: <?= esc((string)$item['authors']) ?></div>
            <div class="mvp-abs"><?= esc((string)$item['abstract_text']) ?></div>
          </div>
        </article>
      <?php endforeach; ?>
    </section>
    <?php
    $page = (int)$result['page'];
    $pages = max(1, (int)$result['pages']);
    $pageUrlFor = static function (int $targetPage): string {
        $qs = $_GET;
        $qs['page'] = $targetPage;
        return '/search_mvp.php?' . http_build_query($qs);
    };
    $pageNumbers = [];
    if ($pages > 1) {
        $candidates = array_unique(array_filter([
            1,
            2,
            $page - 2,
            $page - 1,
            $page,
            $page + 1,
            $page + 2,
            $pages - 1,
            $pages,
        ], static fn ($n) => $n >= 1 && $n <= $pages));
        sort($candidates);
        $pageNumbers = $candidates;
    }
    ?>
    <?php if ($pages > 1): ?>
      <nav class="mvp-pager" aria-label="Paginação de resultados">
        <?php if ($page > 1): ?>
          <a href="<?= esc($pageUrlFor($page - 1)) ?>" aria-label="<?= esc($t['prev']) ?>">‹</a>
        <?php endif; ?>
        <?php $lastRendered = 0; ?>
        <?php foreach ($pageNumbers as $pageNumber): ?>
          <?php if ($lastRendered && $pageNumber > $lastRendered + 1): ?>
            <span class="is-gap" aria-hidden="true">…</span>
          <?php endif; ?>
          <?php if ($pageNumber === $page): ?>
            <span class="is-current" aria-current="page"><?= (int)$pageNumber ?></span>
          <?php else: ?>
            <a href="<?= esc($pageUrlFor((int)$pageNumber)) ?>" aria-label="<?= esc($t['page']) ?> <?= (int)$pageNumber ?>"><?= (int)$pageNumber ?></a>
          <?php endif; ?>
          <?php $lastRendered = $pageNumber; ?>
        <?php endforeach; ?>
        <?php if ($page < $pages): ?>
          <a href="<?= esc($pageUrlFor($page + 1)) ?>" aria-label="<?= esc($t['next']) ?>">›</a>
        <?php endif; ?>
      </nav>
    <?php endif; ?>
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
          <div>Tel: +55 11 3723-3082</div>
          <div>educ@fcc.org.br</div>
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
  <script>
    (function () {
      var container = document.getElementById('mvpAdvancedFields');
      var add = document.getElementById('mvpAddField');
      if (!container || !add) {
        return;
      }

      var labels = {
        term: <?= json_encode($t['term'], JSON_UNESCAPED_UNICODE) ?>,
        title: <?= json_encode($t['title_field'], JSON_UNESCAPED_UNICODE) ?>,
        abstract: <?= json_encode($t['abstract_field'], JSON_UNESCAPED_UNICODE) ?>,
        author: <?= json_encode($t['author_field'], JSON_UNESCAPED_UNICODE) ?>,
        journal: <?= json_encode($t['journal_field'], JSON_UNESCAPED_UNICODE) ?>,
        remove: <?= json_encode($t['remove_field'], JSON_UNESCAPED_UNICODE) ?>
      };

      function option(value, label) {
        return '<option value="' + value + '">' + label + '</option>';
      }

      function addRow() {
        var row = document.createElement('div');
        row.className = 'mvp-advanced-row';
        row.innerHTML =
          '<select name="adv_op[]" aria-label="Operador">' +
            option('AND', 'AND') +
            option('OR', 'OR') +
            option('AND NOT', 'AND NOT') +
          '</select>' +
          '<input type="text" name="adv_q[]" placeholder="' + labels.term + '">' +
          '<select name="adv_field[]" aria-label="Campo">' +
            option('all', <?= json_encode($t['all_fields'], JSON_UNESCAPED_UNICODE) ?>) +
            option('title', labels.title) +
            option('abstract', labels.abstract) +
            option('author', labels.author) +
            option('journal', labels.journal) +
          '</select>' +
          '<button type="button" class="mvp-remove-field" aria-label="' + labels.remove + '">×</button>';
        container.appendChild(row);
        var input = row.querySelector('input');
        if (input) {
          input.focus();
        }
      }

      add.addEventListener('click', addRow);
      container.addEventListener('click', function (event) {
        var button = event.target.closest('.mvp-remove-field');
        if (button) {
          button.closest('.mvp-advanced-row').remove();
        }
      });
    }());
  </script>
  <script>
    (function () {
      var checkboxes = Array.prototype.slice.call(document.querySelectorAll('.mvp-item-select'));
      var count = document.getElementById('mvpSelectedCount');
      var buttons = Array.prototype.slice.call(document.querySelectorAll('[data-share-selected]'));
      if (!checkboxes.length || !count || !buttons.length) {
        return;
      }

      function selectedItems() {
        return checkboxes.filter(function (checkbox) {
          return checkbox.checked;
        }).map(function (checkbox) {
          return {
            title: checkbox.getAttribute('data-title') || '',
            url: checkbox.getAttribute('data-url') || '',
            journal: checkbox.getAttribute('data-journal') || '',
            year: checkbox.getAttribute('data-year') || ''
          };
        });
      }

      function message(items) {
        var lines = ['<?= esc($t['share_selected']) ?> - Educ@', ''];
        items.forEach(function (item, index) {
          lines.push((index + 1) + '. ' + item.title);
          if (item.journal || item.year) {
            lines.push([item.journal, item.year].filter(Boolean).join(' - '));
          }
          lines.push(item.url);
          lines.push('');
        });
        return lines.join('\n').trim();
      }

      function csvCell(value) {
        value = String(value || '').replace(/\r?\n|\r/g, ' ');
        return '"' + value.replace(/"/g, '""') + '"';
      }

      function exportCsv(items) {
        var rows = [['Título', 'Periódico', 'Ano', 'URL']];
        items.forEach(function (item) {
          rows.push([item.title, item.journal, item.year, item.url]);
        });
        var csv = rows.map(function (row) {
          return row.map(csvCell).join(',');
        }).join('\r\n');
        var blob = new Blob(['\ufeff' + csv], { type: 'text/csv;charset=utf-8;' });
        var url = URL.createObjectURL(blob);
        var link = document.createElement('a');
        var stamp = new Date().toISOString().slice(0, 10);
        link.href = url;
        link.download = 'educa-resultados-' + stamp + '.csv';
        document.body.appendChild(link);
        link.click();
        link.remove();
        URL.revokeObjectURL(url);
      }

      function update() {
        var total = selectedItems().length;
        count.textContent = String(total);
        buttons.forEach(function (button) {
          button.disabled = total === 0;
        });
      }

      checkboxes.forEach(function (checkbox) {
        checkbox.addEventListener('change', update);
      });

      buttons.forEach(function (button) {
        button.addEventListener('click', function () {
          var items = selectedItems();
          if (!items.length) {
            return;
          }
          var text = message(items);
          var target = button.getAttribute('data-share-selected');
          if (target === 'whatsapp') {
            window.open('https://api.whatsapp.com/send?text=' + encodeURIComponent(text), '_blank', 'noopener,noreferrer');
          } else if (target === 'telegram') {
            window.open('https://t.me/share/url?url=&text=' + encodeURIComponent(text), '_blank', 'noopener,noreferrer');
          } else if (target === 'email') {
            window.location.href = 'mailto:?subject=' + encodeURIComponent('<?= esc($t['share_selected']) ?> - Educ@') + '&body=' + encodeURIComponent(text);
          } else if (target === 'csv') {
            exportCsv(items);
          }
        });
      });

      update();
    }());
  </script>
</body>
</html>
