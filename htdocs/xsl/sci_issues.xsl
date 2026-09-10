<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:include href="sci_navegation.xsl"/>
	<xsl:include href="journalStatus.xsl"/>
	<xsl:output method="html" indent="no"/>
	<xsl:variable name="analytics_code" select="//ANALYTICS_CODE"/>
	<xsl:template name="ISSUES_UI_TEXT">
		<xsl:param name="key"/>
		<xsl:param name="lang" select="normalize-space(/SERIAL/CONTROLINFO/LANGUAGE)"/>
		<xsl:choose>
			<xsl:when test="$key='all_issues'"><xsl:choose><xsl:when test="$lang='en'">All issues</xsl:when><xsl:when test="$lang='es'">Todos los números</xsl:when><xsl:otherwise>Todos os números</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='journal_home'"><xsl:choose><xsl:when test="$lang='en'">Journal home</xsl:when><xsl:when test="$lang='es'">Home de la revista</xsl:when><xsl:otherwise>Home do periódico</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='previous_issue'"><xsl:choose><xsl:when test="$lang='en'">Previous issue</xsl:when><xsl:when test="$lang='es'">Número anterior</xsl:when><xsl:otherwise>Número anterior</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='next_issue'"><xsl:choose><xsl:when test="$lang='en'">Next issue</xsl:when><xsl:when test="$lang='es'">Número siguiente</xsl:when><xsl:otherwise>Número seguinte</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='current_issue'"><xsl:choose><xsl:when test="$lang='en'">Current issue</xsl:when><xsl:when test="$lang='es'">Número actual</xsl:when><xsl:otherwise>Número atual</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='search'"><xsl:choose><xsl:when test="$lang='en'">Search</xsl:when><xsl:when test="$lang='es'">Búsqueda</xsl:when><xsl:otherwise>Pesquisa</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='journal_list'"><xsl:choose><xsl:when test="$lang='en'">Journal list</xsl:when><xsl:when test="$lang='es'">Lista de revistas</xsl:when><xsl:otherwise>Lista de periódicos</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='about_educa'"><xsl:choose><xsl:when test="$lang='en'">About Educ@</xsl:when><xsl:when test="$lang='es'">Acerca de Educ@</xsl:when><xsl:otherwise>Sobre o Educ@</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='team_educa'"><xsl:choose><xsl:when test="$lang='en'">Educ@ Team</xsl:when><xsl:when test="$lang='es'">Equipo Educ@</xsl:when><xsl:otherwise>Equipe Educ@</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='metrics'"><xsl:choose><xsl:when test="$lang='en'">Metrics</xsl:when><xsl:when test="$lang='es'">Métricas</xsl:when><xsl:otherwise>Métricas</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='tools'"><xsl:choose><xsl:when test="$lang='en'">Tools</xsl:when><xsl:when test="$lang='es'">Herramientas</xsl:when><xsl:otherwise>Ferramentas</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='journals'"><xsl:choose><xsl:when test="$lang='en'">Journals</xsl:when><xsl:when test="$lang='es'">Revistas</xsl:when><xsl:otherwise>Periódicos</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='volume'"><xsl:choose><xsl:when test="$lang='en'">Volume</xsl:when><xsl:when test="$lang='es'">Volumen</xsl:when><xsl:otherwise>Volume</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='share'"><xsl:choose><xsl:when test="$lang='en'">Share</xsl:when><xsl:when test="$lang='es'">Compartir</xsl:when><xsl:otherwise>Compartilhar</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='published_by'"><xsl:choose><xsl:when test="$lang='en'">Published by:</xsl:when><xsl:when test="$lang='es'">Publicación de:</xsl:when><xsl:otherwise>Publicação de:</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='area'"><xsl:choose><xsl:when test="$lang='en'">Area:</xsl:when><xsl:when test="$lang='es'">Área:</xsl:when><xsl:otherwise>Área:</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='print_issn'"><xsl:choose><xsl:when test="$lang='en'">Print version ISSN:</xsl:when><xsl:when test="$lang='es'">Versión impresa ISSN:</xsl:when><xsl:otherwise>Versão impressa ISSN:</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='online_issn'"><xsl:choose><xsl:when test="$lang='en'">Online version ISSN:</xsl:when><xsl:when test="$lang='es'">Versión en línea ISSN:</xsl:when><xsl:otherwise>Versão on-line ISSN:</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='about_journal'"><xsl:choose><xsl:when test="$lang='en'">About the journal</xsl:when><xsl:when test="$lang='es'">Acerca de la revista</xsl:when><xsl:otherwise>Sobre o periódico</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='editorial_policy'"><xsl:choose><xsl:when test="$lang='en'">Editorial policy</xsl:when><xsl:when test="$lang='es'">Política editorial</xsl:when><xsl:otherwise>Política editorial</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='editorial_board'"><xsl:choose><xsl:when test="$lang='en'">Editorial Board</xsl:when><xsl:when test="$lang='es'">Comité editorial</xsl:when><xsl:otherwise>Corpo Editorial</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='instructions'"><xsl:choose><xsl:when test="$lang='en'">Instructions to authors</xsl:when><xsl:when test="$lang='es'">Instrucciones a los autores</xsl:when><xsl:otherwise>Instruções aos autores</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='contact'"><xsl:choose><xsl:when test="$lang='en'">Contact</xsl:when><xsl:when test="$lang='es'">Contacto</xsl:when><xsl:otherwise>Contato</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='articles'"><xsl:choose><xsl:when test="$lang='en'">Articles</xsl:when><xsl:when test="$lang='es'">Artículos</xsl:when><xsl:otherwise>Artigos</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='report_error'"><xsl:choose><xsl:when test="$lang='en'">Report error</xsl:when><xsl:when test="$lang='es'">Reportar error</xsl:when><xsl:otherwise>Reportar erro</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='accessibility'"><xsl:choose><xsl:when test="$lang='en'">Accessibility</xsl:when><xsl:when test="$lang='es'">Accesibilidad</xsl:when><xsl:otherwise>Acessibilidade</xsl:otherwise></xsl:choose></xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:variable name="PRESENTATION_SORTED_BY_PUBDATE"><xsl:value-of select="//show_issues_sorted_by_pubdate"/></xsl:variable>
	<xsl:variable name="pref">
		<xsl:choose>
			<xsl:when test="//CONTROLINFO/LANGUAGE='en' ">i</xsl:when>
			<xsl:when test="//CONTROLINFO/LANGUAGE='es' ">e</xsl:when>
			<xsl:when test="//CONTROLINFO/LANGUAGE='pt' ">p</xsl:when>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="spaceYear" select="'12%'"/>
	<xsl:variable name="spaceVol" select="'7%'"/>
	<xsl:variable name="spaceIssue" select="'5%'"/>
	<xsl:variable name="spaceIssues" select="'70%'"/>
	<!--xsl:variable name="columns" select="//COLUMNS"/>
	<xsl:variable name="colnumber">
		<xsl:choose>
			<xsl:when test="$columns='' or not($columns)">14</xsl:when>
			<xsl:when test="$columns &lt; 14">12</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$columns"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable-->
	<xsl:variable name="colnumber">
		<xsl:choose>
			<xsl:when test=".//YEARISSUE[count(.//ISSUE)&gt;12]">14</xsl:when>
			<xsl:otherwise>12</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:template match="SERIAL">
		<HTML lang="{normalize-space(//CONTROLINFO/LANGUAGE)}">
			<HEAD>
				<TITLE>
					<xsl:value-of select="//TITLEGROUP/SHORTTITLE " disable-output-escaping="yes"/> - <xsl:call-template name="ISSUES_UI_TEXT"><xsl:with-param name="key">all_issues</xsl:with-param></xsl:call-template>
				</TITLE>
				<LINK href="/css/scielo.css" type="text/css" rel="STYLESHEET"/>
				<link rel="stylesheet" type="text/css" href="/design-system/1.0.0/css/bootstrap.css"/>
				<link rel="stylesheet" type="text/css" href="/design-system/1.0.0/css/article.css"/>
				<link rel="STYLESHEET" TYPE="text/css" href="/css/include_layout.css"/>
				<link rel="STYLESHEET" TYPE="text/css" href="/css/include_styles.css"/>
				<link rel="stylesheet" type="text/css" href="/css/scielo-ds-bridge.css?v=issues-20260614-18"/>
				<style type="text/css" title="Gold">
/* The following is for windows that aren't tall enough for
   the fixed menu. Use the scrolling menu instead. */
.note {
  color:#800000
}
.note2 {
  color: black
}

</style>

				<META http-equiv="Pragma" content="no-cache"/>
				<META HTTP-EQUIV="Expires" CONTENT="Mon, 06 Jan 1990 00:00:01 GMT"/>
				<meta name="viewport" content="width=device-width, initial-scale=1"/>
			</HEAD>
			<BODY class="issues-page" vLink="#800080" bgColor="#ffffff">
				<xsl:call-template name="ACCESS_SKIP_LINK"/>
				<header class="serial-modern-header">
					<details class="home-main-menu serial-modern-menu">
						<summary class="serial-modern-menu-btn">&#9776; Menu</summary>
						<ul class="home-main-dropdown">
							<li><a href="/search_mvp.php?lang={normalize-space(CONTROLINFO/LANGUAGE)}"><xsl:call-template name="ISSUES_UI_TEXT"><xsl:with-param name="key">search</xsl:with-param></xsl:call-template></a></li>
							<li><a href="/scielo.php?script=sci_alphabetic&amp;lng={normalize-space(CONTROLINFO/LANGUAGE)}&amp;nrm=iso"><xsl:call-template name="ISSUES_UI_TEXT"><xsl:with-param name="key">journal_list</xsl:with-param></xsl:call-template></a></li>
							<li><a href="https://educa.fcc.org.br/metricas/?lang=pt">Métricas e Indicadores</a></li>
							<li><a href="/about/?lang={normalize-space(CONTROLINFO/LANGUAGE)}"><xsl:call-template name="ISSUES_UI_TEXT"><xsl:with-param name="key">about_educa</xsl:with-param></xsl:call-template></a></li>
							<li><a href="/equipe/equipe_p.htm"><xsl:call-template name="ISSUES_UI_TEXT"><xsl:with-param name="key">team_educa</xsl:with-param></xsl:call-template></a></li>
						</ul>
					</details>
					<a class="serial-modern-brand" href="/scielo.php?lng={normalize-space(CONTROLINFO/LANGUAGE)}">
						<img alt="Educ@" src="/img/pt/scielobre.gif"/>
					</a>
					<div class="sci-nav-lang-menu serial-modern-lang">
						<button class="sci-nav-lang-btn" type="button" aria-haspopup="true" aria-expanded="false">
							&#127760;
							<xsl:text> </xsl:text>
							<xsl:choose>
								<xsl:when test="normalize-space(CONTROLINFO/LANGUAGE)='pt'">Português</xsl:when>
								<xsl:when test="normalize-space(CONTROLINFO/LANGUAGE)='es'">Español</xsl:when>
								<xsl:otherwise>English</xsl:otherwise>
							</xsl:choose>
							<xsl:text> &#9662;</xsl:text>
						</button>
						<ul class="sci-nav-lang-dropdown">
							<xsl:if test="normalize-space(CONTROLINFO/LANGUAGE) != 'pt'">
								<li><a href="/scielo.php?script=sci_issues&amp;pid={ISSN_AS_ID}&amp;lng=pt&amp;nrm=iso">Português</a></li>
							</xsl:if>
							<xsl:if test="normalize-space(CONTROLINFO/LANGUAGE) != 'en'">
								<li><a href="/scielo.php?script=sci_issues&amp;pid={ISSN_AS_ID}&amp;lng=en&amp;nrm=iso">English</a></li>
							</xsl:if>
							<xsl:if test="normalize-space(CONTROLINFO/LANGUAGE) != 'es'">
								<li><a href="/scielo.php?script=sci_issues&amp;pid={ISSN_AS_ID}&amp;lng=es&amp;nrm=iso">Español</a></li>
							</xsl:if>
						</ul>
					</div>
				</header>
				<main id="main-content" tabindex="-1">
					<h1 class="visually-hidden">
						<xsl:value-of select="//TITLEGROUP/TITLE" disable-output-escaping="yes"/> - <xsl:call-template name="ISSUES_UI_TEXT"><xsl:with-param name="key">all_issues</xsl:with-param></xsl:call-template>
					</h1>
					<xsl:call-template name="ISSUES_PERIODICAL_HEADER"/>
					<div class="content">
						<xsl:apply-templates select="//AVAILISSUES"/>
					</div>
					<script type="text/javascript">
					(function () {
						function label(count, lang) {
							var n = Number(count || 0);
							if (lang === 'en') {
								return n + ' ' + (n === 1 ? 'article' : 'articles');
							}
							if (lang === 'es') {
								return n + ' ' + (n === 1 ? 'artículo' : 'artículos');
							}
							return n + ' ' + (n === 1 ? 'artigo' : 'artigos');
						}

						Array.prototype.forEach.call(document.querySelectorAll('.issue-article-count'), function (link) {
							var pid = link.getAttribute('data-issue-pid') || '';
							var lang = link.getAttribute('data-lang') || 'pt';
							if (!pid || !window.fetch) {
								return;
							}
							fetch('/issue_article_count.php?pid=' + encodeURIComponent(pid) + '&amp;lang=' + encodeURIComponent(lang), { credentials: 'same-origin' })
								.then(function (response) { return response.ok ? response.json() : null; })
								.then(function (data) {
									if (data &amp;&amp; data.ok) {
										link.textContent = label(data.count, lang);
										link.setAttribute('title', label(data.count, lang));
									}
								})
								.catch(function () {});
						});
					}());
					</script>
					<div class="serial-template-utils">
						<a href="mailto:educ@fcc.org.br?subject=Reportar%20erro" class="serial-template-report"><xsl:call-template name="ISSUES_UI_TEXT"><xsl:with-param name="key">report_error</xsl:with-param></xsl:call-template></a>
						<a href="#main-content" class="serial-template-accessibility"><xsl:call-template name="ISSUES_UI_TEXT"><xsl:with-param name="key">accessibility</xsl:with-param></xsl:call-template></a>
					</div>
					<script type="text/javascript" src="/js/educa-accessibility.js?v=20260615-details-1"></script>
				</main>
				<div class="serial-page issues-footer-shell">
					<div class="container issues-footer-container">
						<xsl:apply-templates select="." mode="footer-journal"/>
					</div>
				</div>
			</BODY>
		</HTML>
	</xsl:template>

	<xsl:template match="link" mode="issues-modern-action">
		<xsl:variable name="t" select="@type"/>
		<a class="list-group-item" href="{.}" target="_blank" rel="noopener noreferrer">
			<svg class="journal-side-icon" viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="M8 8h-3v11h11v-3"/><path d="M13 5h6v6"/><path d="M11 13l8-8"/></svg>
			<xsl:choose>
				<xsl:when test="$t='online_submission'">Submissão de manuscritos</xsl:when>
				<xsl:when test="$t='journal_site'">Site do periódico</xsl:when>
				<xsl:otherwise><xsl:value-of select="@label"/></xsl:otherwise>
			</xsl:choose>
		</a>
	</xsl:template>

	<xsl:template name="ISSUES_PERIODICAL_HEADER">
		<xsl:variable name="lang" select="normalize-space(//CONTROLINFO/LANGUAGE)"/>
		<xsl:variable name="journalHome" select="concat('/scielo.php?script=sci_serial&amp;pid=', /SERIAL/ISSN_AS_ID, '&amp;lng=', $lang, '&amp;nrm=iso')"/>
		<xsl:variable name="issuesUrl" select="concat('/scielo.php?script=sci_issues&amp;pid=', /SERIAL/ISSN_AS_ID, '&amp;lng=', $lang, '&amp;nrm=iso')"/>
		<section class="d-block journalInfo">
			<div class="container">
				<div class="row">
					<div class="col-12 col-lg-9 pt-4 pb-4">
						<a href="{$journalHome}" class="journalInfo-logo-link">
							<img src="{//CONTROLINFO/SCIELO_INFO/PATH_SERIMG}{/SERIAL/TITLEGROUP/SIGLUM}/glogo.gif" alt="{/SERIAL/TITLEGROUP/TITLE}"/>
						</a>
						<h1 class="h4">
							<img src="/design-system/1.0.0/img/logo-open-access.svg" alt="Open-access" class="logo-open-access"/>
							<xsl:value-of select="/SERIAL/TITLEGROUP/TITLE" disable-output-escaping="yes"/>
						</h1>
						<span class="publisher">
							<xsl:call-template name="ISSUES_UI_TEXT"><xsl:with-param name="key">published_by</xsl:with-param></xsl:call-template>
							<xsl:text> </xsl:text>
							<strong class="namePlublisher"><xsl:value-of select="/SERIAL/PUBLISHERS/PUBLISHER/NAME" disable-output-escaping="yes"/></strong>
						</span>
						<br/>
						<span class="theme">
							<span class="area"><xsl:call-template name="ISSUES_UI_TEXT"><xsl:with-param name="key">area</xsl:with-param></xsl:call-template></span>
							<xsl:text> </xsl:text>
							<xsl:value-of select="/SERIAL/TITLEGROUP/SUBJECT" disable-output-escaping="yes"/>
						</span>
						<span class="issn">
							<xsl:for-each select="/SERIAL/TITLE_ISSN">
								<div>
									<span class="issnLabel">
										<xsl:choose>
											<xsl:when test="@TYPE='PRINT'"><xsl:call-template name="ISSUES_UI_TEXT"><xsl:with-param name="key">print_issn</xsl:with-param></xsl:call-template></xsl:when>
											<xsl:otherwise><xsl:call-template name="ISSUES_UI_TEXT"><xsl:with-param name="key">online_issn</xsl:with-param></xsl:call-template></xsl:otherwise>
										</xsl:choose>
									</span>
									<xsl:text> </xsl:text>
									<xsl:value-of select="."/>
								</div>
							</xsl:for-each>
						</span>
						<div class="mt-3">
							<a href="https://creativecommons.org/licenses/by/4.0/" target="_blank" rel="license">
								<img src="https://licensebuttons.net/l/by/4.0/80x15.png" alt="Creative Commons - by 4.0"/>
							</a>
						</div>
					</div>
					<div class="col-12 col-lg-3 pt-lg-5 pb-4">
						<div class="list-group d-print-none mb-5">
							<xsl:apply-templates select="/SERIAL/link[@type='online_submission']" mode="issues-modern-action"/>
							<xsl:apply-templates select="/SERIAL/link[@type='journal_site']" mode="issues-modern-action"/>
							<a class="list-group-item" href="/revistas/{/SERIAL/TITLEGROUP/SIGLUM}/{$pref}aboutj.htm"><svg class="journal-side-icon" viewBox="0 0 24 24" aria-hidden="true" focusable="false"><circle cx="12" cy="12" r="9"/><path d="M12 10v6"/><path d="M12 7h.01"/></svg> <xsl:call-template name="ISSUES_UI_TEXT"><xsl:with-param name="key">about_journal</xsl:with-param></xsl:call-template></a>
							<a class="list-group-item" href="/revistas/{/SERIAL/TITLEGROUP/SIGLUM}/{$pref}edboard.htm"><svg class="journal-side-icon" viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg> <xsl:call-template name="ISSUES_UI_TEXT"><xsl:with-param name="key">editorial_board</xsl:with-param></xsl:call-template></a>
							<a class="list-group-item" href="/revistas/{/SERIAL/TITLEGROUP/SIGLUM}/{$pref}instruc.htm"><svg class="journal-side-icon" viewBox="0 0 24 24" aria-hidden="true" focusable="false"><circle cx="12" cy="12" r="9"/><path d="M9.5 9a2.7 2.7 0 1 1 4.8 1.7c-.9.7-1.5 1.2-1.8 2.3"/><path d="M12 17h.01"/></svg> <xsl:call-template name="ISSUES_UI_TEXT"><xsl:with-param name="key">instructions</xsl:with-param></xsl:call-template></a>
							<xsl:if test="/SERIAL/CONTACT/EMAILS/EMAIL">
								<a class="list-group-item" href="mailto:{/SERIAL/CONTACT/EMAILS/EMAIL[1]}"><svg class="journal-side-icon" viewBox="0 0 24 24" aria-hidden="true" focusable="false"><rect x="3" y="5" width="18" height="14" rx="2"/><path d="M3 7l9 6 9-6"/></svg> <xsl:call-template name="ISSUES_UI_TEXT"><xsl:with-param name="key">contact</xsl:with-param></xsl:call-template></a>
							</xsl:if>
						</div>
					</div>
				</div>
			</div>
		</section>

		<section class="levelMenu mb-3">
			<div class="container d-none d-xl-block">
				<div class="row">
					<div class="col-md-2 col-sm-2 serial-level-home">
						<a href="{$journalHome}" class="btn scielo__btn-with-icon--left">
							<svg class="serial-home-icon" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
								<path d="M10 20v-6h4v6h5v-8h3L12 3 2 12h3v8z"/>
							</svg>
							<xsl:call-template name="ISSUES_UI_TEXT"><xsl:with-param name="key">journal_home</xsl:with-param></xsl:call-template>
						</a>
					</div>
					<div class="col-md-8 col-sm-8 serial-level-issues">
						<div class="btn-group">
							<a href="{$issuesUrl}" class="btn selected"><xsl:call-template name="ISSUES_UI_TEXT"><xsl:with-param name="key">all_issues</xsl:with-param></xsl:call-template></a>
							<xsl:choose>
								<xsl:when test="//PREVIOUS/@PID">
									<a href="/scielo.php?script=sci_issuetoc&amp;pid={//PREVIOUS/@PID}&amp;lng={$lang}&amp;nrm=iso" class="btn">
										<xsl:attribute name="title"><xsl:call-template name="ISSUES_UI_TEXT"><xsl:with-param name="key">previous_issue</xsl:with-param></xsl:call-template></xsl:attribute>
										<xsl:text>&#171; </xsl:text><xsl:call-template name="ISSUES_UI_TEXT"><xsl:with-param name="key">previous_issue</xsl:with-param></xsl:call-template>
									</a>
								</xsl:when>
								<xsl:otherwise><a href="#" class="btn disabled"><xsl:attribute name="title"><xsl:call-template name="ISSUES_UI_TEXT"><xsl:with-param name="key">previous_issue</xsl:with-param></xsl:call-template></xsl:attribute><xsl:text>&#171; </xsl:text><xsl:call-template name="ISSUES_UI_TEXT"><xsl:with-param name="key">previous_issue</xsl:with-param></xsl:call-template></a></xsl:otherwise>
							</xsl:choose>
							<xsl:choose>
								<xsl:when test="//NEXT/@PID">
									<a href="/scielo.php?script=sci_issuetoc&amp;pid={//NEXT/@PID}&amp;lng={$lang}&amp;nrm=iso" class="btn">
										<xsl:attribute name="title"><xsl:call-template name="ISSUES_UI_TEXT"><xsl:with-param name="key">next_issue</xsl:with-param></xsl:call-template></xsl:attribute>
										<xsl:call-template name="ISSUES_UI_TEXT"><xsl:with-param name="key">next_issue</xsl:with-param></xsl:call-template><xsl:text> &#187;</xsl:text>
									</a>
								</xsl:when>
								<xsl:otherwise><a href="#" class="btn disabled"><xsl:attribute name="title"><xsl:call-template name="ISSUES_UI_TEXT"><xsl:with-param name="key">next_issue</xsl:with-param></xsl:call-template></xsl:attribute><xsl:call-template name="ISSUES_UI_TEXT"><xsl:with-param name="key">next_issue</xsl:with-param></xsl:call-template><xsl:text> &#187;</xsl:text></a></xsl:otherwise>
							</xsl:choose>
							<xsl:if test="//CONTROLINFO/ISSUES/CURRENT/@PID">
								<a href="/scielo.php?script=sci_issuetoc&amp;pid={//CONTROLINFO/ISSUES/CURRENT/@PID}&amp;lng={$lang}&amp;nrm=iso" class="btn active unselected">
									<xsl:attribute name="title"><xsl:call-template name="ISSUES_UI_TEXT"><xsl:with-param name="key">current_issue</xsl:with-param></xsl:call-template></xsl:attribute>
									<xsl:call-template name="ISSUES_UI_TEXT"><xsl:with-param name="key">current_issue</xsl:with-param></xsl:call-template>
								</a>
							</xsl:if>
						</div>
					</div>
					<div class="col-md-2 col-sm-2 text-end serial-level-tools">
						<div class="btn-group" role="group">
							<xsl:attribute name="aria-label"><xsl:call-template name="ISSUES_UI_TEXT"><xsl:with-param name="key">tools</xsl:with-param></xsl:call-template></xsl:attribute>
							<a href="/search_mvp.php?lang={$lang}&amp;journal={/SERIAL/ISSN_AS_ID}" class="btn single"><xsl:call-template name="ISSUES_UI_TEXT"><xsl:with-param name="key">search</xsl:with-param></xsl:call-template></a>
							<a href="https://educa.fcc.org.br/metricas/?lang=pt" class="btn scielo__btn-with-icon--left"><xsl:call-template name="ISSUES_UI_TEXT"><xsl:with-param name="key">metrics</xsl:with-param></xsl:call-template></a>
						</div>
					</div>
				</div>
			</div>
			<div class="container d-xl-none">
				<div class="row">
					<div class="col">
						<div class="btn-group mobile-main">
							<a href="{$journalHome}" class="btn btn-secondary scielo__btn-with-icon--only">
								<svg class="serial-home-icon" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
									<path d="M10 20v-6h4v6h5v-8h3L12 3 2 12h3v8z"/>
								</svg>
							</a>
							<a href="{$issuesUrl}" class="btn btn-secondary selected"><xsl:call-template name="ISSUES_UI_TEXT"><xsl:with-param name="key">all_issues</xsl:with-param></xsl:call-template></a>
							<a href="/search_mvp.php?lang={$lang}&amp;journal={/SERIAL/ISSN_AS_ID}" class="btn btn-secondary"><xsl:call-template name="ISSUES_UI_TEXT"><xsl:with-param name="key">search</xsl:with-param></xsl:call-template></a>
							<a href="https://educa.fcc.org.br/metricas/?lang=pt" class="btn btn-secondary"><xsl:call-template name="ISSUES_UI_TEXT"><xsl:with-param name="key">metrics</xsl:with-param></xsl:call-template></a>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col">
						<div class="btn-group mobile-issues">
							<xsl:choose>
								<xsl:when test="//PREVIOUS/@PID">
									<a href="/scielo.php?script=sci_issuetoc&amp;pid={//PREVIOUS/@PID}&amp;lng={$lang}&amp;nrm=iso" class="btn btn-secondary scielo__btn-with-icon--only"><xsl:attribute name="title"><xsl:call-template name="ISSUES_UI_TEXT"><xsl:with-param name="key">previous_issue</xsl:with-param></xsl:call-template></xsl:attribute><span class="material-icons-outlined">&#8249;</span></a>
								</xsl:when>
								<xsl:otherwise><a href="#" class="btn btn-secondary scielo__btn-with-icon--only disabled"><xsl:attribute name="title"><xsl:call-template name="ISSUES_UI_TEXT"><xsl:with-param name="key">previous_issue</xsl:with-param></xsl:call-template></xsl:attribute><span class="material-icons-outlined">&#8249;</span></a></xsl:otherwise>
							</xsl:choose>
							<xsl:choose>
								<xsl:when test="//NEXT/@PID">
									<a href="/scielo.php?script=sci_issuetoc&amp;pid={//NEXT/@PID}&amp;lng={$lang}&amp;nrm=iso" class="btn btn-secondary scielo__btn-with-icon--only"><xsl:attribute name="title"><xsl:call-template name="ISSUES_UI_TEXT"><xsl:with-param name="key">next_issue</xsl:with-param></xsl:call-template></xsl:attribute><span class="material-icons-outlined">&#8250;</span></a>
								</xsl:when>
								<xsl:otherwise><a href="#" class="btn btn-secondary scielo__btn-with-icon--only disabled"><xsl:attribute name="title"><xsl:call-template name="ISSUES_UI_TEXT"><xsl:with-param name="key">next_issue</xsl:with-param></xsl:call-template></xsl:attribute><span class="material-icons-outlined">&#8250;</span></a></xsl:otherwise>
							</xsl:choose>
							<xsl:if test="//CONTROLINFO/ISSUES/CURRENT/@PID">
								<a href="/scielo.php?script=sci_issuetoc&amp;pid={//CONTROLINFO/ISSUES/CURRENT/@PID}&amp;lng={$lang}&amp;nrm=iso" class="btn btn-secondary"><xsl:call-template name="ISSUES_UI_TEXT"><xsl:with-param name="key">current_issue</xsl:with-param></xsl:call-template></a>
							</xsl:if>
						</div>
					</div>
				</div>
			</div>
		</section>

		<section class="d-none d-md-flex breadcrumb mt-3 mb-5 serial-breadcrumb">
			<div class="container">
				<div class="serial-breadcrumb-inner">
					<ol class="breadcrumb mb-0 ps-0">
						<li class="breadcrumb-item"><a href="/scielo.php?lng={$lang}">
							<svg class="serial-home-icon serial-home-icon-breadcrumb" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
								<path d="M3 11.5L12 4l9 7.5"/>
								<path d="M5.5 10.5V20h5v-6h3v6h5v-9.5"/>
							</svg>
						</a></li>
						<li class="breadcrumb-item"><a href="/scielo.php?script=sci_alphabetic&amp;lng={$lang}&amp;nrm=iso"><xsl:call-template name="ISSUES_UI_TEXT"><xsl:with-param name="key">journals</xsl:with-param></xsl:call-template></a></li>
						<li class="breadcrumb-item"><xsl:value-of select="/SERIAL/TITLEGROUP/TITLE" disable-output-escaping="yes"/></li>
					</ol>
					<a class="btn btn-sm btn-secondary scielo__btn-with-icon--only serial-share-btn" href="mailto:?subject={/SERIAL/TITLEGROUP/TITLE}&amp;body=http://{//CONTROLINFO/SCIELO_INFO/SERVER}/scielo.php?script=sci_issues%26pid={/SERIAL/ISSN_AS_ID}%26lng={$lang}%26nrm=iso">
						<xsl:attribute name="aria-label"><xsl:call-template name="ISSUES_UI_TEXT"><xsl:with-param name="key">share</xsl:with-param></xsl:call-template></xsl:attribute>
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
			</div>
		</section>
	</xsl:template>
	<xsl:variable name="test_vol">
		<xsl:apply-templates select="//YEARISSUE/VOLISSUE" mode="validation"/>
	</xsl:variable>
	<xsl:template match="AVAILISSUES">
		<div class="issueList" id="issueList">
			<h2 class="scielo__text-title--4">
				<xsl:call-template name="ISSUES_UI_TEXT"><xsl:with-param name="key">all_issues</xsl:with-param></xsl:call-template>
				<a name="top"></a>
			</h2>
			<table class="table table-hover mb-5 issues-scielo-table">
				<caption class="visually-hidden">
					<xsl:call-template name="ISSUES_UI_TEXT"><xsl:with-param name="key">all_issues</xsl:with-param></xsl:call-template>
				</caption>
				<thead>
					<tr>
						<th class="col-1">
							<xsl:value-of select="$translations/xslid[@id='sci_issues']/text[@find='year']"/>
						</th>
						<th class="col-1 table-active">
							<xsl:call-template name="ISSUES_UI_TEXT"><xsl:with-param name="key">volume</xsl:with-param></xsl:call-template>
						</th>
						<th class="col-10 left">
							<xsl:value-of select="$translations/xslid[@id='sci_issues']/text[@find='number']"/>
						</th>
					</tr>
				</thead>
				<tbody>
					<xsl:apply-templates select="YEARISSUE">
						<xsl:sort select="@YEAR" order="descending" data-type="number"/>
					</xsl:apply-templates>
				</tbody>
			</table>
		</div>
	</xsl:template>
	<xsl:template match="YEARISSUE">
	</xsl:template>
	<xsl:template match="YEARISSUE[VOLISSUE/ISSUE[@SEQ]]">
		<xsl:apply-templates select="VOLISSUE[ISSUE[@SEQ]]">
			<xsl:sort select="@VOL" order="descending" data-type="number"/>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="VOLISSUE">
		<xsl:if test="ISSUE[@SEQ]">
			<tr>
				<td>
					<xsl:value-of select="../@YEAR"/>
				</td>
				<xsl:variable name="only_volume_count" select="count(ISSUE[not(@NUM) and not(@SUPPL)])"/>
				<th class="table-active">
					<xsl:choose>
						<xsl:when test="@VOL != '' ">
							<xsl:choose>
								<xsl:when test="$only_volume_count=0">
									<xsl:value-of select="@VOL"/>
								</xsl:when>
								<xsl:otherwise>
									<a>
										<xsl:call-template name="AddScieloLink">
											<xsl:with-param name="seq" select="ISSUE[not(@NUM) and not(@SUPPL)]/@SEQ"/>
											<xsl:with-param name="script">sci_issuetoc</xsl:with-param>
										</xsl:call-template>
										<xsl:value-of select="@VOL"/>
									</a>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>&#160;</xsl:otherwise>
					</xsl:choose>
				</th>
				<td class="left">
					<xsl:choose>
						<xsl:when test="$PRESENTATION_SORTED_BY_PUBDATE='1'">
							<xsl:apply-templates select="ISSUE[@NUM and @NUM!='AHEAD' and @NUM!='REVIEW' and not(@SUPPL) and @NUM!='SPE']">
								<xsl:sort select="@PUBDATE" data-type="text" order="ascending"/>
							</xsl:apply-templates>
							<xsl:apply-templates select="ISSUE[not(@NUM) or @SUPPL or @NUM='SPE']">
								<xsl:sort select="@PUBDATE" data-type="text" order="ascending"/>
							</xsl:apply-templates>
							<xsl:apply-templates select="ISSUE[@NUM='AHEAD']"/>
							<xsl:apply-templates select="ISSUE[@NUM='REVIEW']"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="ISSUE[@SEQ and (@NUM or @SUPPL)]"/>
							<xsl:apply-templates select="ISSUE[@SEQ and not(@NUM) and not(@SUPPL)]" mode="article-count"/>
						</xsl:otherwise>
					</xsl:choose>
				</td>
			</tr>
		</xsl:if>
	</xsl:template>
	<xsl:template match="ISSUE" mode="article-count">
		<a class="btn issue-article-count" data-issue-pid="{@SEQ}" data-lang="{normalize-space(//CONTROLINFO/LANGUAGE)}">
			<xsl:call-template name="AddScieloLink">
				<xsl:with-param name="seq" select="@SEQ"/>
				<xsl:with-param name="script">sci_issuetoc</xsl:with-param>
			</xsl:call-template>
			<xsl:call-template name="ISSUES_UI_TEXT"><xsl:with-param name="key">articles</xsl:with-param></xsl:call-template>
		</a>
	</xsl:template>
	<xsl:template match="ISSUE">
		<a class="btn">
			<xsl:call-template name="AddScieloLink">
				<xsl:with-param name="seq" select="@SEQ"/>
				<xsl:with-param name="script">sci_issuetoc</xsl:with-param>
			</xsl:call-template>
			<xsl:call-template name="GetNumber">
				<xsl:with-param name="num" select="@NUM"/>
				<xsl:with-param name="lang" select="//CONTROLINFO/LANGUAGE"/>
			</xsl:call-template>
			<xsl:call-template name="GetSuppl">
				<xsl:with-param name="num" select="@NUM"/>
				<xsl:with-param name="suppl" select="@SUPPL"/>
				<xsl:with-param name="lang" select="//CONTROLINFO/LANGUAGE"/>
			</xsl:call-template>
			<xsl:if test="@NUM='beforeprint'">
				<xsl:value-of select="$translations/xslid[@id='sci_issues']/text[@find='not_printed']"/>
			</xsl:if>
			<xsl:if test="@NUM='AHEAD'">
				<xsl:value-of select="$translations/xslid[@id='sci_issues']/text[@find='ahead_of_print']"/>
			</xsl:if>
			<xsl:if test="@NUM='REVIEW'">
				<xsl:value-of select="$translations/xslid[@id='sci_artref']/text[@find='provisional']"/>
			</xsl:if>
		</a>
	</xsl:template>
	<!-- Adds a number of blank cells after the last cell on the table
        Parameter: ncells - Number of cells to add -->
	<xsl:template name="AddBlankCells">
		<xsl:param name="ncells"/>
		<xsl:if test="$ncells&gt;0">
			<TD align="middle" width="{$spaceIssue}" bgColor="#f5f5eb" height="35">&#160;</TD>
			<xsl:call-template name="AddBlankCells">
				<xsl:with-param name="ncells" select="$ncells - 1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template match="VOLISSUE" mode="validation">
		<xsl:if test="@VOL != ''">
			<xsl:text>FILLED</xsl:text>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
