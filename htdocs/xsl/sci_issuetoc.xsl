<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" omit-xml-declaration="yes" indent="no"/>

	<xsl:include href="sci_navegation.xsl"/>
	
	<xsl:variable name="analytics_code" select="//ANALYTICS_CODE"/>
	<xsl:variable name="num" select="//ISSUE/@NUM"/>
	<xsl:variable name="issuetoc_controlInfo" select="//CONTROLINFO"/>
	<xsl:variable name="pref">
		<xsl:choose>
			<xsl:when test="//CONTROLINFO/LANGUAGE='en' ">i</xsl:when>
			<xsl:when test="//CONTROLINFO/LANGUAGE='es' ">e</xsl:when>
			<xsl:when test="//CONTROLINFO/LANGUAGE='pt' ">p</xsl:when>
		</xsl:choose>
	</xsl:variable>
	<xsl:template name="ISSUETOC_UI_TEXT">
		<xsl:param name="key"/>
		<xsl:param name="lang" select="normalize-space(//CONTROLINFO/LANGUAGE)"/>
		<xsl:choose>
			<xsl:when test="$key='search'"><xsl:choose><xsl:when test="$lang='en'">Search</xsl:when><xsl:when test="$lang='es'">Búsqueda</xsl:when><xsl:otherwise>Pesquisa</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='journal_list'"><xsl:choose><xsl:when test="$lang='en'">Journal list</xsl:when><xsl:when test="$lang='es'">Lista de revistas</xsl:when><xsl:otherwise>Lista de periódicos</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='about_educa'"><xsl:choose><xsl:when test="$lang='en'">About Educ@</xsl:when><xsl:when test="$lang='es'">Acerca de Educ@</xsl:when><xsl:otherwise>Sobre o Educ@</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='team_educa'"><xsl:choose><xsl:when test="$lang='en'">Educ@ Team</xsl:when><xsl:when test="$lang='es'">Equipo Educ@</xsl:when><xsl:otherwise>Equipe Educ@</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='published_by'"><xsl:choose><xsl:when test="$lang='en'">Published by:</xsl:when><xsl:when test="$lang='es'">Publicación de:</xsl:when><xsl:otherwise>Publicação de:</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='area'"><xsl:choose><xsl:when test="$lang='en'">Area:</xsl:when><xsl:when test="$lang='es'">Área:</xsl:when><xsl:otherwise>Área:</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='print_issn'"><xsl:choose><xsl:when test="$lang='en'">Print version ISSN:</xsl:when><xsl:when test="$lang='es'">Versión impresa ISSN:</xsl:when><xsl:otherwise>Versão impressa ISSN:</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='online_issn'"><xsl:choose><xsl:when test="$lang='en'">Online version ISSN:</xsl:when><xsl:when test="$lang='es'">Versión en línea ISSN:</xsl:when><xsl:otherwise>Versão on-line ISSN:</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='submission'"><xsl:choose><xsl:when test="$lang='en'">Manuscript submission</xsl:when><xsl:when test="$lang='es'">Envío de manuscritos</xsl:when><xsl:otherwise>Submissão de manuscritos</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='journal_site'"><xsl:choose><xsl:when test="$lang='en'">Journal site</xsl:when><xsl:when test="$lang='es'">Sitio de la revista</xsl:when><xsl:otherwise>Site do periódico</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='about_journal'"><xsl:choose><xsl:when test="$lang='en'">About the journal</xsl:when><xsl:when test="$lang='es'">Acerca de la revista</xsl:when><xsl:otherwise>Sobre o periódico</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='editorial_policy'"><xsl:choose><xsl:when test="$lang='en'">Editorial policy</xsl:when><xsl:when test="$lang='es'">Política editorial</xsl:when><xsl:otherwise>Política editorial</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='editorial_board'"><xsl:choose><xsl:when test="$lang='en'">Editorial Board</xsl:when><xsl:when test="$lang='es'">Comité editorial</xsl:when><xsl:otherwise>Corpo Editorial</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='instructions'"><xsl:choose><xsl:when test="$lang='en'">Instructions to authors</xsl:when><xsl:when test="$lang='es'">Instrucciones a los autores</xsl:when><xsl:otherwise>Instruções aos autores</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='contact'"><xsl:choose><xsl:when test="$lang='en'">Contact</xsl:when><xsl:when test="$lang='es'">Contacto</xsl:when><xsl:otherwise>Contato</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='journal_home'"><xsl:choose><xsl:when test="$lang='en'">Journal home</xsl:when><xsl:when test="$lang='es'">Página inicial de la revista</xsl:when><xsl:otherwise>Home do periódico</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='all_issues'"><xsl:choose><xsl:when test="$lang='en'">All issues</xsl:when><xsl:when test="$lang='es'">Todos los números</xsl:when><xsl:otherwise>Todos os números</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='previous_issue'"><xsl:choose><xsl:when test="$lang='en'">Previous issue</xsl:when><xsl:when test="$lang='es'">Número anterior</xsl:when><xsl:otherwise>Número anterior</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='next_issue'"><xsl:choose><xsl:when test="$lang='en'">Next issue</xsl:when><xsl:when test="$lang='es'">Número siguiente</xsl:when><xsl:otherwise>Número seguinte</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='current_issue'"><xsl:choose><xsl:when test="$lang='en'">Current issue</xsl:when><xsl:when test="$lang='es'">Número actual</xsl:when><xsl:otherwise>Número atual</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='metrics'"><xsl:choose><xsl:when test="$lang='en'">Metrics</xsl:when><xsl:when test="$lang='es'">Métricas</xsl:when><xsl:otherwise>Métricas</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='tools'"><xsl:choose><xsl:when test="$lang='en'">Tools</xsl:when><xsl:when test="$lang='es'">Herramientas</xsl:when><xsl:otherwise>Ferramentas</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='journals'"><xsl:choose><xsl:when test="$lang='en'">Journals</xsl:when><xsl:when test="$lang='es'">Revistas</xsl:when><xsl:otherwise>Periódicos</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='share'"><xsl:choose><xsl:when test="$lang='en'">Share</xsl:when><xsl:when test="$lang='es'">Compartir</xsl:when><xsl:otherwise>Compartilhar</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='report_error'"><xsl:choose><xsl:when test="$lang='en'">Report error</xsl:when><xsl:when test="$lang='es'">Reportar error</xsl:when><xsl:otherwise>Reportar erro</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='accessibility'"><xsl:choose><xsl:when test="$lang='en'">Accessibility</xsl:when><xsl:when test="$lang='es'">Accesibilidad</xsl:when><xsl:otherwise>Acessibilidade</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='back_to_top'"><xsl:choose><xsl:when test="$lang='en'">Back to top</xsl:when><xsl:when test="$lang='es'">Volver arriba</xsl:when><xsl:otherwise>Voltar ao topo</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='summary'"><xsl:choose><xsl:when test="$lang='en'">Table of contents</xsl:when><xsl:when test="$lang='es'">Sumario</xsl:when><xsl:otherwise>Sumário</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='volume'"><xsl:choose><xsl:when test="$lang='en'">Volume</xsl:when><xsl:when test="$lang='es'">Volumen</xsl:when><xsl:otherwise>Volume</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='issue'"><xsl:choose><xsl:when test="$lang='en'">Issue</xsl:when><xsl:when test="$lang='es'">Número</xsl:when><xsl:otherwise>Número</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='published'"><xsl:choose><xsl:when test="$lang='en'">Published</xsl:when><xsl:when test="$lang='es'">Publicado</xsl:when><xsl:otherwise>Publicado</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='abstract'"><xsl:choose><xsl:when test="$lang='en'">Abstract</xsl:when><xsl:when test="$lang='es'">Resumen</xsl:when><xsl:otherwise>Resumo</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='text'"><xsl:choose><xsl:when test="$lang='en'">Text</xsl:when><xsl:when test="$lang='es'">Texto</xsl:when><xsl:otherwise>Texto</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:otherwise><xsl:value-of select="$key"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="SERIAL">
		<HTML lang="{normalize-space(//CONTROLINFO/LANGUAGE)}">
			<HEAD>
				<TITLE>
					<xsl:value-of select="//TITLEGROUP/SHORTTITLE" disable-output-escaping="yes"/> -
						<xsl:call-template name="GetStrip">
						<xsl:with-param name="vol" select="//ISSUE/@VOL"/>
						<xsl:with-param name="num" select="//ISSUE/@NUM"/>
						<xsl:with-param name="suppl" select="//ISSUE/@SUPPL"/>
						<xsl:with-param name="lang" select="//CONTROLINFO/LANGUAGE"/>
					</xsl:call-template>
				</TITLE>
				<LINK href="/css/scielo.css" type="text/css" rel="STYLESHEET"/>
				<link rel="stylesheet" type="text/css" href="/design-system/1.0.0/css/bootstrap.css"/>
				<link rel="stylesheet" type="text/css" href="/design-system/1.0.0/css/article.css"/>
				<link rel="stylesheet" type="text/css" href="/css/scielo-ds-bridge.css?v=issuetoc-20260614-8"/>
				<style type="text/css">
					#pagination{
					    font-size:8pt;
					    border-bottom:1px solid #808080;
					    padding:5px;
					    margin:20px 0;
					    align:justified;
					    width:80%;
					    left:20%
					}
					#xpagination{
					    padding:5px;
					    margin:20px 0;
					}
					#pagination a{
					    font-size:8pt;
					    margin:0 4px;
					    padding:0 2px;
					    font-color:#000;
					    text-decoration:none
					}
					#pageNav{
					    text-align:right;
					    position:absolute;
					    right:20%}
					#pageOf{
					    text-align:left;
					}</style>
				<style type="text/css">
					a{
					    text-decoration:none;
					}</style>
				<META http-equiv="Pragma" content="no-cache"/>
				<META HTTP-EQUIV="Expires" CONTENT="Mon, 06 Jan 1990 00:00:01 GMT"/>
				<meta name="viewport" content="width=device-width, initial-scale=1"/>
				<!-- link pro RSS aparecer automaticamente no Browser -->
				<xsl:call-template name="AddRssHeaderLink">
					<xsl:with-param name="pid" select="//CURRENT/@PID"/>
					<xsl:with-param name="lang" select="//LANGUAGE"/>
					<xsl:with-param name="server" select="CONTROLINFO/SCIELO_INFO/SERVER"/>
					<xsl:with-param name="script">rss.php</xsl:with-param>
				</xsl:call-template>
	            <xsl:if test="//show_readcube_epdf = '1'">
	                <script src="http://content.readcube.com/scielo/epdf_linker.js" type="text/javascript" async="true"></script>
	            </xsl:if>
			</HEAD>
			<BODY class="issuetoc-page issues-page" vLink="#800080" bgColor="#ffffff">
				<xsl:call-template name="ACCESS_SKIP_LINK"/>
				<header class="serial-modern-header" id="top">
					<details class="home-main-menu serial-modern-menu">
						<summary class="serial-modern-menu-btn">&#9776; Menu</summary>
						<ul class="home-main-dropdown">
							<li><a href="/search_mvp.php?lang={normalize-space(CONTROLINFO/LANGUAGE)}"><xsl:call-template name="ISSUETOC_UI_TEXT"><xsl:with-param name="key">search</xsl:with-param></xsl:call-template></a></li>
							<li><a href="/scielo.php?script=sci_alphabetic&amp;lng={normalize-space(CONTROLINFO/LANGUAGE)}&amp;nrm=iso"><xsl:call-template name="ISSUETOC_UI_TEXT"><xsl:with-param name="key">journal_list</xsl:with-param></xsl:call-template></a></li>
							<li><a href="https://educa.fcc.org.br/metricas/?lang=pt">Métricas e Indicadores</a></li>
							<li><a href="/about/?lang={normalize-space(CONTROLINFO/LANGUAGE)}"><xsl:call-template name="ISSUETOC_UI_TEXT"><xsl:with-param name="key">about_educa</xsl:with-param></xsl:call-template></a></li>
							<li><a href="/equipe/equipe_p.htm"><xsl:call-template name="ISSUETOC_UI_TEXT"><xsl:with-param name="key">team_educa</xsl:with-param></xsl:call-template></a></li>
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
								<li><a href="/scielo.php?script=sci_issuetoc&amp;pid={CONTROLINFO/PAGE_PID}&amp;lng=pt&amp;nrm=iso">Português</a></li>
							</xsl:if>
							<xsl:if test="normalize-space(CONTROLINFO/LANGUAGE) != 'en'">
								<li><a href="/scielo.php?script=sci_issuetoc&amp;pid={CONTROLINFO/PAGE_PID}&amp;lng=en&amp;nrm=iso">English</a></li>
							</xsl:if>
							<xsl:if test="normalize-space(CONTROLINFO/LANGUAGE) != 'es'">
								<li><a href="/scielo.php?script=sci_issuetoc&amp;pid={CONTROLINFO/PAGE_PID}&amp;lng=es&amp;nrm=iso">Español</a></li>
							</xsl:if>
						</ul>
					</div>
				</header>
				<main id="main-content" tabindex="-1">
				<h1 class="visually-hidden">
					<xsl:call-template name="GetStrip">
						<xsl:with-param name="vol" select="//ISSUE/@VOL"/>
						<xsl:with-param name="num" select="//ISSUE/@NUM"/>
						<xsl:with-param name="suppl" select="//ISSUE/@SUPPL"/>
						<xsl:with-param name="lang" select="//CONTROLINFO/LANGUAGE"/>
					</xsl:call-template>
				</h1>
				<xsl:call-template name="ISSUETOC_PERIODICAL_HEADER"/>
				<div class="content">
					<xsl:apply-templates select="//ISSUE"/>
				</div>
				</main>
				<div class="serial-page issues-footer-shell">
					<div class="container issues-footer-container">
						<xsl:apply-templates select="." mode="footer-journal"/>
					</div>
				</div>
				<div class="issuetoc-template-utils">
					<a href="mailto:educ@fcc.org.br?subject=Reportar%20erro" class="issuetoc-report"><xsl:call-template name="ISSUETOC_UI_TEXT"><xsl:with-param name="key">report_error</xsl:with-param></xsl:call-template></a>
					<a href="#main-content" class="issuetoc-accessibility"><xsl:attribute name="aria-label"><xsl:call-template name="ISSUETOC_UI_TEXT"><xsl:with-param name="key">accessibility</xsl:with-param></xsl:call-template></xsl:attribute>A</a>
					<a href="#top" class="issuetoc-backtop"><xsl:attribute name="aria-label"><xsl:call-template name="ISSUETOC_UI_TEXT"><xsl:with-param name="key">back_to_top</xsl:with-param></xsl:call-template></xsl:attribute>&#8593;</a>
				</div>
			
			<script type="text/javascript" src="/js/educa-accessibility.js?v=20260615-details-1"></script>
			<script type="text/javascript" src="/article.js"/>
			<script type="text/javascript">
				(function () {
					function shouldNormalizeAllCapsTitle(value) {
						var letters = (value || '').replace(/[^A-Za-zÀ-ÖØ-öø-ÿ]/g, '');
						if (letters.length &lt; 8) { return false; }
						return /[A-ZÁÀÂÃÄÉÈÊËÍÌÎÏÓÒÔÕÖÚÙÛÜÇÑ]/.test(letters) &amp;&amp; !/[a-záàâãäéèêëíìîïóòôõöúùûüçñ]/.test(letters);
					}

					function restoreTitleAcronyms(value) {
						return value.replace(/\b(apa|bncc|capes|cnpq|covid|eja|enade|enem|fcc|ideb|libras|ocde|pibic|pisa|pnaic|saeb|tdah|tdic|unesco|ufba|ufmg|ufpe|ufpr|ufrgs|ufrj|ufsc|usp)\b/gi, function (match) {
							return match.toLocaleUpperCase('pt-BR');
						});
					}

					function sentenceCaseTitle(value) {
						var normalized = (value || '').toLocaleLowerCase('pt-BR');
						normalized = normalized.replace(/(^|[.!?]\s+)([a-záàâãäéèêëíìîïóòôõöúùûüçñ])/g, function (match, prefix, letter) {
							return prefix + letter.toLocaleUpperCase('pt-BR');
						});
						return restoreTitleAcronyms(normalized);
					}

					Array.prototype.forEach.call(document.querySelectorAll('.issuetoc-page .issue-article-title a'), function (title) {
						var value = title.textContent.replace(/\s+/g, ' ').trim();
						if (shouldNormalizeAllCapsTitle(value)) {
							title.textContent = sentenceCaseTitle(value);
						}
					});
				}());
			</script>
			<xsl:if test="$journal_manager=1">
				<script type="text/javascript" src="/js/jquery-1.9.1.min.js"/>
				<script type="text/javascript">
					var lng = '<xsl:value-of select="//CONTROLINFO/LANGUAGE"/>';
					var ppid = '<xsl:value-of select="//PAGE_PID"/>';
					  function qry_prs() {
					    var url = "pressrelease/pressreleases_from_pid.php?lng="+lng+"&amp;pid="+ppid;
					    $.ajax({
					      url: url,
					      success: function (data) {
					      	jdata = jQuery.parseJSON(data);
					      	for (var item in jdata['article']){
					      		for (var npid in jdata['article'][item]['pid']){
						      		var pid = jdata['article'][item]['pid'][npid];
                                                                var url = '/pressrelease/pressrelease_display.php?id='+jdata['article'][item]['id']+'&amp;lng='+lng+'&amp;pid='+jdata['article'][item]['pid'];
                                                                url = url.replace(/(\r\n|\n|\r)/gm,"");
						      		var article_html='&#160;&#160;&#160;&#160;<font face="Symbol" color="#000080">&#183; </font><a href="javascript: void(0);" onclick="OpenArticleInfoWindow(850,850,\''+url+'\')">Press Release</a>';
						      		$("#pr_"+pid).html(article_html);
						      		$("#pr_"+pid).show();
					      		}
					      	}
						if (jdata['issue'].length > 0 ){
							$("#pr_issue").show()	
						}
					      	for (var item in jdata['issue']){
					      		jdata['issue'][item];
								var url = '/pressrelease/pressrelease_display.php?id='+jdata['issue'][item]['id']+'&amp;pid='+ppid+'&amp;lng='+lng;
					      		var li = '';
					      		li += '<font face="Symbol" color="#000080">&#183; </font>';
					      		li += '<b style="font-size: 13px;">&#160;'+jdata['issue'][item]['title']+'</b>';
					      		li += '<br/>';
					      		li += '<br/>';
					      		li += '&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<font face="Symbol" color="#000080">&#183; </font>';
					      		li += '<a href="javascript: void(0);" onclick="OpenArticleInfoWindow(850,850,\''+url+'\')">Press Release</a>';
					      		$("#pr_issue_list").append('<li>'+li+'</li>');

					      	}
					      }
					    });
					  }
					  $(document).ready(function() {
					      qry_prs();
					  });
				</script>
			</xsl:if>
			</BODY>
		</HTML>
	</xsl:template>

	<xsl:template match="link" mode="issuetoc-modern-action">
		<xsl:variable name="t" select="@type"/>
		<a class="list-group-item" href="{.}" target="_blank" rel="noopener noreferrer">
			<svg class="journal-side-icon" viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="M8 8h-3v11h11v-3"/><path d="M13 5h6v6"/><path d="M11 13l8-8"/></svg>
			<xsl:choose>
				<xsl:when test="$t='online_submission'"><xsl:call-template name="ISSUETOC_UI_TEXT"><xsl:with-param name="key">submission</xsl:with-param></xsl:call-template></xsl:when>
				<xsl:when test="$t='journal_site'"><xsl:call-template name="ISSUETOC_UI_TEXT"><xsl:with-param name="key">journal_site</xsl:with-param></xsl:call-template></xsl:when>
				<xsl:otherwise><xsl:value-of select="@label"/></xsl:otherwise>
			</xsl:choose>
		</a>
	</xsl:template>

	<xsl:template name="ISSUETOC_PERIODICAL_HEADER">
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
							<xsl:call-template name="ISSUETOC_UI_TEXT"><xsl:with-param name="key">published_by</xsl:with-param></xsl:call-template><xsl:text> </xsl:text><strong class="namePlublisher"><xsl:value-of select="/SERIAL/PUBLISHERS/PUBLISHER/NAME" disable-output-escaping="yes"/></strong>
						</span>
						<br/>
						<span class="theme">
							<span class="area"><xsl:call-template name="ISSUETOC_UI_TEXT"><xsl:with-param name="key">area</xsl:with-param></xsl:call-template></span>
							<xsl:text> </xsl:text>
							<xsl:value-of select="/SERIAL/TITLEGROUP/SUBJECT" disable-output-escaping="yes"/>
						</span>
						<span class="issn">
							<xsl:for-each select="/SERIAL/ISSUE_ISSN">
								<div>
									<span class="issnLabel">
										<xsl:choose>
											<xsl:when test="@TYPE='PRINT'"><xsl:call-template name="ISSUETOC_UI_TEXT"><xsl:with-param name="key">print_issn</xsl:with-param></xsl:call-template></xsl:when>
											<xsl:otherwise><xsl:call-template name="ISSUETOC_UI_TEXT"><xsl:with-param name="key">online_issn</xsl:with-param></xsl:call-template></xsl:otherwise>
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
							<xsl:apply-templates select="/SERIAL/link[@type='online_submission']" mode="issuetoc-modern-action"/>
							<xsl:apply-templates select="/SERIAL/link[@type='journal_site']" mode="issuetoc-modern-action"/>
							<a class="list-group-item" href="/revistas/{/SERIAL/TITLEGROUP/SIGLUM}/{$pref}aboutj.htm"><svg class="journal-side-icon" viewBox="0 0 24 24" aria-hidden="true" focusable="false"><circle cx="12" cy="12" r="9"/><path d="M12 10v6"/><path d="M12 7h.01"/></svg> <xsl:call-template name="ISSUETOC_UI_TEXT"><xsl:with-param name="key">about_journal</xsl:with-param></xsl:call-template></a>
							<a class="list-group-item" href="/revistas/{/SERIAL/TITLEGROUP/SIGLUM}/{$pref}edboard.htm"><svg class="journal-side-icon" viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg> <xsl:call-template name="ISSUETOC_UI_TEXT"><xsl:with-param name="key">editorial_board</xsl:with-param></xsl:call-template></a>
							<a class="list-group-item" href="/revistas/{/SERIAL/TITLEGROUP/SIGLUM}/{$pref}instruc.htm"><svg class="journal-side-icon" viewBox="0 0 24 24" aria-hidden="true" focusable="false"><circle cx="12" cy="12" r="9"/><path d="M9.5 9a2.7 2.7 0 1 1 4.8 1.7c-.9.7-1.5 1.2-1.8 2.3"/><path d="M12 17h.01"/></svg> <xsl:call-template name="ISSUETOC_UI_TEXT"><xsl:with-param name="key">instructions</xsl:with-param></xsl:call-template></a>
							<xsl:if test="/SERIAL/CONTACT/EMAILS/EMAIL">
								<a class="list-group-item" href="mailto:{/SERIAL/CONTACT/EMAILS/EMAIL[1]}"><svg class="journal-side-icon" viewBox="0 0 24 24" aria-hidden="true" focusable="false"><rect x="3" y="5" width="18" height="14" rx="2"/><path d="M3 7l9 6 9-6"/></svg> <xsl:call-template name="ISSUETOC_UI_TEXT"><xsl:with-param name="key">contact</xsl:with-param></xsl:call-template></a>
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
							<xsl:call-template name="ISSUETOC_UI_TEXT"><xsl:with-param name="key">journal_home</xsl:with-param></xsl:call-template>
						</a>
					</div>
					<div class="col-md-8 col-sm-8 serial-level-issues">
						<div class="btn-group">
							<a href="{$issuesUrl}" class="btn"><xsl:call-template name="ISSUETOC_UI_TEXT"><xsl:with-param name="key">all_issues</xsl:with-param></xsl:call-template></a>
							<xsl:choose>
								<xsl:when test="//PREVIOUS/@PID">
									<a href="/scielo.php?script=sci_issuetoc&amp;pid={//PREVIOUS/@PID}&amp;lng={$lang}&amp;nrm=iso" class="btn"><xsl:attribute name="title"><xsl:call-template name="ISSUETOC_UI_TEXT"><xsl:with-param name="key">previous_issue</xsl:with-param></xsl:call-template></xsl:attribute>&#171; <xsl:call-template name="ISSUETOC_UI_TEXT"><xsl:with-param name="key">previous_issue</xsl:with-param></xsl:call-template></a>
								</xsl:when>
								<xsl:otherwise><a href="#" class="btn disabled"><xsl:attribute name="title"><xsl:call-template name="ISSUETOC_UI_TEXT"><xsl:with-param name="key">previous_issue</xsl:with-param></xsl:call-template></xsl:attribute>&#171; <xsl:call-template name="ISSUETOC_UI_TEXT"><xsl:with-param name="key">previous_issue</xsl:with-param></xsl:call-template></a></xsl:otherwise>
							</xsl:choose>
							<xsl:choose>
								<xsl:when test="//NEXT/@PID">
									<a href="/scielo.php?script=sci_issuetoc&amp;pid={//NEXT/@PID}&amp;lng={$lang}&amp;nrm=iso" class="btn"><xsl:attribute name="title"><xsl:call-template name="ISSUETOC_UI_TEXT"><xsl:with-param name="key">next_issue</xsl:with-param></xsl:call-template></xsl:attribute><xsl:call-template name="ISSUETOC_UI_TEXT"><xsl:with-param name="key">next_issue</xsl:with-param></xsl:call-template> &#187;</a>
								</xsl:when>
								<xsl:otherwise><a href="#" class="btn disabled"><xsl:attribute name="title"><xsl:call-template name="ISSUETOC_UI_TEXT"><xsl:with-param name="key">next_issue</xsl:with-param></xsl:call-template></xsl:attribute><xsl:call-template name="ISSUETOC_UI_TEXT"><xsl:with-param name="key">next_issue</xsl:with-param></xsl:call-template> &#187;</a></xsl:otherwise>
							</xsl:choose>
							<a href="/scielo.php?script=sci_issuetoc&amp;pid={//CONTROLINFO/PAGE_PID}&amp;lng={$lang}&amp;nrm=iso" class="btn active selected"><xsl:attribute name="title"><xsl:call-template name="ISSUETOC_UI_TEXT"><xsl:with-param name="key">current_issue</xsl:with-param></xsl:call-template></xsl:attribute><xsl:call-template name="ISSUETOC_UI_TEXT"><xsl:with-param name="key">current_issue</xsl:with-param></xsl:call-template></a>
						</div>
					</div>
					<div class="col-md-2 col-sm-2 text-end serial-level-tools">
						<div class="btn-group" role="group">
							<xsl:attribute name="aria-label"><xsl:call-template name="ISSUETOC_UI_TEXT"><xsl:with-param name="key">tools</xsl:with-param></xsl:call-template></xsl:attribute>
							<a href="/search_mvp.php?lang={$lang}&amp;journal={/SERIAL/ISSN_AS_ID}" class="btn single"><xsl:call-template name="ISSUETOC_UI_TEXT"><xsl:with-param name="key">search</xsl:with-param></xsl:call-template></a>
							<a href="https://educa.fcc.org.br/metricas/?lang=pt" class="btn scielo__btn-with-icon--left"><xsl:call-template name="ISSUETOC_UI_TEXT"><xsl:with-param name="key">metrics</xsl:with-param></xsl:call-template></a>
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
							<a href="{$issuesUrl}" class="btn btn-secondary"><xsl:call-template name="ISSUETOC_UI_TEXT"><xsl:with-param name="key">all_issues</xsl:with-param></xsl:call-template></a>
							<a href="/search_mvp.php?lang={$lang}&amp;journal={/SERIAL/ISSN_AS_ID}" class="btn btn-secondary"><xsl:call-template name="ISSUETOC_UI_TEXT"><xsl:with-param name="key">search</xsl:with-param></xsl:call-template></a>
							<a href="https://educa.fcc.org.br/metricas/?lang=pt" class="btn btn-secondary"><xsl:call-template name="ISSUETOC_UI_TEXT"><xsl:with-param name="key">metrics</xsl:with-param></xsl:call-template></a>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col">
						<div class="btn-group mobile-issues">
							<xsl:choose>
								<xsl:when test="//PREVIOUS/@PID">
									<a href="/scielo.php?script=sci_issuetoc&amp;pid={//PREVIOUS/@PID}&amp;lng={$lang}&amp;nrm=iso" class="btn btn-secondary scielo__btn-with-icon--only"><xsl:attribute name="title"><xsl:call-template name="ISSUETOC_UI_TEXT"><xsl:with-param name="key">previous_issue</xsl:with-param></xsl:call-template></xsl:attribute><span class="material-icons-outlined">&#8249;</span></a>
								</xsl:when>
								<xsl:otherwise><a href="#" class="btn btn-secondary scielo__btn-with-icon--only disabled"><xsl:attribute name="title"><xsl:call-template name="ISSUETOC_UI_TEXT"><xsl:with-param name="key">previous_issue</xsl:with-param></xsl:call-template></xsl:attribute><span class="material-icons-outlined">&#8249;</span></a></xsl:otherwise>
							</xsl:choose>
							<xsl:choose>
								<xsl:when test="//NEXT/@PID">
									<a href="/scielo.php?script=sci_issuetoc&amp;pid={//NEXT/@PID}&amp;lng={$lang}&amp;nrm=iso" class="btn btn-secondary scielo__btn-with-icon--only"><xsl:attribute name="title"><xsl:call-template name="ISSUETOC_UI_TEXT"><xsl:with-param name="key">next_issue</xsl:with-param></xsl:call-template></xsl:attribute><span class="material-icons-outlined">&#8250;</span></a>
								</xsl:when>
								<xsl:otherwise><a href="#" class="btn btn-secondary scielo__btn-with-icon--only disabled"><xsl:attribute name="title"><xsl:call-template name="ISSUETOC_UI_TEXT"><xsl:with-param name="key">next_issue</xsl:with-param></xsl:call-template></xsl:attribute><span class="material-icons-outlined">&#8250;</span></a></xsl:otherwise>
							</xsl:choose>
							<a href="/scielo.php?script=sci_issuetoc&amp;pid={//CONTROLINFO/PAGE_PID}&amp;lng={$lang}&amp;nrm=iso" class="btn btn-secondary selected"><xsl:call-template name="ISSUETOC_UI_TEXT"><xsl:with-param name="key">current_issue</xsl:with-param></xsl:call-template></a>
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
						<li class="breadcrumb-item"><a href="/scielo.php?script=sci_alphabetic&amp;lng={$lang}&amp;nrm=iso"><xsl:call-template name="ISSUETOC_UI_TEXT"><xsl:with-param name="key">journals</xsl:with-param></xsl:call-template></a></li>
						<li class="breadcrumb-item"><xsl:value-of select="/SERIAL/TITLEGROUP/TITLE" disable-output-escaping="yes"/></li>
					</ol>
					<a class="btn btn-sm btn-secondary scielo__btn-with-icon--only serial-share-btn" href="mailto:?subject={/SERIAL/TITLEGROUP/TITLE}&amp;body=http://{//CONTROLINFO/SCIELO_INFO/SERVER}/scielo.php?script=sci_issuetoc%26pid={//CONTROLINFO/PAGE_PID}%26lng={$lang}%26nrm=iso">
						<xsl:attribute name="aria-label"><xsl:call-template name="ISSUETOC_UI_TEXT"><xsl:with-param name="key">share</xsl:with-param></xsl:call-template></xsl:attribute>
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

	<xsl:template match="ISSUE">
		<section class="issuetoc-modern">
			<div class="issuetoc-heading">
				<h2 class="issuetoc-title">
					<xsl:call-template name="ISSUETOC_UI_TEXT"><xsl:with-param name="key">summary</xsl:with-param></xsl:call-template>
				</h2>
				<div class="issuetoc-subtitle">
					<xsl:value-of select="/SERIAL/TITLEGROUP/TITLE" disable-output-escaping="yes"/>
					<xsl:if test="normalize-space(STRIP/VOL)">
						<xsl:text>, </xsl:text><xsl:call-template name="ISSUETOC_UI_TEXT"><xsl:with-param name="key">volume</xsl:with-param></xsl:call-template><xsl:text>: </xsl:text>
						<xsl:choose>
							<xsl:when test="contains(STRIP/VOL, 'vol.')">
								<xsl:value-of select="substring-after(STRIP/VOL, 'vol.')"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="STRIP/VOL"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
					<xsl:if test="normalize-space(STRIP/NUM)">
						<xsl:text>, </xsl:text><xsl:call-template name="ISSUETOC_UI_TEXT"><xsl:with-param name="key">issue</xsl:with-param></xsl:call-template><xsl:text>: </xsl:text>
						<xsl:choose>
							<xsl:when test="contains(STRIP/NUM, 'n.')">
								<xsl:value-of select="substring-after(STRIP/NUM, 'n.')"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="STRIP/NUM"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
					<xsl:if test="normalize-space(STRIP/YEAR)">
						<xsl:text>, </xsl:text><xsl:call-template name="ISSUETOC_UI_TEXT"><xsl:with-param name="key">published</xsl:with-param></xsl:call-template><xsl:text>: </xsl:text>
						<xsl:value-of select="STRIP/YEAR"/>
					</xsl:if>
				</div>
				<xsl:apply-templates select="TITLE" mode="issuetoc-modern"/>
			</div>
			<xsl:apply-templates select="PAGES"/>
			<xsl:if test="$journal_manager=1">
				<div id="pr_issue" class="issuetoc-press-release" style="display: none;">
					<h3>Press Release</h3>
					<ul id="pr_issue_list"> </ul>
				</div>
			</xsl:if>
			<div class="issuetoc-article-list">
				<xsl:choose>
					<xsl:when test="$journal_manager=1">
						<xsl:apply-templates select="SECTION[NAME != 'Press Release' or not(NAME)]"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="SECTION"/>
					</xsl:otherwise>
				</xsl:choose>
			</div>
			<xsl:apply-templates select="PAGES"/>
		</section>
	</xsl:template>
	<xsl:template match="TITLE" mode="issuetoc-modern">
		<div class="issuetoc-issue-title">
			<xsl:value-of select="." disable-output-escaping="yes"/>
		</div>
	</xsl:template>
	<xsl:template match="TITLE">
		<FONT COLOR="#005E5E">
			<B>
				<xsl:value-of select="." disable-output-escaping="yes"/>
			</B>
		</FONT>
		<BR/>
		<BR/>
	</xsl:template>
	<xsl:template match="STRIP">
		<FONT class="nomodel" color="#800000">
			<xsl:value-of
				select="$translations//xslid[@id='sci_issuetoc']//text[@find='table_of_contents']"/>
		</FONT>
		<BR/>
		<font color="#800000">
			<xsl:call-template name="SHOWSTRIP">
				<xsl:with-param name="SHORTTITLE" select="SHORTTITLE"/>
				<xsl:with-param name="VOL" select="VOL"/>
				<xsl:with-param name="NUM" select="NUM"/>
				<xsl:with-param name="SUPPL" select="SUPPL"/>
				<xsl:with-param name="CITY" select="CITY"/>
				<xsl:with-param name="MONTH" select="MONTH"/>
				<xsl:with-param name="YEAR" select="YEAR"/>
				<xsl:with-param name="reviewType">
					<xsl:if test="contains(NUM,'review')">provisional</xsl:if>
				</xsl:with-param>
			</xsl:call-template>
		</font>
	</xsl:template>
	<xsl:template match="SECTION">
		<xsl:choose>
			<xsl:when test="$num='AHEAD'">
				<xsl:apply-templates select="ARTICLE">
					<xsl:sort select="@ahpdate"/>
					<xsl:sort select="@DOI"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="ARTICLE"/>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>
	<xsl:template match="ARTICLE">
		<article class="issue-article-entry">
			<xsl:if test="../NAME and not($num='AHEAD')">
				<div class="issue-article-category">
					<xsl:value-of select="../NAME" disable-output-escaping="yes"/>
				</div>
			</xsl:if>
			<xsl:if test="TITLE">
				<h4 class="issue-article-title">
					<a href="/scielo.php?script=sci_arttext&amp;pid={@PID}&amp;lng={normalize-space(//CONTROLINFO/LANGUAGE)}&amp;nrm=iso&amp;tlng={@TEXT_LANG}">
						<xsl:value-of select="TITLE" disable-output-escaping="yes"/>
					</a>
				</h4>
			</xsl:if>
			<div class="issue-article-authors">
				<xsl:apply-templates select="AUTHORS" mode="issuetoc-modern-authors">
					<xsl:with-param name="NORM" select="//CONTROLINFO/STANDARD"/>
					<xsl:with-param name="LANG" select="//CONTROLINFO/LANGUAGE"/>
					<xsl:with-param name="AUTHLINK">1</xsl:with-param>
				</xsl:apply-templates>
			</div>
			<div class="issue-article-actions">
				<xsl:apply-templates select="LANGUAGES" mode="modern-actions">
					<xsl:with-param name="PID" select="@PID"/>
				</xsl:apply-templates>
			</div>
		</article>
	</xsl:template>
	<xsl:template match="LANGUAGES" mode="modern-actions">
		<xsl:param name="PID"/>
		<xsl:if test="ABSTRACT_LANGS/LANG">
			<span class="issue-article-action-group">
				<strong><xsl:call-template name="ISSUETOC_UI_TEXT"><xsl:with-param name="key">abstract</xsl:with-param></xsl:call-template>:</strong>
				<xsl:for-each select="ABSTRACT_LANGS/LANG">
					<a>
						<xsl:call-template name="AddScieloLink">
							<xsl:with-param name="seq" select="$PID"/>
							<xsl:with-param name="script">sci_abstract</xsl:with-param>
							<xsl:with-param name="txtlang" select="."/>
						</xsl:call-template>
						<xsl:call-template name="ISSUETOC_LANG_CODE">
							<xsl:with-param name="lang" select="."/>
						</xsl:call-template>
					</a>
				</xsl:for-each>
			</span>
		</xsl:if>
		<xsl:if test="ART_TEXT_LANGS/LANG">
			<span class="issue-article-action-group">
				<strong><xsl:call-template name="ISSUETOC_UI_TEXT"><xsl:with-param name="key">text</xsl:with-param></xsl:call-template>:</strong>
				<xsl:for-each select="ART_TEXT_LANGS/LANG">
					<a>
						<xsl:call-template name="AddScieloLink">
							<xsl:with-param name="seq" select="$PID"/>
							<xsl:with-param name="script">sci_arttext</xsl:with-param>
							<xsl:with-param name="txtlang" select="."/>
						</xsl:call-template>
						<xsl:call-template name="ISSUETOC_LANG_CODE">
							<xsl:with-param name="lang" select="."/>
						</xsl:call-template>
					</a>
				</xsl:for-each>
			</span>
		</xsl:if>
		<xsl:if test="PDF_LANGS/LANG">
			<span class="issue-article-action-group">
				<strong>PDF:</strong>
				<xsl:for-each select="PDF_LANGS/LANG">
					<a>
						<xsl:call-template name="AddScieloLink">
							<xsl:with-param name="seq" select="$PID"/>
							<xsl:with-param name="script">sci_pdf</xsl:with-param>
							<xsl:with-param name="txtlang" select="."/>
							<xsl:with-param name="file" select="@TRANSLATION"/>
						</xsl:call-template>
						<xsl:call-template name="ISSUETOC_LANG_CODE">
							<xsl:with-param name="lang" select="."/>
						</xsl:call-template>
					</a>
				</xsl:for-each>
			</span>
		</xsl:if>
		<xsl:if test="$journal_manager=1">
			<span id="{concat('pr_',$PID)}" class="issuetoc-pr-slot" style="display: none;"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="AUTHORS" mode="issuetoc-modern-authors">
		<xsl:param name="NORM"/>
		<xsl:param name="LANG"/>
		<xsl:param name="AUTHLINK">0</xsl:param>
		<xsl:apply-templates select="AUTH_PERS/AUTHOR" mode="issuetoc-modern-author-pers">
			<xsl:with-param name="NORM" select="$NORM"/>
			<xsl:with-param name="LANG" select="$LANG"/>
			<xsl:with-param name="AUTHLINK" select="$AUTHLINK"/>
			<xsl:with-param name="NUM_CORP" select="count(AUTH_CORP/AUTHOR)"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="AUTH_CORP/AUTHOR" mode="issuetoc-modern-author-corp"/>
	</xsl:template>
	<xsl:template match="AUTHOR" mode="issuetoc-modern-author-pers">
		<xsl:param name="NORM"/>
		<xsl:param name="LANG"/>
		<xsl:param name="AUTHLINK"/>
		<xsl:param name="NUM_CORP"/>
		<xsl:call-template name="CreateAuthor">
			<xsl:with-param name="SURNAME" select="SURNAME"/>
			<xsl:with-param name="NAME" select="NAME"/>
			<xsl:with-param name="SEARCH">
					<xsl:if test=" $AUTHLINK = 1 ">
						<xsl:value-of select="SURNAME"/>
					</xsl:if>
			</xsl:with-param>
			<xsl:with-param name="LANG" select="$LANG"/>
			<xsl:with-param name="NORM" select="$NORM"/>
			<xsl:with-param name="SEPARATOR">,</xsl:with-param>
		</xsl:call-template>
		<xsl:if test="position() != last() or $NUM_CORP > 0">
			<xsl:text> </xsl:text>
		</xsl:if>
	</xsl:template>
	<xsl:template match="AUTHOR" mode="issuetoc-modern-author-corp">
		<xsl:value-of select="normalize-space(ORGNAME)" disable-output-escaping="yes"/>
		<xsl:if test="ORGNAME and ORGDIV">. </xsl:if>
		<xsl:value-of select="normalize-space(ORGDIV)" disable-output-escaping="yes"/>
		<xsl:if test="position() != last()">
			<xsl:text> </xsl:text>
		</xsl:if>
	</xsl:template>
	<xsl:template name="ISSUETOC_LANG_CODE">
		<xsl:param name="lang"/>
		<xsl:choose>
			<xsl:when test="$lang='pt'">PT</xsl:when>
			<xsl:when test="$lang='es'">ES</xsl:when>
			<xsl:when test="$lang='en'">EN</xsl:when>
			<xsl:otherwise><xsl:value-of select="$lang"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="ISSUETOC_LANG_SUFFIX">
		<xsl:param name="lang"/>
		<xsl:text> </xsl:text>
		<span class="issue-article-action-lang">
			<xsl:choose>
				<xsl:when test="$lang='pt'">PT</xsl:when>
				<xsl:when test="$lang='es'">ES</xsl:when>
				<xsl:when test="$lang='en'">EN</xsl:when>
				<xsl:otherwise><xsl:value-of select="$lang"/></xsl:otherwise>
			</xsl:choose>
		</span>
	</xsl:template>
	<xsl:template match="PAGES">
		<div id="pagination">
			<span id="pageOf">
				<xsl:value-of select="$translations//xslid[@id='sci_issuetoc']//text[@find='page']"
				/>&#160; <xsl:value-of select="PAGE[@selected]/@number"/>&#160; <xsl:value-of
					select="$translations//xslid[@id='sci_issuetoc']//text[@find='of']"/>&#160;
					<xsl:value-of select="PAGE[position()=last()]/@number"/>
			</span>
			<span id="pageNav">
				<xsl:value-of
					select="$translations//xslid[@id='sci_issuetoc']//text[@find='gotopage']"
					/>&#160;<xsl:apply-templates select="PAGE" mode="look"/>
			</span>
		</div>
	</xsl:template>
	<xsl:template match="PAGE" mode="look">
		<xsl:if test="@number != '1'"/>
		<span class="page">
			<xsl:apply-templates select="."/>
		</span>
	</xsl:template>
	<xsl:template match="PAGE/@number">
		<xsl:value-of select="."/>
	</xsl:template>
	<xsl:template match="PAGE[@selected]/@number">
		<strong> &#160;<xsl:value-of select="."/>&#160; </strong>
	</xsl:template>
	<xsl:template match="PAGE">
		<a>
			<xsl:attribute name="href"><xsl:call-template name="getScieloLink"><xsl:with-param
						name="seq" select="$issuetoc_controlInfo/PAGE_PID"/><xsl:with-param
						name="script" select="'sci_issuetoc'"
					/></xsl:call-template>&amp;page=<xsl:value-of select="@number"/></xsl:attribute>
			<xsl:apply-templates select="@number"/>
		</a>
	</xsl:template>
	<xsl:template match="PAGE[@selected='true']">
		<xsl:apply-templates select="@number"/>
	</xsl:template>
	<xsl:template match="PAGE/@selected"> </xsl:template>
</xsl:stylesheet>
