<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:include href="sci_navegation.xsl"/>
	<xsl:include href="journalStatus.xsl"/>
	<xsl:output encoding="utf-8"/>
	<xsl:template match="/">
		<html lang="{normalize-space(//CONTROLINFO/LANGUAGE)}">
			<head>
				<title>
					<xsl:value-of select="$translations/xslid[@id='sci_home']/text[@find='alphabetic_list']"/>
				</title>
				<meta http-equiv="Pragma" content="no-cache"/>
				<meta http-equiv="Expires" content="Mon, 06 Jan 1990 00:00:01 GMT"/>
				<link rel="STYLESHEET" type="text/css" href="/css/scielo.css"/>
				<link rel="stylesheet" type="text/css" href="/design-system/1.0.0/css/bootstrap.css"/>
				<link rel="stylesheet" type="text/css" href="/design-system/1.0.0/css/article.css"/>
				<link rel="stylesheet" type="text/css" href="/css/scielo-ds-bridge.css?v=alpha-20260614-4"/>
				<xsl:call-template name="EDUCA_GOOGLE_TAG"/>
			</head>
			<body class="serials-page" link="#0000ff" vlink="#800080" bgcolor="#ffffff">
				<xsl:call-template name="ACCESS_SKIP_LINK"/>
				<header class="serials-top-header" id="top">
					<div class="serials-topbar">
						<details class="home-main-menu">
							<summary class="serials-ghost-btn">&#9776; Menu</summary>
							<ul class="home-main-dropdown">
								<li>
									<a href="http://{//SERVER}{//PATH_DATA}search_mvp.php?lang={normalize-space(//CONTROLINFO/LANGUAGE)}">
										<xsl:choose><xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='en'">Search</xsl:when><xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='es'">Búsqueda</xsl:when><xsl:otherwise>Busca</xsl:otherwise></xsl:choose>
									</a>
								</li>
								<li>
									<a href="http://{//SERVER}{//PATH_DATA}scielo.php?script=sci_alphabetic&amp;lng={normalize-space(//CONTROLINFO/LANGUAGE)}&amp;nrm=iso">
										<xsl:choose><xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='en'">Journal list</xsl:when><xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='es'">Lista de revistas</xsl:when><xsl:otherwise>Lista de periódicos</xsl:otherwise></xsl:choose>
									</a>
								</li>
								<li>
									<a href="http://{//SERVER}{//PATH_DATA}avaliacao/?lang={normalize-space(//CONTROLINFO/LANGUAGE)}">
										<xsl:choose><xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='en'">Journal evaluation</xsl:when><xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='es'">Evaluación de revistas</xsl:when><xsl:otherwise>Avaliação de periódicos</xsl:otherwise></xsl:choose>
									</a>
								</li>
								<li>
									<a href="https://educa.fcc.org.br/metricas/?lang=pt">Métricas e Indicadores</a>
								</li>
								<li>
									<a href="http://{//SERVER}{//PATH_DATA}about/?lang={normalize-space(//CONTROLINFO/LANGUAGE)}">
										<xsl:choose><xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='en'">About Educ@</xsl:when><xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='es'">Acerca de Educ@</xsl:when><xsl:otherwise>Sobre o Educ@</xsl:otherwise></xsl:choose>
									</a>
								</li>
								<li>
									<a href="http://{//SERVER}{//PATH_DATA}equipe/equipe_p.htm">
										<xsl:choose><xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='en'">Educ@ Team</xsl:when><xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='es'">Equipo Educ@</xsl:when><xsl:otherwise>Equipe Educ@</xsl:otherwise></xsl:choose>
									</a>
								</li>
							</ul>
						</details>
						<div class="serials-lang-menu">
							<button class="serials-ghost-btn serials-lang-btn" type="button" aria-haspopup="true" aria-expanded="false" aria-label="Language selector">
								&#127760;
								<xsl:text> </xsl:text>
								<xsl:choose>
									<xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='pt'">Português</xsl:when>
									<xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='es'">Español</xsl:when>
									<xsl:otherwise>English</xsl:otherwise>
								</xsl:choose>
								<xsl:text> &#9662;</xsl:text>
							</button>
							<ul class="serials-lang-dropdown">
								<li>
									<a href="http://{//SERVER}{//PATH_DATA}scielo.php?script=sci_alphabetic&amp;lng=pt&amp;nrm=iso">
										<xsl:choose>
											<xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='en'">Portuguese</xsl:when>
											<xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='es'">Portugués</xsl:when>
											<xsl:otherwise>Português</xsl:otherwise>
										</xsl:choose>
									</a>
								</li>
								<li>
									<a href="http://{//SERVER}{//PATH_DATA}scielo.php?script=sci_alphabetic&amp;lng=es&amp;nrm=iso">
										<xsl:choose>
											<xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='en'">Spanish</xsl:when>
											<xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='pt'">Espanhol</xsl:when>
											<xsl:otherwise>Español</xsl:otherwise>
										</xsl:choose>
									</a>
								</li>
								<li>
									<a href="http://{//SERVER}{//PATH_DATA}scielo.php?script=sci_alphabetic&amp;lng=en&amp;nrm=iso">
										<xsl:choose>
											<xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='pt'">Inglês</xsl:when>
											<xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='es'">Inglés</xsl:when>
											<xsl:otherwise>English</xsl:otherwise>
										</xsl:choose>
									</a>
								</li>
							</ul>
						</div>
					</div>
					<div class="serials-branding">
						<a>
							<xsl:attribute name="href">http://<xsl:value-of select="//SERVER"/><xsl:value-of select="//PATH_DATA"/>scielo.php?lng=<xsl:value-of select="normalize-space(//CONTROLINFO/LANGUAGE)"/></xsl:attribute>
							<img alt="Educ@" src="/img/pt/scielobre.gif"/>
						</a>
					</div>
				</header>
				<section class="serials-breadcrumb">
					<div class="serials-breadcrumb-inner">
						<ol class="breadcrumb mb-0 ps-0">
							<li class="breadcrumb-item">
								<a href="/scielo.php?lng={normalize-space(//CONTROLINFO/LANGUAGE)}" aria-label="Home">
									<svg class="serial-home-icon serial-home-icon-breadcrumb" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
										<path d="M3 11.5L12 4l9 7.5"/>
										<path d="M5.5 10.5V20h5v-6h3v6h5v-9.5"/>
									</svg>
								</a>
							</li>
							<li class="breadcrumb-item">
								<xsl:choose><xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='en'">Journals</xsl:when><xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='es'">Revistas</xsl:when><xsl:otherwise>Peri&#243;dicos</xsl:otherwise></xsl:choose>
							</li>
						</ol>
						<a class="btn btn-sm btn-secondary scielo__btn-with-icon--only serial-share-btn" href="mailto:?subject=Peri&#243;dicos&amp;body=http://{//SERVER}{//PATH_DATA}scielo.php?script=sci_alphabetic%26lng={normalize-space(//CONTROLINFO/LANGUAGE)}%26nrm=iso">
							<xsl:attribute name="aria-label"><xsl:choose><xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='en'">Share</xsl:when><xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='es'">Compartir</xsl:when><xsl:otherwise>Compartilhar</xsl:otherwise></xsl:choose></xsl:attribute>
							<svg class="serial-share-icon" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
								<circle cx="18" cy="5" r="2.4"/>
								<circle cx="6" cy="12" r="2.4"/>
								<circle cx="18" cy="19" r="2.4"/>
								<path d="M8.2 11l7.6-4.4"/>
								<path d="M8.2 13l7.6 4.4"/>
							</svg>
							<span class="serial-share-caret">&#9662;</span>
						</a>
					</div>
				</section>
				<main id="main-content" tabindex="-1" class="serials-content">
				<xsl:apply-templates select="//LIST"/>
				<br/>
				<xsl:call-template name="SERIALS_FOOTER"/>
				</main>
				<div class="serials-template-utils">
					<a href="mailto:educ@fcc.org.br?subject=Reportar%20erro" class="serials-template-report"><xsl:choose><xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='en'">Report error</xsl:when><xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='es'">Reportar error</xsl:when><xsl:otherwise>Reportar erro</xsl:otherwise></xsl:choose></a>
					<a href="#main-content" class="serials-template-accessibility"><xsl:attribute name="aria-label"><xsl:choose><xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='en'">Accessibility</xsl:when><xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='es'">Accesibilidad</xsl:when><xsl:otherwise>Acessibilidade</xsl:otherwise></xsl:choose></xsl:attribute>A</a>
				</div>
				<script type="text/javascript" src="/js/educa-accessibility.js?v=20260615-details-1"></script>
			</body>
		</html>
	</xsl:template>
	<xsl:template match="LIST">
		<section class="journal-list-wrapper">
			<h1 class="journal-list-page-title">
				<xsl:choose>
					<xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='en'">Journals</xsl:when>
					<xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='es'">Revistas</xsl:when>
					<xsl:otherwise>Peri&#243;dicos</xsl:otherwise>
				</xsl:choose>
			</h1>
			<div class="journal-list-tabs">
				<a class="journal-tab active" href="/scielo.php?script=sci_alphabetic&amp;lng={normalize-space(//CONTROLINFO/LANGUAGE)}&amp;nrm={normalize-space(//CONTROLINFO/STANDARD)}">
					<xsl:choose>
						<xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='en'">Alphabetic</xsl:when>
						<xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='es'">Alfab&#233;tica</xsl:when>
						<xsl:otherwise>Alfab&#233;tica</xsl:otherwise>
					</xsl:choose>
				</a>
			</div>
			<div class="journal-list-toolbar">
				<div class="journal-filters">
					<button class="filter-pill" type="button" data-journal-status-filter="all">
						<xsl:choose>
							<xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='en'">All</xsl:when>
							<xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='es'">Todos</xsl:when>
							<xsl:otherwise>Todos</xsl:otherwise>
						</xsl:choose>
					</button>
					<button class="filter-pill active" type="button" data-journal-status-filter="active"><span class="dot active">&#9679;</span>
						<xsl:choose>
							<xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='en'">Active</xsl:when>
							<xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='es'">Activos</xsl:when>
							<xsl:otherwise>Ativos</xsl:otherwise>
						</xsl:choose>
					</button>
					<button class="filter-pill" type="button" data-journal-status-filter="discontinued"><span class="dot discontinued">&#9679;</span>
						<xsl:choose>
							<xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='en'">Discontinued</xsl:when>
							<xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='es'">Descontinuados</xsl:when>
							<xsl:otherwise>Descontinuados</xsl:otherwise>
						</xsl:choose>
					</button>
				</div>
				<input class="journal-filter-input" type="text">
					<xsl:attribute name="placeholder">
						<xsl:choose>
							<xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='en'">Type to filter the list</xsl:when>
							<xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='es'">Escriba para filtrar la lista</xsl:when>
							<xsl:otherwise>Digite para filtrar a lista</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
				</input>
			</div>
			<div class="journal-list-header">
				<div class="journal-list-title">
					<xsl:attribute name="data-title-label">
						<xsl:choose>
							<xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='en'">Titles</xsl:when>
							<xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='es'">T&#237;tulos</xsl:when>
							<xsl:otherwise>T&#237;tulos</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:attribute name="data-total-label">
						<xsl:choose>
							<xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='en'">total</xsl:when>
							<xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='es'">total</xsl:when>
							<xsl:otherwise>total</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:choose>
						<xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='en'">Titles (total <xsl:value-of select="count(SERIAL)"/>)</xsl:when>
						<xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='es'">T&#237;tulos (total <xsl:value-of select="count(SERIAL)"/>)</xsl:when>
						<xsl:otherwise>T&#237;tulos (total <xsl:value-of select="count(SERIAL)"/>)</xsl:otherwise>
					</xsl:choose>
				</div>
			</div>
			<xsl:apply-templates select="." mode="display-list"/>
			<script type="text/javascript"><![CDATA[
				(function () {
				  var wrapper = document.currentScript.parentNode;
				  var filters = wrapper.querySelectorAll('[data-journal-status-filter]');
				  var input = wrapper.querySelector('.journal-filter-input');
				  var items = wrapper.querySelectorAll('.journal-item');
				  var title = wrapper.querySelector('.journal-list-title');
				  var currentFilter = 'active';

				  function normalize(value) {
				    return String(value || '').toLowerCase();
				  }

				  function updateTitle(visibleCount) {
				    if (!title) {
				      return;
				    }
				    var label = title.getAttribute('data-title-label') || 'Titles';
				    var totalLabel = title.getAttribute('data-total-label') || 'total';
				    title.textContent = label + ' (' + totalLabel + ' ' + visibleCount + ')';
				  }

				  function applyFilters() {
				    var query = normalize(input ? input.value : '');
				    var visibleCount = 0;

				    Array.prototype.forEach.call(items, function (item) {
				      var status = item.getAttribute('data-journal-status') || 'active';
				      var titleLink = item.querySelector('.journal-title');
				      var titleText = normalize(titleLink ? titleLink.textContent : item.textContent);
				      var statusMatches = currentFilter === 'all' || currentFilter === status;
				      var textMatches = !query || titleText.indexOf(query) !== -1;
				      var visible = statusMatches && textMatches;

				      item.style.display = visible ? '' : 'none';
				      if (visible) {
				        visibleCount += 1;
				      }
				    });

				    updateTitle(visibleCount);
				  }

				  Array.prototype.forEach.call(filters, function (button) {
				    button.addEventListener('click', function () {
				      currentFilter = button.getAttribute('data-journal-status-filter') || 'all';
				      Array.prototype.forEach.call(filters, function (item) {
				        item.classList.toggle('active', item === button);
				      });
				      applyFilters();
				    });
				  });

				  if (input) {
				    input.addEventListener('input', applyFilters);
				  }

				  function text(node) {
				    return node ? String(node.textContent || '').replace(/\s+/g, ' ').trim() : '';
				  }

				  var pageLang = (document.documentElement.getAttribute('lang') || 'pt').toLowerCase();
				  var latestLabel = pageLang === 'en' ? 'Last' : (pageLang === 'es' ? 'Último' : 'Último');
				  var volumeLabel = pageLang === 'en' ? 'Volume' : (pageLang === 'es' ? 'Volumen' : 'Volume');
				  var issueLabel = pageLang === 'en' ? 'Issue' : (pageLang === 'es' ? 'Número' : 'Número');

				  function hydrateLatest(item) {
				    var target = item.querySelector('.journal-latest-meta');
				    var url = item.getAttribute('data-issues-url');
				    if (!target || !url || target.getAttribute('data-loaded') === '1') {
				      return;
				    }
				    target.setAttribute('data-loaded', '1');
				    fetch(url, { credentials: 'same-origin' })
				      .then(function (response) { return response.ok ? response.text() : ''; })
				      .then(function (html) {
				        if (!html) {
				          return;
				        }
				        var doc = new DOMParser().parseFromString(html, 'text/html');
				        var row = doc.querySelector('.issueList tbody tr');
				        if (!row) {
				          return;
				        }
				        var cells = row.querySelectorAll('th, td');
				        var year = text(cells[0]);
				        var volume = text(row.querySelector('th.table-active')) || text(cells[1]);
				        var issue = text(row.querySelector('td.left a.btn')) || text(row.querySelector('td.left'));
				        if (/^(artigos?|articles?|artículos?)$/i.test(issue)) {
				          issue = '';
				        }
				        var parts = [];
				        if (year) {
				          parts.push(latestLabel + ': ' + year);
				        }
				        if (volume) {
				          parts.push(volumeLabel + ': ' + volume);
				        }
				        if (issue) {
				          parts.push(issueLabel + ': ' + issue);
				        }
				        if (parts.length) {
				          target.textContent = ', ' + parts.join(', ');
				        }
				      })
				      .catch(function () {});
				  }

				  Array.prototype.forEach.call(items, hydrateLatest);
				  applyFilters();
				}());
			]]></script>
		</section>
	</xsl:template>
	<xsl:template match="*" mode="display-list">
		<ul class="journal-catalog">
			<xsl:apply-templates select="SERIAL"/>
		</ul>
	</xsl:template>
	<xsl:template match="*" mode="classified">
		<xsl:variable name="count" select="count(SERIAL[.//current-status/@status='C'])"/>
		<xsl:variable name="c" select="count(SERIAL[.//current-status/@status!='C' or not(journal-status-history)])"/>
		<xsl:apply-templates select="." mode="display-msg-current-list">
			<xsl:with-param name="count" select="$count"/>
		</xsl:apply-templates>
		<ul class="journal-catalog">
			<xsl:apply-templates select="SERIAL[.//current-status/@status='C']"/>
		</ul>
		<xsl:if test="SERIAL[.//current-status/@status!='C'  or not(journal-status-history)]">
			<xsl:apply-templates select="." mode="display-msg-not-current-list">
				<xsl:with-param name="count" select="$c"/>
			</xsl:apply-templates>
			<ul class="journal-catalog">
				<xsl:apply-templates select="SERIAL[.//current-status/@status!='C' or not(journal-status-history)]"/>
			</ul>
		</xsl:if>
	</xsl:template>
	<xsl:template match="SERIAL">
		<xsl:variable name="pid" select="TITLE/@ISSN"/>
		<xsl:variable name="lang" select="normalize-space(//CONTROLINFO/LANGUAGE)"/>
		<xsl:variable name="nrm" select="normalize-space(//CONTROLINFO/STANDARD)"/>
		<xsl:variable name="serialUrl">http://<xsl:value-of select="//SERVER"/><xsl:value-of select="//PATH_DATA"/>scielo.php?script=<xsl:apply-templates select="." mode="sci_serial"/>&amp;pid=<xsl:value-of select="$pid"/>&amp;lng=<xsl:value-of select="$lang"/>&amp;nrm=<xsl:value-of select="$nrm"/><xsl:apply-templates select="." mode="repo_url_param"/></xsl:variable>
		<xsl:variable name="issuesUrl">/scielo.php?script=sci_issues&amp;pid=<xsl:value-of select="$pid"/>&amp;lng=<xsl:value-of select="$lang"/>&amp;nrm=<xsl:value-of select="$nrm"/></xsl:variable>
		<xsl:variable name="journalLinkBase">/journal_link.php?pid=<xsl:value-of select="$pid"/>&amp;lng=<xsl:value-of select="$lang"/>&amp;nrm=<xsl:value-of select="$nrm"/>&amp;page=</xsl:variable>
		<li class="journal-item">
			<xsl:attribute name="data-journal-status">
				<xsl:choose>
					<xsl:when test=".//current-status/@status='C' or not(.//current-status/@status) or .//current-status/@status=''">active</xsl:when>
					<xsl:otherwise>discontinued</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:attribute name="data-issues-url"><xsl:value-of select="$issuesUrl"/></xsl:attribute>
			<div class="journal-main-line">
				<span>
					<xsl:attribute name="class">
						<xsl:text>journal-status-dot</xsl:text>
						<xsl:if test=".//current-status/@status='C' or not(.//current-status/@status) or .//current-status/@status=''">
							<xsl:text> is-active</xsl:text>
						</xsl:if>
					</xsl:attribute>
				</span>
				<a class="journal-title">
					<xsl:attribute name="href"><xsl:value-of select="$serialUrl"/></xsl:attribute>
					<xsl:value-of select="TITLE" disable-output-escaping="yes"/>
				</a>
				<xsl:if test="not(//NO_SCI_SERIAL='yes')">
					<span class="journal-meta">
						<xsl:value-of select="@QTYISS"/>&#160;<xsl:value-of select="$translations/xslid[@id='sci_alphabetic']/text[@find='issue']"/><xsl:if test="@QTYISS &gt; 1">s</xsl:if><span class="journal-latest-meta"></span>
					</span>
				</xsl:if>
				<xsl:if test=".//current-status/@status!='' and .//current-status/@status!='C'">
					<span class="journal-meta"> - <xsl:apply-templates select=".//journal-status-history" mode="display-status-info"/></span>
				</xsl:if>
			</div>
			<div class="journal-action-row">
				<xsl:attribute name="aria-label"><xsl:choose><xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='en'">Journal actions</xsl:when><xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='es'">Acciones de la revista</xsl:when><xsl:otherwise>Ações do periódico</xsl:otherwise></xsl:choose></xsl:attribute>
				<a class="journal-action-btn" href="{$journalLinkBase}home">
					<xsl:attribute name="title"><xsl:choose><xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='en'">Journal home</xsl:when><xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='es'">Home de la revista</xsl:when><xsl:otherwise>Home do periódico</xsl:otherwise></xsl:choose></xsl:attribute>
					<xsl:attribute name="aria-label"><xsl:choose><xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='en'">Journal home</xsl:when><xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='es'">Home de la revista</xsl:when><xsl:otherwise>Home do periódico</xsl:otherwise></xsl:choose></xsl:attribute>
					<svg viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="M3 11.5L12 4l9 7.5"/><path d="M5.5 10.5V20h5v-6h3v6h5v-9.5"/></svg>
				</a>
				<a class="journal-action-btn" href="{$journalLinkBase}site">
					<xsl:attribute name="title"><xsl:choose><xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='en'">External link</xsl:when><xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='es'">Enlace externo</xsl:when><xsl:otherwise>Link externo</xsl:otherwise></xsl:choose></xsl:attribute>
					<xsl:attribute name="aria-label"><xsl:choose><xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='en'">External link</xsl:when><xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='es'">Enlace externo</xsl:when><xsl:otherwise>Link externo</xsl:otherwise></xsl:choose></xsl:attribute>
					<svg viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="M8 8h-3v11h11v-3"/><path d="M13 5h6v6"/><path d="M11 13l8-8"/></svg>
				</a>
				<a class="journal-action-btn" href="{$journalLinkBase}about">
					<xsl:attribute name="title"><xsl:choose><xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='en'">About the journal</xsl:when><xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='es'">Acerca de la revista</xsl:when><xsl:otherwise>Sobre o periódico</xsl:otherwise></xsl:choose></xsl:attribute>
					<xsl:attribute name="aria-label"><xsl:choose><xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='en'">About the journal</xsl:when><xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='es'">Acerca de la revista</xsl:when><xsl:otherwise>Sobre o periódico</xsl:otherwise></xsl:choose></xsl:attribute>
					<svg viewBox="0 0 24 24" aria-hidden="true" focusable="false"><circle cx="12" cy="12" r="9"/><path d="M12 10v6"/><path d="M12 7h.01"/></svg>
				</a>
				<a class="journal-action-btn" href="{$journalLinkBase}issues">
					<xsl:attribute name="title"><xsl:choose><xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='en'">All issues</xsl:when><xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='es'">Todos los números</xsl:when><xsl:otherwise>Todos os números</xsl:otherwise></xsl:choose></xsl:attribute>
					<xsl:attribute name="aria-label"><xsl:choose><xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='en'">All issues</xsl:when><xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='es'">Todos los números</xsl:when><xsl:otherwise>Todos os números</xsl:otherwise></xsl:choose></xsl:attribute>
					<svg viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="M8 6h13"/><path d="M8 12h13"/><path d="M8 18h13"/><path d="M3 6h.01"/><path d="M3 12h.01"/><path d="M3 18h.01"/></svg>
				</a>
				<a class="journal-action-btn" href="{$journalLinkBase}board">
					<xsl:attribute name="title"><xsl:choose><xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='en'">Editorial Board</xsl:when><xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='es'">Comité editorial</xsl:when><xsl:otherwise>Corpo editorial</xsl:otherwise></xsl:choose></xsl:attribute>
					<xsl:attribute name="aria-label"><xsl:choose><xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='en'">Editorial Board</xsl:when><xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='es'">Comité editorial</xsl:when><xsl:otherwise>Corpo editorial</xsl:otherwise></xsl:choose></xsl:attribute>
					<svg viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
				</a>
				<a class="journal-action-btn" href="{$journalLinkBase}instructions">
					<xsl:attribute name="title"><xsl:choose><xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='en'">Instructions to authors</xsl:when><xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='es'">Instrucciones a los autores</xsl:when><xsl:otherwise>Instruções aos autores</xsl:otherwise></xsl:choose></xsl:attribute>
					<xsl:attribute name="aria-label"><xsl:choose><xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='en'">Instructions to authors</xsl:when><xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='es'">Instrucciones a los autores</xsl:when><xsl:otherwise>Instruções aos autores</xsl:otherwise></xsl:choose></xsl:attribute>
					<svg viewBox="0 0 24 24" aria-hidden="true" focusable="false"><circle cx="12" cy="12" r="9"/><path d="M9.5 9a2.7 2.7 0 1 1 4.8 1.7c-.9.7-1.5 1.2-1.8 2.3"/><path d="M12 17h.01"/></svg>
				</a>
				<a class="journal-action-btn" href="{$journalLinkBase}contact">
					<xsl:attribute name="title"><xsl:choose><xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='en'">Contact</xsl:when><xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='es'">Contacto</xsl:when><xsl:otherwise>Contato</xsl:otherwise></xsl:choose></xsl:attribute>
					<xsl:attribute name="aria-label"><xsl:choose><xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='en'">Contact</xsl:when><xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='es'">Contacto</xsl:when><xsl:otherwise>Contato</xsl:otherwise></xsl:choose></xsl:attribute>
					<svg viewBox="0 0 24 24" aria-hidden="true" focusable="false"><rect x="3" y="5" width="18" height="14" rx="2"/><path d="M3 7l9 6 9-6"/></svg>
				</a>
				<a class="journal-action-btn" href="{$journalLinkBase}metrics">
					<xsl:attribute name="title"><xsl:choose><xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='en'">Metrics</xsl:when><xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='es'">Métricas</xsl:when><xsl:otherwise>Métricas</xsl:otherwise></xsl:choose></xsl:attribute>
					<xsl:attribute name="aria-label"><xsl:choose><xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='en'">Metrics</xsl:when><xsl:when test="normalize-space(//CONTROLINFO/LANGUAGE)='es'">Métricas</xsl:when><xsl:otherwise>Métricas</xsl:otherwise></xsl:choose></xsl:attribute>
					<svg viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="M4 19V5"/><path d="M4 19h16"/><path d="M8 16l3-4 3 2 5-7"/></svg>
				</a>
			</div>
		</li>
	</xsl:template>
	<xsl:template match="COPYRIGHT">
		<xsl:call-template name="COPYRIGHTSCIELO"/>
	</xsl:template>
	<xsl:template name="SERIALS_FOOTER">
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
				<img alt="Open Access" src="/design-system/1.0.0/img/logo-open-access.svg"/>
				<a href="https://www.gov.br/funag/pt-br/centrais-de-conteudo/publicacoes/acesso-aberto" target="_blank" rel="noopener noreferrer">Leia a Declaração de Acesso Aberto</a>
			</div>
		</footer>
	</xsl:template>
</xsl:stylesheet>
