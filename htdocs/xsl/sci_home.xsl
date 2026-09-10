<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:variable name="SCIELO_REGIONAL_DOMAIN" select="//SCIELO_REGIONAL_DOMAIN"/>
	<xsl:variable name="show_toolbox" select="//toolbox"/>
	<xsl:variable name="show_login" select="//show_login"/>
	<xsl:variable name="login_url" select="//loginURL"/>
	<xsl:variable name="show_home_journal_evaluation" select="//show_home_journal_evaluation"/>
	<xsl:variable name="show_home_scieloorg" select="//show_home_scieloorg"/>
	<xsl:variable name="show_home_help" select="//show_home_help"/>
	<xsl:variable name="show_home_about" select="//show_home_about"/>
	<xsl:variable name="show_home_scielo_news" select="//show_home_scielo_news"/>
	<xsl:variable name="show_home_scielo_team" select="//show_home_scielo_team"/>
	<xsl:variable name="show_home_scielo_signature" select="//show_home_scielo_signature"/>
	<xsl:variable name="analytics_code" select="//ANALYTICS_CODE"/>
	<xsl:output method="html" indent="no"/>
	<xsl:include href="sci_navegation.xsl"/>
	<xsl:template match="HOMEPAGE">
		<html lang="{normalize-space(//CONTROLINFO/LANGUAGE)}">
			<head>
				<title>Educ@</title>
				<meta http-equiv="Pragma" content="no-cache"/>
				<meta http-equiv="Expires" content="Mon, 06 Jan 1990 00:00:01 GMT"/>
				<xsl:if test="//NEW_HOME">
					<xsl:variable name="X" select="//NEW_HOME"/>
					<meta HTTP-EQUIV="REFRESH">
						<xsl:attribute name="Content"><xsl:value-of select="concat('0;URL=',$X)"/></xsl:attribute>
					</meta>
				</xsl:if>
				<link rel="STYLESHEET" type="text/css" href="/css/scielo.css"/>
				<link rel="stylesheet" type="text/css" href="/design-system/1.0.0/css/bootstrap.css"/>
				<link rel="stylesheet" type="text/css" href="/design-system/1.0.0/css/article.css"/>
				<link rel="stylesheet" type="text/css" href="/css/scielo-ds-bridge.css?v=home-news-mobile-20260902-1"/>
				<xsl:call-template name="EDUCA_GOOGLE_TAG"/>
			</head>
			<xsl:if test="not(//NEW_HOME)">
				<body class="home-page" link="#000080" vlink="#800080" bgcolor="#ffffff">
					<a class="skip-link" href="#main-content">
						<xsl:choose>
							<xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='en'">Skip to main content</xsl:when>
							<xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='es'">Saltar al contenido principal</xsl:when>
							<xsl:otherwise>Pular para o conteúdo principal</xsl:otherwise>
						</xsl:choose>
					</a>
					<xsl:apply-templates select="CONTROLINFO"/>
					<script type="text/javascript" src="/js/educa-accessibility.js?v=20260615-details-1"></script>
				</body>
			</xsl:if>
		</html>
	</xsl:template>
	<xsl:template name="link-ext">
</xsl:template>
	<xsl:template match="CONTROLINFO">
		<header class="home-top-header">
			<div class="home-topbar">
				<details class="home-main-menu">
					<summary class="serials-ghost-btn">&#9776; Menu</summary>
					<ul class="home-main-dropdown">
						<li>
							<a href="http://{SCIELO_INFO/SERVER}{SCIELO_INFO/PATH_DATA}search_mvp.php?lang=pt">Busca</a>
						</li>
						<li>
							<a href="http://{SCIELO_INFO/SERVER}{SCIELO_INFO/PATH_DATA}scielo.php?script=sci_alphabetic&amp;lng=pt&amp;nrm=iso">Lista de periódicos</a>
						</li>
						<li>
							<a href="http://{SCIELO_INFO/SERVER}{SCIELO_INFO/PATH_DATA}avaliacao/">Avaliação de periódicos</a>
						</li>
						<li>
							<a href="https://educa.fcc.org.br/metricas/?lang=pt">Métricas e Indicadores</a>
						</li>
						<li>
							<a href="http://{SCIELO_INFO/SERVER}{SCIELO_INFO/PATH_DATA}about/?lang=pt">Sobre o Educ@</a>
						</li>
						<li>
							<a href="http://{SCIELO_INFO/SERVER}{SCIELO_INFO/PATH_DATA}equipe/equipe_p.htm">Equipe Educ@</a>
						</li>
					</ul>
				</details>
				<a class="serials-about-link">
					<xsl:attribute name="href">/about/?lang=<xsl:value-of select="normalize-space(LANGUAGE)"/></xsl:attribute>
					&#9432;
					<xsl:text> </xsl:text>
					<xsl:choose>
						<xsl:when test="normalize-space(LANGUAGE)='pt'">Sobre este site</xsl:when>
						<xsl:when test="normalize-space(LANGUAGE)='es'">Sobre este sitio</xsl:when>
						<xsl:otherwise>About this site</xsl:otherwise>
					</xsl:choose>
				</a>
				<div class="serials-lang-menu">
					<button class="serials-ghost-btn serials-lang-btn" type="button" aria-haspopup="true" aria-expanded="false" aria-label="Language selector">
						&#127760;
						<xsl:text> </xsl:text>
						<xsl:choose>
							<xsl:when test="normalize-space(LANGUAGE)='pt'">Português</xsl:when>
							<xsl:when test="normalize-space(LANGUAGE)='es'">Español</xsl:when>
							<xsl:otherwise>English</xsl:otherwise>
						</xsl:choose>
						<xsl:text> &#9662;</xsl:text>
					</button>
					<ul class="serials-lang-dropdown">
						<li>
							<a href="http://{SCIELO_INFO/SERVER}{SCIELO_INFO/PATH_DATA}scielo.php?lng=pt">
								<xsl:choose>
									<xsl:when test="normalize-space(LANGUAGE)='en'">Portuguese</xsl:when>
									<xsl:when test="normalize-space(LANGUAGE)='es'">Portugués</xsl:when>
									<xsl:otherwise>Português</xsl:otherwise>
								</xsl:choose>
							</a>
						</li>
						<li>
							<a href="http://{SCIELO_INFO/SERVER}{SCIELO_INFO/PATH_DATA}scielo.php?lng=es">
								<xsl:choose>
									<xsl:when test="normalize-space(LANGUAGE)='en'">Spanish</xsl:when>
									<xsl:when test="normalize-space(LANGUAGE)='pt'">Espanhol</xsl:when>
									<xsl:otherwise>Español</xsl:otherwise>
								</xsl:choose>
							</a>
						</li>
						<li>
							<a href="http://{SCIELO_INFO/SERVER}{SCIELO_INFO/PATH_DATA}scielo.php?lng=en">
								<xsl:choose>
									<xsl:when test="normalize-space(LANGUAGE)='pt'">Inglês</xsl:when>
									<xsl:when test="normalize-space(LANGUAGE)='es'">Inglés</xsl:when>
									<xsl:otherwise>English</xsl:otherwise>
								</xsl:choose>
							</a>
						</li>
					</ul>
				</div>
			</div>
				<div class="home-branding">
					<img alt="Educ@" src="/img/pt/scielobre.gif"/>
			</div>
		</header>
		<main id="main-content" tabindex="-1">
			<h1 class="visually-hidden">
				<xsl:choose>
					<xsl:when test="normalize-space(LANGUAGE)='en'">Educ@ Home</xsl:when>
					<xsl:when test="normalize-space(LANGUAGE)='es'">Inicio Educ@</xsl:when>
					<xsl:otherwise>Início Educ@</xsl:otherwise>
				</xsl:choose>
			</h1>
		<section class="home-search-wrap">
			<form class="home-search-form" method="get" action="/search_mvp.php">
				<input type="hidden" name="lang">
					<xsl:attribute name="value"><xsl:value-of select="normalize-space(LANGUAGE)"/></xsl:attribute>
				</input>
				<input type="hidden" name="page" value="1"/>
				<input class="home-search-input" type="text" name="q">
					<xsl:attribute name="aria-label">
						<xsl:choose>
							<xsl:when test="normalize-space(LANGUAGE)='en'">Search terms</xsl:when>
							<xsl:when test="normalize-space(LANGUAGE)='es'">Términos de búsqueda</xsl:when>
							<xsl:otherwise>Termos de busca</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:attribute name="placeholder">
						<xsl:choose>
							<xsl:when test="normalize-space(LANGUAGE)='en'">Enter one or more words</xsl:when>
							<xsl:when test="normalize-space(LANGUAGE)='es'">Ingrese una o m&#225;s palabras</xsl:when>
							<xsl:otherwise>Entre uma ou mais palavras</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
				</input>
				<select class="home-search-field" name="field" aria-label="Campo da busca">
					<option value="all">
						<xsl:choose>
							<xsl:when test="normalize-space(LANGUAGE)='en'">All fields</xsl:when>
							<xsl:when test="normalize-space(LANGUAGE)='es'">Todos los campos</xsl:when>
							<xsl:otherwise>Todos os campos</xsl:otherwise>
						</xsl:choose>
					</option>
					<option value="abstract">
						<xsl:choose>
							<xsl:when test="normalize-space(LANGUAGE)='en'">Abstract</xsl:when>
							<xsl:when test="normalize-space(LANGUAGE)='es'">Resumen</xsl:when>
							<xsl:otherwise>Resumo</xsl:otherwise>
						</xsl:choose>
					</option>
					<option value="author">
						<xsl:choose>
							<xsl:when test="normalize-space(LANGUAGE)='en'">Author</xsl:when>
							<xsl:when test="normalize-space(LANGUAGE)='es'">Autor</xsl:when>
							<xsl:otherwise>Autor</xsl:otherwise>
						</xsl:choose>
					</option>
					<option value="journal">
						<xsl:choose>
							<xsl:when test="normalize-space(LANGUAGE)='en'">Journal</xsl:when>
							<xsl:when test="normalize-space(LANGUAGE)='es'">Revista</xsl:when>
							<xsl:otherwise>Periódico</xsl:otherwise>
						</xsl:choose>
					</option>
				</select>
				<button class="home-search-btn" type="submit">
					<xsl:choose>
						<xsl:when test="normalize-space(LANGUAGE)='en'">Search</xsl:when>
						<xsl:when test="normalize-space(LANGUAGE)='es'">Buscar</xsl:when>
						<xsl:otherwise>Buscar</xsl:otherwise>
					</xsl:choose>
				</button>
				<div class="home-advanced-fields" id="homeAdvancedFields"></div>
				<button class="home-add-field" id="homeAddField" type="button">
					<xsl:choose>
						<xsl:when test="normalize-space(LANGUAGE)='en'">Add another field</xsl:when>
						<xsl:when test="normalize-space(LANGUAGE)='es'">Agregar otro campo</xsl:when>
						<xsl:otherwise>Adicionar outro campo</xsl:otherwise>
					</xsl:choose>
				</button>
			</form>
			<input type="hidden" id="home-current-lang" value="{normalize-space(LANGUAGE)}"/>
		</section>
		<section class="home-journal-links">
			<div class="home-shortcuts">
				<a class="home-shortcut-card">
					<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER"/><xsl:value-of select="SCIELO_INFO/PATH_DATA"/>scielo.php?script=sci_alphabetic&amp;lng=<xsl:value-of select="LANGUAGE"/>&amp;nrm=iso</xsl:attribute>
					<xsl:choose>
						<xsl:when test="normalize-space(LANGUAGE)='en'">Journal list</xsl:when>
						<xsl:when test="normalize-space(LANGUAGE)='es'">Lista de revistas</xsl:when>
						<xsl:otherwise>Lista de peri&#243;dicos</xsl:otherwise>
					</xsl:choose>
				</a>
				<a class="home-shortcut-card" href="/avaliacao/">
					<xsl:choose>
						<xsl:when test="normalize-space(LANGUAGE)='en'">Journal evaluation</xsl:when>
						<xsl:when test="normalize-space(LANGUAGE)='es'">Evaluación de revistas</xsl:when>
						<xsl:otherwise>Avalia&#231;&#227;o de peri&#243;dicos</xsl:otherwise>
					</xsl:choose>
				</a>
				<a class="home-shortcut-card">
					<xsl:attribute name="href">/metricas/?lang=<xsl:value-of select="normalize-space(LANGUAGE)"/></xsl:attribute>
					<xsl:choose>
						<xsl:when test="normalize-space(LANGUAGE)='en'">Metrics and indicators system</xsl:when>
						<xsl:when test="normalize-space(LANGUAGE)='es'">Sistema de métricas e indicadores</xsl:when>
						<xsl:otherwise>Sistema de M&#233;tricas e Indicadores</xsl:otherwise>
					</xsl:choose>
				</a>
				<a class="home-shortcut-card">
					<xsl:attribute name="href">/about/?lang=<xsl:value-of select="normalize-space(LANGUAGE)"/></xsl:attribute>
					<xsl:choose>
						<xsl:when test="normalize-space(LANGUAGE)='en'">About Educ@</xsl:when>
						<xsl:when test="normalize-space(LANGUAGE)='es'">Acerca de Educ@</xsl:when>
						<xsl:otherwise>Sobre o Educ@</xsl:otherwise>
					</xsl:choose>
				</a>
			</div>
		</section>
		<section class="home-institutional">
			<div class="home-institutional-inner">
				<div class="home-institutional-logo">
					<img alt="Educ@" src="/img/pt/scielobre.gif"/>
				</div>
				<div class="home-institutional-copy">
					<p>
						<xsl:choose>
							<xsl:when test="normalize-space(LANGUAGE)='en'">Educ@ is an online indexing database that provides broad access to collections of scholarly journals in education. Implemented by Fundação Carlos Chagas, it uses the SciELO methodology to expand the dissemination, preservation and retrieval of academic and scientific output in education.</xsl:when>
							<xsl:when test="normalize-space(LANGUAGE)='es'">Educ@ es un indexador en línea que proporciona amplio acceso a colecciones de revistas científicas del área de educación. Implementado por la Fundação Carlos Chagas, utiliza la metodología SciELO para ampliar la divulgación, preservación y recuperación de la producción académica y científica en educación.</xsl:when>
							<xsl:otherwise>O Educ@ é um indexador on-line que proporciona amplo acesso a coleções de periódicos científicos da área de educação. Implementado pela Fundação Carlos Chagas, utiliza a metodologia SciELO para ampliar a divulgação, preservação e recuperação da produção acadêmica e científica em educação.</xsl:otherwise>
						</xsl:choose>
					</p>
				</div>
			</div>
		</section>
			<section class="home-press-releases">
				<div class="home-pr-head">
					<h2>
						<xsl:choose>
							<xsl:when test="normalize-space(LANGUAGE)='en'">Fundação Carlos Chagas News</xsl:when>
							<xsl:when test="normalize-space(LANGUAGE)='es'">Noticias Fundação Carlos Chagas</xsl:when>
							<xsl:otherwise>Notícias Fundação Carlos Chagas</xsl:otherwise>
						</xsl:choose>
					</h2>
					<a class="home-pr-all-link" href="https://www.fcc.org.br/noticias/todas" target="_blank" rel="noopener noreferrer">
						<xsl:choose>
							<xsl:when test="normalize-space(LANGUAGE)='en'">View all news</xsl:when>
							<xsl:when test="normalize-space(LANGUAGE)='es'">Ver todas las noticias</xsl:when>
							<xsl:otherwise>Ver todas as notícias</xsl:otherwise>
						</xsl:choose>
					</a>
				</div>
				<div class="home-pr-carousel">
					<button id="home-pr-prev" class="home-pr-nav" type="button" aria-controls="home-pr-grid">
						<xsl:attribute name="aria-label">
							<xsl:choose>
								<xsl:when test="normalize-space(LANGUAGE)='en'">Previous posts</xsl:when>
								<xsl:when test="normalize-space(LANGUAGE)='es'">Publicaciones anteriores</xsl:when>
								<xsl:otherwise>Posts anteriores</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						&#8249;
					</button>
					<div id="home-pr-grid" class="home-pr-grid" role="status" aria-live="polite">
						<div class="home-pr-loading">
							<xsl:choose>
								<xsl:when test="normalize-space(LANGUAGE)='en'">Loading posts...</xsl:when>
								<xsl:when test="normalize-space(LANGUAGE)='es'">Cargando publicaciones...</xsl:when>
								<xsl:otherwise>Carregando posts...</xsl:otherwise>
							</xsl:choose>
						</div>
					</div>
					<button id="home-pr-next" class="home-pr-nav" type="button" aria-controls="home-pr-grid">
						<xsl:attribute name="aria-label">
							<xsl:choose>
								<xsl:when test="normalize-space(LANGUAGE)='en'">Next posts</xsl:when>
								<xsl:when test="normalize-space(LANGUAGE)='es'">Siguientes publicaciones</xsl:when>
								<xsl:otherwise>Próximos posts</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						&#8250;
					</button>
				</div>
				<div id="home-pr-dots" class="home-pr-dots"></div>
			</section>
		</main>
		<footer class="serials-footer">
			<div class="serials-footer-top">
				<div class="serials-footer-brand">
					<img alt="Educ@" src="/img/pt/scielobre.gif"/>
				</div>
				<div class="serials-footer-meta">
					<div class="name"><strong>Educ@</strong></div>
					<div class="serials-footer-fcc-brand"><img alt="Fundação Carlos Chagas" src="/img/fcc.png"/></div>
					<div>Av. Prof. Francisco Morato, 1565 - Jd. Guedala</div>
					<div>05513-900 S&#227;o Paulo - SP - Brasil</div>
					<div>
						<a class="email journal-footer-email serials-footer-email" href="mailto:educ@fcc.org.br">
							<svg class="journal-footer-email-icon" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
								<rect x="3" y="5" width="18" height="14" rx="2"/>
								<path d="M3 7l9 6 9-6"/>
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
				<img alt="Open Access" src="/design-system/1.0.0/img/logo-open-access.svg"/>
				<a href="https://www.gov.br/funag/pt-br/centrais-de-conteudo/publicacoes/acesso-aberto" target="_blank" rel="noopener noreferrer">Leia a Declaração de Acesso Aberto</a>
			</div>
		</footer>
		<div class="serials-template-utils">
			<a href="mailto:educ@fcc.org.br?subject=Reportar%20erro" class="serials-template-report">
				<xsl:choose>
					<xsl:when test="normalize-space(LANGUAGE)='en'">Report error</xsl:when>
					<xsl:when test="normalize-space(LANGUAGE)='es'">Reportar error</xsl:when>
					<xsl:otherwise>Reportar erro</xsl:otherwise>
				</xsl:choose>
			</a>
			<a href="#main-content" class="serials-template-accessibility">
				<xsl:attribute name="aria-label">
					<xsl:choose>
						<xsl:when test="normalize-space(LANGUAGE)='en'">Accessibility</xsl:when>
						<xsl:when test="normalize-space(LANGUAGE)='es'">Accesibilidad</xsl:when>
						<xsl:otherwise>Acessibilidade</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				A
			</a>
		</div>
		<script><![CDATA[
		(function () {
		  var input = document.getElementById('home-journal-filter');
		  var results = document.getElementById('home-journal-results');
		  var langInput = document.getElementById('home-current-lang');
		  var currentLang = (langInput && langInput.value) ? langInput.value : 'pt';
		  var homeAdvancedFields = document.getElementById('homeAdvancedFields');
		  var homeAddField = document.getElementById('homeAddField');
			  var prGrid = document.getElementById('home-pr-grid');
			  var prPrev = document.getElementById('home-pr-prev');
			  var prNext = document.getElementById('home-pr-next');
			  var prDots = document.getElementById('home-pr-dots');
			  var prPosts = [];
			  var prPage = 0;
			  var prPerPage = 4;
		  var journals = [];
		  var loaded = false;
		  var loading = false;

		  function escapeHtml(str) {
		    return String(str)
		      .replace(/&/g, '&amp;')
		      .replace(/</g, '&lt;')
		      .replace(/>/g, '&gt;')
		      .replace(/"/g, '&quot;')
		      .replace(/'/g, '&#39;');
		  }

		  function homeSearchLabels() {
		    if (currentLang === 'en') {
		      return {
		        term: 'Search terms',
		        all: 'All fields',
		        abstract: 'Abstract',
		        author: 'Author',
		        journal: 'Journal',
		        remove: 'Remove field'
		      };
		    }
		    if (currentLang === 'es') {
		      return {
		        term: 'Términos de búsqueda',
		        all: 'Todos los campos',
		        abstract: 'Resumen',
		        author: 'Autor',
		        journal: 'Revista',
		        remove: 'Eliminar campo'
		      };
		    }
		    return {
		      term: 'Termos de busca',
		      all: 'Todos os campos',
		      abstract: 'Resumo',
		      author: 'Autor',
		      journal: 'Periódico',
		      remove: 'Remover campo'
		    };
		  }

		  function homeOption(value, label) {
		    return '<option value="' + value + '">' + escapeHtml(label) + '</option>';
		  }

		  function addHomeAdvancedField() {
		    if (!homeAdvancedFields) {
		      return;
		    }
		    var labels = homeSearchLabels();
		    var row = document.createElement('div');
		    row.className = 'home-advanced-row';
		    row.innerHTML =
		      '<select name="adv_op[]" aria-label="Operador">' +
		        homeOption('AND', 'AND') +
		        homeOption('OR', 'OR') +
		        homeOption('AND NOT', 'AND NOT') +
		      '</select>' +
		      '<input type="text" name="adv_q[]" placeholder="' + escapeHtml(labels.term) + '">' +
		      '<select name="adv_field[]" aria-label="Campo">' +
		        homeOption('all', labels.all) +
		        homeOption('abstract', labels.abstract) +
		        homeOption('author', labels.author) +
		        homeOption('journal', labels.journal) +
		      '</select>' +
		      '<button type="button" class="home-remove-field" aria-label="' + escapeHtml(labels.remove) + '">×</button>';
		    homeAdvancedFields.appendChild(row);
		    var field = row.querySelector('input');
		    if (field) {
		      field.focus();
		    }
		  }

		  function render(items) {
		    if (!items.length) {
		      results.style.display = 'none';
		      results.innerHTML = '';
		      return;
		    }
		    results.innerHTML = '<ul>' + items.map(function (item) {
		      return '<li><a href="' + item.href + '">' + escapeHtml(item.title) + '</a></li>';
		    }).join('') + '</ul>';
		    results.style.display = 'block';
		  }

		  function filterAndRender() {
		    var q = (input.value || '').trim().toLowerCase();
		    if (q.length < 2) {
		      results.style.display = 'none';
		      results.innerHTML = '';
		      return;
		    }
		    var filtered = journals.filter(function (j) {
		      return j.title.toLowerCase().indexOf(q) !== -1;
		    }).slice(0, 20);
		    render(filtered);
		  }

		  function loadJournals() {
		    if (loaded || loading) {
		      return;
		    }
		    loading = true;
		    fetch('/scielo.php?script=sci_alphabetic&lng=en&nrm=iso', { credentials: 'same-origin' })
		      .then(function (r) { return r.text(); })
		      .then(function (html) {
		        var doc = new DOMParser().parseFromString(html, 'text/html');
		        var links = doc.querySelectorAll('a.journal-title');
		        var seen = {};
		        journals = Array.prototype.map.call(links, function (a) {
		          return {
		            title: (a.textContent || '').trim(),
		            href: a.getAttribute('href')
		          };
		        }).filter(function (j) {
		          if (!j.title || !j.href || seen[j.href]) {
		            return false;
		          }
		          seen[j.href] = true;
		          return true;
		        });
		        loaded = true;
		        filterAndRender();
		      })
		      .catch(function () {
		        results.style.display = 'none';
		      })
		      .finally(function () {
		        loading = false;
		      });
		  }

		  if (input && results) {
		    input.addEventListener('focus', loadJournals);
		    input.addEventListener('input', function () {
		      if (!loaded) {
		        loadJournals();
		        return;
		      }
		      filterAndRender();
		    });
		    document.addEventListener('click', function (e) {
		      if (!results.contains(e.target) && e.target !== input) {
		        results.style.display = 'none';
		      }
		    });
		  }

		  if (homeAddField && homeAdvancedFields) {
		    homeAddField.addEventListener('click', addHomeAdvancedField);
		    homeAdvancedFields.addEventListener('click', function (event) {
		      if (event.target && event.target.className === 'home-remove-field') {
		        var row = event.target.parentNode;
		        if (row) {
		          row.parentNode.removeChild(row);
		        }
		      }
		    });
		  }

		  function readMoreLabel() {
		    if (currentLang === 'en') {
		      return 'Continue reading';
		    }
		    if (currentLang === 'es') {
		      return 'Seguir leyendo';
		    }
		    return 'Continue lendo';
		  }

		  function noPostsLabel() {
		    if (currentLang === 'en') {
		      return 'No posts found.';
		    }
		    if (currentLang === 'es') {
		      return 'No se encontraron publicaciones.';
		    }
		    return 'Nenhum post encontrado.';
		  }

		  function loadFailLabel() {
		    if (currentLang === 'en') {
		      return 'Failed to load posts.';
		    }
		    if (currentLang === 'es') {
		      return 'Error al cargar publicaciones.';
		    }
		    return 'Falha ao carregar posts.';
		  }

		  function pageLabel(n) {
		    if (currentLang === 'en') {
		      return 'Page ' + n;
		    }
		    if (currentLang === 'es') {
		      return 'Página ' + n;
		    }
		    return 'Página ' + n;
		  }

		  function formatDate(value) {
		    if (!value) {
		      return '';
		    }
		    var date = new Date(value);
		    if (isNaN(date.getTime())) {
		      return value;
		    }
		    var locale = currentLang === 'en' ? 'en-US' : (currentLang === 'es' ? 'es-ES' : 'pt-BR');
		    return date.toLocaleDateString(locale, {
		      year: 'numeric',
		      month: '2-digit',
		      day: '2-digit'
		    });
		  }

		  function renderPressReleases(posts) {
		    if (!prGrid) {
		      return;
		    }
		    if (!posts || !posts.length) {
		      prGrid.innerHTML = '<div class="home-pr-loading">' + noPostsLabel() + '</div>';
		      if (prDots) {
		        prDots.innerHTML = '';
		      }
		      if (prPrev) {
		        prPrev.style.visibility = 'hidden';
		      }
		      if (prNext) {
		        prNext.style.visibility = 'hidden';
		      }
		      return;
		    }
		    var totalPages = Math.ceil(posts.length / prPerPage);
		    if (prPage >= totalPages) {
		      prPage = 0;
		    }
		    var start = prPage * prPerPage;
		    var end = start + prPerPage;
		    var visiblePosts = posts.slice(start, end);
			    prGrid.innerHTML = visiblePosts.map(function (post) {
			      var image = post.image ? post.image : '/design-system/1.0.0/img/list.loading.gif';
			      return (
			        '<article class="home-pr-card">' +
			          '<a class="home-pr-image-link" href="' + post.link + '" target="_blank" rel="noopener noreferrer">' +
			            '<img src="' + image + '" alt="" loading="lazy" decoding="async">' +
			          '</a>' +
			          '<div class="home-pr-body">' +
			            '<div class="home-pr-date">' + escapeHtml(formatDate(post.date)) + '</div>' +
			            '<a class="home-pr-title" href="' + post.link + '" target="_blank" rel="noopener noreferrer">' + escapeHtml(post.title) + '</a>' +
			          '</div>' +
			        '</article>'
			      );
		    }).join('');
		    if (prPrev) {
		      prPrev.style.visibility = totalPages > 1 ? 'visible' : 'hidden';
		    }
		    if (prNext) {
		      prNext.style.visibility = totalPages > 1 ? 'visible' : 'hidden';
		    }
		    if (prDots) {
		      var dotsHtml = '';
		      for (var i = 0; i < totalPages; i++) {
		        dotsHtml += '<button type="button" class="home-pr-dot' + (i === prPage ? ' active' : '') + '" data-page="' + i + '" aria-label="' + pageLabel(i + 1) + '"></button>';
		      }
		      prDots.innerHTML = dotsHtml;
		    }
		  }

		  function loadPressReleases() {
		    if (!prGrid) {
		      return;
		    }
		    var controller = window.AbortController ? new AbortController() : null;
		    var timeout = controller ? window.setTimeout(function () {
		      controller.abort();
		    }, 5000) : null;
		    var options = { credentials: 'same-origin' };
		    if (controller) {
		      options.signal = controller.signal;
		    }
		    fetch('/fcc_news_proxy.php?lang=' + encodeURIComponent(currentLang) + '&limit=8', options)
		      .then(function (r) { return r.json(); })
		      .then(function (data) {
		        prPosts = data.posts || [];
		        prPage = 0;
		        renderPressReleases(prPosts);
		      })
		      .catch(function () {
		        prGrid.innerHTML = '<div class="home-pr-loading">' + loadFailLabel() + '</div>';
		      })
		      .finally(function () {
		        if (timeout) {
		          window.clearTimeout(timeout);
		        }
		      });
		  }

		  function schedulePressReleasesLoad() {
		    if (!prGrid) {
		      return;
		    }
		    if (window.requestIdleCallback) {
		      window.requestIdleCallback(loadPressReleases, { timeout: 1500 });
		      return;
		    }
		    window.setTimeout(loadPressReleases, 500);
		  }

		  if (prPrev) {
		    prPrev.addEventListener('click', function () {
		      if (!prPosts.length) {
		        return;
		      }
		      var total = Math.ceil(prPosts.length / prPerPage);
		      prPage = (prPage - 1 + total) % total;
		      renderPressReleases(prPosts);
		    });
		  }

		  if (prNext) {
		    prNext.addEventListener('click', function () {
		      if (!prPosts.length) {
		        return;
		      }
		      var total = Math.ceil(prPosts.length / prPerPage);
		      prPage = (prPage + 1) % total;
		      renderPressReleases(prPosts);
		    });
		  }

		  if (prDots) {
		    prDots.addEventListener('click', function (event) {
		      var target = event.target;
		      if (!target || !target.getAttribute) {
		        return;
		      }
		      var page = target.getAttribute('data-page');
		      if (page === null) {
		        return;
		      }
		      prPage = parseInt(page, 10) || 0;
		      renderPressReleases(prPosts);
		    });
		  }

		  schedulePressReleasesLoad();
		})();
		]]></script>
	</xsl:template>
	<xsl:template match="SCIELOINFOGROUP">
		<p align="center">
			<font class="nomodel" color="#0000A0" size="-1">
				<xsl:value-of select="normalize-space(SITE_NAME)"/>
				<br/>
				<xsl:value-of select="normalize-space(ORGANIZATION)"/>
				<br/>
				<xsl:value-of select="normalize-space(ADDRESS/ADDRESS_1)"/>
				<br/>
				<xsl:value-of select="normalize-space(ADDRESS/ADDRESS_2)"/> - <xsl:value-of select="normalize-space(ADDRESS/COUNTRY)"/>
				<br/>
				<xsl:value-of select="$translations/xslid[@id='sci_home']/text[@find='phone']"/>: <xsl:value-of select="normalize-space(PHONE)"/>
				<br/>
				<xsl:value-of select="$translations/xslid[@id='sci_home']/text[@find='fax']"/>: <xsl:value-of select="normalize-space(FAX)"/>
			</font>
			<br/>
			<a class="email">
				<xsl:attribute name="href">mailto:<xsl:value-of select="normalize-space(EMAIL)"/></xsl:attribute>
				<img>
					<xsl:attribute name="src"><xsl:value-of select="//PATH_GENIMG"/>e-mailt.gif</xsl:attribute>
					<xsl:attribute name="border">0</xsl:attribute>
				</img>
				<br/>
				<font color="#0000A0" size="2">
					<xsl:value-of select="normalize-space(EMAIL)"/>
				</font>
			</a>
		</p>
		<xsl:call-template name="UpdateLog"/>
	</xsl:template>
	<xsl:template match="USERINFO" mode="box">
		<xsl:param name="lang"/>
		<xsl:variable name="STATUS" select="@status"/>
		<xsl:if test="$STATUS = 'logout' and $show_login=1">
			<p>
				<a href="http://{$SCIELO_REGIONAL_DOMAIN}/{$login_url}?lang={$lang}">
					<span>
						<xsl:value-of select="$translations/xslid[@id='sci_home']/text[@find='register_free']"/>
					</span>
				</a>
			</p>
		</xsl:if>
		<xsl:if test="$STATUS = 'login'">
			<p>
				<xsl:value-of select="$translations/xslid[@id='sci_home']/text[@find='welcome']"/>: <xsl:value-of select="."/>
			</p>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
