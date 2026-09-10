<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:mml="http://www.w3.org/1998/Math/MathML">
	<xsl:include href="sci_navegation.xsl"/>
	<xsl:include href="sci_toolbox.xsl"/>
	<xsl:variable name="languages" select="document('../xml/pt/language.xml')"/><xsl:variable name="LANGUAGE" select="//LANGUAGE"/>
	<xsl:variable name="SCIELO_REGIONAL_DOMAIN" select="//SCIELO_REGIONAL_DOMAIN"/>
	<xsl:variable name="show_toolbox" select="//toolbox"/>
	<xsl:template match="/">
		<xsl:apply-templates select="//SERIAL"/>
	</xsl:template>
		
	<xsl:template match="SERIAL">
		<xsl:if test=".//mml:math">
			<xsl:processing-instruction name="xml-stylesheet"> type="text/xsl" href="/xsl/mathml.xsl"</xsl:processing-instruction>
		</xsl:if>
			<html xmlns="http://www.w3.org/1999/xhtml" lang="{normalize-space(CONTROLINFO/LANGUAGE)}" >
			<head>
				<title>
					<xsl:value-of select="ARTICLE/citation_title" />
				</title>
				<meta http-equiv="Pragma" content="no-cache"/>
				<meta http-equiv="Expires" content="Mon, 06 Jan 1990 00:00:01 GMT"/>
				<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/> 
                <!--Meta Google Scholar-->
                <meta name="citation_journal_title" content="{TITLEGROUP/TITLE}"/>
                <meta name="citation_publisher" content="{normalize-space(substring-after(COPYRIGHT,'-'))}"/>
                <meta name="citation_title" content="{ARTICLE/citation_title}"/>
                <meta name="citation_language" content="{ARTICLE/citation_title/@lang}"/>                                
                <meta name="citation_date" content="{concat(ARTICLE/ISSUEINFO/@MONTH,'/',ARTICLE/ISSUEINFO/@YEAR)}"/>
                <meta name="citation_volume" content="{ARTICLE/ISSUEINFO/@VOL}"/>
                <meta name="citation_issue" content="{ARTICLE/ISSUEINFO/@NUM}"/>
                <meta name="citation_issn" content="{ISSN}"/>
                <meta name="citation_doi" content="{ARTICLE/@DOI}"/>
                <meta name="citation_abstract_html_url" content="{concat('http://',CONTROLINFO/SCIELO_INFO/SERVER, '/scielo.php?script=sci_abstract&amp;pid=', ARTICLE/@PID, '&amp;lng=', CONTROLINFO/LANGUAGE , '&amp;nrm=iso&amp;tlng=', ARTICLE/@TEXT_LANG)}"/>
                <meta name="citation_fulltext_html_url" content="{concat('http://',CONTROLINFO/SCIELO_INFO/SERVER, '/scielo.php?script=sci_arttext&amp;pid=', ARTICLE/@PID, '&amp;lng=', CONTROLINFO/LANGUAGE , '&amp;nrm=iso&amp;tlng=', ARTICLE/@TEXT_LANG)}"/>
                <xsl:apply-templates select=".//AUTHORS//AUTHOR" mode="AUTHORS_META"/>
                <meta name="citation_firstpage" content="{ARTICLE/@FPAGE}"/>
                <meta name="citation_lastpage" content="{ARTICLE/@LPAGE}"/>
                <meta name="citation_id" content="{ARTICLE/@DOI}"/>
				<xsl:apply-templates select="ARTICLE/LANGUAGES/PDF_LANGS/LANG" mode="meta_citation_pdf_url">
					<xsl:with-param name="orig_lang" select="ARTICLE/@TEXT_LANG" />
				</xsl:apply-templates>
				<link rel="stylesheet" type="text/css" href="/css/screen/general.css"/>
				<link rel="stylesheet" type="text/css" href="/design-system/1.0.0/css/bootstrap.css"/>
				<link rel="stylesheet" type="text/css" href="/design-system/1.0.0/css/article.css"/>
				<link rel="stylesheet" type="text/css" href="/css/scielo-ds-bridge.css?v=abstract-20260615-1"/>
				<link rel="stylesheet" type="text/css" href="/css/screen/layout.css"/>
				<link rel="stylesheet" type="text/css" href="/css/screen/styles.css"/>
				<link rel="stylesheet" type="text/css" href="/xsl/pmc/v3.0/xml.css"/>
				<script language="javascript" src="applications/scielo-org/js/jquery-1.4.2.min.js"/>
				<script language="javascript" src="applications/scielo-org/js/toolbox.js"/>
	            <xsl:if test="//show_readcube_epdf = '1'">
	                <script src="http://content.readcube.com/scielo/epdf_linker.js" type="text/javascript" async="true"></script>
	            </xsl:if>
				<xsl:call-template name="EDUCA_GOOGLE_TAG"/>
			</head>
			<body class="arttext-page">
				<xsl:call-template name="ACCESS_SKIP_LINK"/>
				<xsl:call-template name="ABSTRACT_MODERN_HEADER"/>
				<div class="container">
					<div class="top">
						<div id="issues"/>
						<xsl:call-template name="NAVBAR">
							<xsl:with-param name="bar1">articles</xsl:with-param>
							<xsl:with-param name="bar2"></xsl:with-param>
							<xsl:with-param name="compact_nav">1</xsl:with-param>
							<xsl:with-param name="compact_variant">arttext</xsl:with-param>
							<xsl:with-param name="home">1</xsl:with-param>
							<xsl:with-param name="alpha">0</xsl:with-param>
							<xsl:with-param name="show_lang_switch">1</xsl:with-param>
							<xsl:with-param name="scope" select="TITLEGROUP/SIGLUM"/>
						</xsl:call-template>
					</div>
					<xsl:call-template name="ABSTRACT_BREADCRUMB"/>
					<main id="main-content" tabindex="-1" class="content">
						<xsl:call-template name="ABSTRACT_READING_NAV"/>
						<article class="arttext-article-card abstract-article-card">
							<xsl:call-template name="ABSTRACT_READING_TOOLBAR"/>
							<xsl:call-template name="ABSTRACT_CITATION_LINE"/>
							<h1 class="visually-hidden">
								<xsl:value-of select="ARTICLE/citation_title" disable-output-escaping="yes"/>
							</h1>
							<div class="issues-journal-logo">
								<img src="{//CONTROLINFO/SCIELO_INFO/PATH_SERIMG}{//TITLEGROUP/SIGLUM}/glogo.gif" alt="{//TITLEGROUP/TITLE}"/>
							</div>
							<xsl:if test="$show_toolbox = 1">
								<xsl:call-template name="tool_box"/>
							</xsl:if>
							<h2>
								<xsl:value-of select="TITLEGROUP/TITLE" disable-output-escaping="yes"/>
							</h2>
							<h2 id="printISSN">
								<xsl:apply-templates select="ISSUE_ISSN">
									<xsl:with-param name="LANG" select="normalize-space(CONTROLINFO/LANGUAGE)"/>
								</xsl:apply-templates>
							</h2>
							<div class="index,{ARTICLE/@TEXTLANG}">
								<xsl:apply-templates select="ARTICLE">
									<xsl:with-param name="NORM" select="normalize-space(CONTROLINFO/STANDARD)"/>
									<xsl:with-param name="LANG" select="normalize-space(CONTROLINFO/LANGUAGE)"/>
								</xsl:apply-templates>
							</div>
						</article>
						<div align="left"/>
						<!--/div>
						<div class="contentRight"-->
						<!--/div-->
						<div class="spacer">&#160;</div>
					</main>
					<xsl:apply-templates select="." mode="footer-journal"/>
				</div>
				<xsl:call-template name="ABSTRACT_UTILS"/>
				<script type="text/javascript" src="/js/educa-accessibility.js?v=20260615-details-1"></script>
				<xsl:call-template name="ABSTRACT_READING_SCRIPT"/>
			</body>
		</html>
	</xsl:template>

	<xsl:template match="LANG" mode="meta_citation_pdf_url">
		<xsl:param name="orig_lang" />
		<xsl:variable name="lang" select="." />
		<meta>
			<xsl:attribute name="name">citation_pdf_url</xsl:attribute>
			<xsl:attribute name="language"><xsl:value-of select="$orig_lang" /></xsl:attribute>
			<xsl:if test="$orig_lang = $lang">
				<xsl:attribute name="default">true</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="content"><xsl:value-of select="concat('http://',//CONTROLINFO/SCIELO_INFO/SERVER,'/pdf/',@TRANSLATION)" /></xsl:attribute>
		</meta>
	</xsl:template>

	<xsl:template match="ARTICLE">
		<xsl:param name="NORM"/>
		<xsl:param name="LANG"/>
		<h4 id="article-abstract">
			<xsl:call-template name="ABSTR-TR">
				<xsl:with-param name="LANG" select="$LANG"/>
			</xsl:call-template>
		</h4>
		<p>
			<xsl:call-template name="PrintAbstractHeaderInformation">
				<xsl:with-param name="FORMAT" select="'short'"/>
				<xsl:with-param name="NORM" select="'iso-e'"/>
				<xsl:with-param name="LANG" select="$LANG"/>
				<xsl:with-param name="AUTHLINK">1</xsl:with-param>
			<xsl:with-param name="reviewType"><xsl:if test="@hcomment!='1' or not(@hcomment)">provisional</xsl:if></xsl:with-param>
			</xsl:call-template>
		</p>
		<p>
			<xsl:variable name="lang" select="ABSTRACT/@xml:lang"/>
			<xsl:if test="$languages//language[@id=$lang]/@view='r2l'">
				<xsl:attribute name="class">r2l</xsl:attribute>
			</xsl:if>
			
			<xsl:apply-templates select="ABSTRACT"/>
		</p>
		<xsl:apply-templates select="KEYWORDS">
			<xsl:with-param name="LANG" select="$LANG"/>
		</xsl:apply-templates>
		<p>
			<!--xsl:call-template name="CREATE_ARTICLE_LINK">
			<xsl:with-param name="TYPE">full</xsl:with-param>
			<xsl:with-param name="INTLANG" select="$LANG"/>
			<xsl:with-param name="TXTLANG" select="@TEXT_LANG"/>
			<xsl:with-param name="PID" select="//CONTROLINFO/PAGE_PID"/>
		</xsl:call-template>
		<xsl:if test="@PDF='1'">
			<xsl:call-template name="CREATE_ARTICLE_LINK">
				<xsl:with-param name="TYPE">pdf</xsl:with-param>
				<xsl:with-param name="INTLANG" select="$LANG"/>
				<xsl:with-param name="TXTLANG" select="@TEXT_LANG"/>
				<xsl:with-param name="PID" select="//CONTROLINFO/PAGE_PID"/>
			</xsl:call-template>
		</xsl:if-->
			<xsl:apply-templates select="LANGUAGES">
				<xsl:with-param name="LANG" select="$LANG"/>
				<xsl:with-param name="PID" select="//CONTROLINFO/PAGE_PID"/>
			</xsl:apply-templates>
		</p>
		
	</xsl:template>
	<xsl:template match="ABSTRACT">
		<xsl:choose>
			<xsl:when test="*">
				<xsl:apply-templates select="*|text()"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="." disable-output-escaping="yes"/>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	<!--xsl:template match="ABSTRACT/*">
		<xsl:copy-of select="."/>
	</xsl:template-->
	<xsl:template match="ABSTRACT/text()">
		<xsl:value-of select="."/>
	</xsl:template>
	<xsl:template match="ABSTRACT//*">
		<xsl:apply-templates select="*|text()"/>
	</xsl:template>
	<xsl:template match="ABSTRACT//p">
		<p>
			<xsl:apply-templates select="*|text()"/>
		</p>
	</xsl:template>
	<xsl:template match="ABSTRACT/title">
	</xsl:template>
	<xsl:template match="ABSTRACT/sec/title">
		<p class="subsec"><xsl:apply-templates select="*|text()"/></p>
	</xsl:template>
	<xsl:template match="ABSTRACT/sec"><div>
		<xsl:apply-templates select="*|text()"/></div>
	</xsl:template>
	<xsl:template name="ABSTR-TR">
        <xsl:value-of select="$translations/xslid[@id='sci_abstract']/text[@find='abstract']"/>
	</xsl:template>
	<xsl:template match="KEYWORDS">
		<xsl:param name="LANG"/>
		<p id="article-keywords">
			<strong>
                <xsl:value-of select="$translations/xslid[@id='sci_abstract']/text[@find='keywords']"/>
		:
		</strong>
			<xsl:apply-templates select="KEYWORD"/>.
	</p>
	</xsl:template>
	<xsl:template match="KEYWORD[position()=1]">
		<xsl:value-of select="KEY" disable-output-escaping="yes"/>
		<xsl:if test="SUBKEY"> [<xsl:value-of select="SUBKEY" disable-output-escaping="yes"/>]</xsl:if>
	</xsl:template>
	<xsl:template match="KEYWORD[position()>1]">; <xsl:value-of select="KEY" disable-output-escaping="yes"/>
		<xsl:if test="SUBKEY"> [<xsl:value-of select="SUBKEY" disable-output-escaping="yes"/>]</xsl:if>
	</xsl:template>
	<xsl:template match="ABSTRACT//mml:math| ABSTRACT//math | ABSTRACT//mml:*">
		<xsl:copy-of select="."/>
	</xsl:template>

	<xsl:template name="ABSTRACT_MODERN_HEADER">
		<xsl:variable name="lang" select="normalize-space(//CONTROLINFO/LANGUAGE)"/>
		<xsl:variable name="pid" select="//ARTICLE/@PID"/>
		<xsl:variable name="tlng" select="//ARTICLE/@TEXT_LANG"/>
		<header class="serial-modern-header arttext-modern-header">
			<details class="home-main-menu serial-modern-menu">
				<summary class="serial-modern-menu-btn">&#9776; Menu</summary>
				<ul class="home-main-dropdown">
					<li><a href="/search_mvp.php?lang={$lang}">Pesquisa</a></li>
					<li><a href="/scielo.php?script=sci_alphabetic&amp;lng={$lang}&amp;nrm=iso">Lista de peri&#243;dicos</a></li>
					<li><a href="https://educa.fcc.org.br/metricas/?lang=pt">Métricas e Indicadores</a></li>
					<li><a href="/about/?lang={$lang}">Sobre o Educ@</a></li>
					<li><a href="/equipe/equipe_p.htm">Equipe Educ@</a></li>
				</ul>
			</details>
			<a class="serial-modern-brand" href="/scielo.php?lng={$lang}" aria-label="Educ@">
				<img src="/img/pt/scielobre.gif" alt="Educ@"/>
			</a>
			<details class="serials-lang-menu serial-modern-lang arttext-lang-menu">
				<summary class="serials-ghost-btn serials-lang-btn" aria-label="Language selector">
					&#127760;
					<xsl:text> </xsl:text>
					<xsl:choose>
						<xsl:when test="$lang='en'">English</xsl:when>
						<xsl:when test="$lang='es'">Espa&#241;ol</xsl:when>
						<xsl:otherwise>Portugu&#234;s</xsl:otherwise>
					</xsl:choose>
					<xsl:text> </xsl:text>&#9662;
				</summary>
				<ul class="serials-lang-dropdown">
					<li><a href="/scielo.php?script=sci_abstract&amp;pid={$pid}&amp;lng=pt&amp;nrm=iso&amp;tlng=pt">Portugu&#234;s</a></li>
					<li><a href="/scielo.php?script=sci_abstract&amp;pid={$pid}&amp;lng=en&amp;nrm=iso&amp;tlng=en">English</a></li>
					<li><a href="/scielo.php?script=sci_abstract&amp;pid={$pid}&amp;lng=es&amp;nrm=iso&amp;tlng=es">Espa&#241;ol</a></li>
				</ul>
			</details>
		</header>
	</xsl:template>

	<xsl:template name="ABSTRACT_BREADCRUMB">
		<xsl:variable name="lang" select="normalize-space(//CONTROLINFO/LANGUAGE)"/>
		<xsl:variable name="journalPid" select="//ISSN_AS_ID"/>
		<xsl:variable name="issuePid" select="//CURRENTISSUE/@PID"/>
		<xsl:variable name="articlePid" select="//ARTICLE/@PID"/>
		<xsl:variable name="tlng" select="//ARTICLE/@TEXT_LANG"/>
		<section class="d-none d-md-flex breadcrumb mt-3 mb-5 serial-breadcrumb arttext-breadcrumb">
			<div class="container">
				<div class="serial-breadcrumb-inner">
					<ol class="breadcrumb mb-0 ps-0">
						<li class="breadcrumb-item"><a href="/scielo.php?lng={$lang}">
							<svg class="serial-home-icon serial-home-icon-breadcrumb" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
								<path d="M3 11.5L12 4l9 7.5"/>
								<path d="M5.5 10.5V20h5v-6h3v6h5v-9.5"/>
							</svg>
						</a></li>
						<li class="breadcrumb-item"><a href="/scielo.php?script=sci_alphabetic&amp;lng={$lang}&amp;nrm=iso">Peri&#243;dicos</a></li>
						<li class="breadcrumb-item"><a href="/scielo.php?script=sci_serial&amp;pid={$journalPid}&amp;lng={$lang}&amp;nrm=iso"><xsl:value-of select="//TITLEGROUP/TITLE" disable-output-escaping="yes"/></a></li>
						<xsl:if test="$issuePid">
							<li class="breadcrumb-item"><a href="/scielo.php?script=sci_issuetoc&amp;pid={$issuePid}&amp;lng={$lang}&amp;nrm=iso">Sum&#225;rio</a></li>
						</xsl:if>
						<li class="breadcrumb-item">Resumo</li>
					</ol>
					<a class="btn btn-sm btn-secondary scielo__btn-with-icon--only serial-share-btn" href="mailto:?subject={//ARTICLE/citation_title}&amp;body=http://{//CONTROLINFO/SCIELO_INFO/SERVER}/scielo.php?script=sci_abstract%26pid={$articlePid}%26lng={$lang}%26nrm=iso%26tlng={$tlng}" aria-label="Compartilhar">
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

	<xsl:template name="ABSTRACT_READING_NAV">
		<aside class="arttext-reading-nav" aria-label="Sum&#225;rio do artigo">
			<nav>
				<strong>Sum&#225;rio</strong>
				<a href="#article-abstract" class="is-active">Resumo</a>
				<a href="#article-keywords">Palavras-chave</a>
			</nav>
		</aside>
	</xsl:template>

	<xsl:template name="ABSTRACT_READING_TOOLBAR">
		<xsl:variable name="lang" select="normalize-space(//CONTROLINFO/LANGUAGE)"/>
		<xsl:variable name="tlng" select="//ARTICLE/@TEXT_LANG"/>
		<xsl:variable name="issuePid" select="//CURRENTISSUE/@PID"/>
		<div class="arttext-reading-toolbar" aria-label="Ferramentas de leitura">
			<div class="arttext-reading-navlinks">
				<a href="/scielo.php?script=sci_issuetoc&amp;pid={$issuePid}&amp;lng={$lang}&amp;nrm=iso" class="arttext-toolbar-home">
					<svg viewBox="0 0 24 24" aria-hidden="true" focusable="false">
						<path d="M3 11.5L12 4l9 7.5"/>
						<path d="M5.5 10.5V20h5v-6h3v6h5v-9.5"/>
					</svg>
					<span>Sum&#225;rio</span>
				</a>
				<xsl:choose>
					<xsl:when test="//PREVIOUS/@PID">
						<a href="/scielo.php?script=sci_abstract&amp;pid={//PREVIOUS/@PID}&amp;lng={$lang}&amp;nrm=iso&amp;tlng={$tlng}">&#8249; Anterior</a>
					</xsl:when>
					<xsl:otherwise><span class="is-disabled">&#8249; Anterior</span></xsl:otherwise>
				</xsl:choose>
				<span class="is-current">Atual</span>
				<xsl:choose>
					<xsl:when test="//NEXT/@PID">
						<a href="/scielo.php?script=sci_abstract&amp;pid={//NEXT/@PID}&amp;lng={$lang}&amp;nrm=iso&amp;tlng={$tlng}">Seguinte &#8250;</a>
					</xsl:when>
					<xsl:otherwise><span class="is-disabled">Seguinte &#8250;</span></xsl:otherwise>
				</xsl:choose>
			</div>
			<div class="arttext-reading-actions">
				<details class="arttext-tool-menu">
					<summary>Resumo (<xsl:value-of select="translate($tlng, 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>)</summary>
					<ul>
						<li><a href="/scielo.php?script=sci_abstract&amp;pid={//ARTICLE/@PID}&amp;lng={$lang}&amp;nrm=iso&amp;tlng=pt">PT</a></li>
						<li><a href="/scielo.php?script=sci_abstract&amp;pid={//ARTICLE/@PID}&amp;lng={$lang}&amp;nrm=iso&amp;tlng=en">EN</a></li>
						<li><a href="/scielo.php?script=sci_abstract&amp;pid={//ARTICLE/@PID}&amp;lng={$lang}&amp;nrm=iso&amp;tlng=es">ES</a></li>
					</ul>
				</details>
				<a class="arttext-copy-citation" href="/scielo.php?script=sci_arttext&amp;pid={//ARTICLE/@PID}&amp;lng={$lang}&amp;nrm=iso&amp;tlng={$tlng}">Texto completo</a>
				<details class="arttext-tool-menu">
					<summary>PDF</summary>
					<ul>
						<xsl:choose>
							<xsl:when test="//ARTICLE/LANGUAGES/PDF_LANGS/LANG">
								<xsl:for-each select="//ARTICLE/LANGUAGES/PDF_LANGS/LANG">
									<li><a href="/pdf/{@TRANSLATION}"><xsl:value-of select="translate(., 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/></a></li>
								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise><li><span>Indispon&#237;vel</span></li></xsl:otherwise>
						</xsl:choose>
					</ul>
				</details>
			</div>
		</div>
	</xsl:template>

	<xsl:template name="ABSTRACT_CITATION_LINE">
		<div class="arttext-citation-line">
			<span class="arttext-citation-text">
				Resumo
				<xsl:text> &#8226; </xsl:text>
				<xsl:value-of select="//TITLEGROUP/SHORTTITLE" disable-output-escaping="yes"/>
				<xsl:if test="//ARTICLE/ISSUEINFO/@VOL">
					<xsl:text> </xsl:text><xsl:value-of select="//ARTICLE/ISSUEINFO/@VOL"/>
				</xsl:if>
				<xsl:if test="//ARTICLE/ISSUEINFO/@NUM">
					<xsl:text>(</xsl:text><xsl:value-of select="//ARTICLE/ISSUEINFO/@NUM"/><xsl:text>)</xsl:text>
				</xsl:if>
				<xsl:if test="//ARTICLE/ISSUEINFO/@YEAR">
					<xsl:text> &#8226; </xsl:text><xsl:value-of select="//ARTICLE/ISSUEINFO/@YEAR"/>
				</xsl:if>
				<xsl:if test="//ARTICLE/@DOI">
					<xsl:text> &#8226; DOI: </xsl:text>
					<a target="_blank">
						<xsl:attribute name="href">https://doi.org/<xsl:value-of select="//ARTICLE/@DOI"/></xsl:attribute>
						<xsl:text>https://doi.org/</xsl:text><xsl:value-of select="//ARTICLE/@DOI"/>
					</a>
				</xsl:if>
			</span>
			<button type="button" class="arttext-copy-citation" data-copy="https://doi.org/{//ARTICLE/@DOI}" aria-label="Copiar DOI">
				<svg viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="M10 13a5 5 0 0 0 7.1 0l2-2a5 5 0 0 0-7.1-7.1l-1.1 1.1"/><path d="M14 11a5 5 0 0 0-7.1 0l-2 2A5 5 0 0 0 12 20.1l1.1-1.1"/></svg>
				<span>copiar</span>
			</button>
		</div>
	</xsl:template>

	<xsl:template name="ABSTRACT_UTILS">
		<div class="serial-template-utils arttext-template-utils">
			<a href="mailto:educ@fcc.org.br?subject=Reportar%20erro" class="serial-template-report">Reportar erro</a>
			<a href="#main-content" class="serial-template-accessibility">Acessibilidade</a>
		</div>
	</xsl:template>

	<xsl:template name="ABSTRACT_READING_SCRIPT">
		<script type="text/javascript">
		(function () {
			var article = document.querySelector('.abstract-article-card');
			var nav = document.querySelector('.arttext-reading-nav nav');
			if (!article || !nav) { return; }

			var copy = article.querySelector('.arttext-copy-citation[data-copy]');
			if (copy) {
				copy.addEventListener('click', function () {
					var value = copy.getAttribute('data-copy') || '';
					if (!value) { value = article.querySelector('.arttext-citation-text').textContent; }
					if (navigator.clipboard &amp;&amp; navigator.clipboard.writeText) {
						navigator.clipboard.writeText(value);
					}
					copy.textContent = 'Copiado';
					setTimeout(function () { copy.textContent = 'copiar'; }, 1600);
				});
			}

			var links = Array.prototype.slice.call(nav.querySelectorAll('a[href^="#"]'));
			var targets = links.map(function (link) {
				var id = link.getAttribute('href').slice(1);
				return document.getElementById(id);
			});
			function setActive() {
				var active = 0;
				targets.forEach(function (target, index) {
					if (target &amp;&amp; target.getBoundingClientRect().top &lt; 150) { active = index; }
				});
				links.forEach(function (link, index) {
					link.classList.toggle('is-active', index === active);
				});
			}
			window.addEventListener('scroll', setActive, { passive: true });
			setActive();
		}());
		</script>
	</xsl:template>
	
</xsl:stylesheet>
