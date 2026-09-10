<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:mml="http://www.w3.org/1998/Math/MathML"  xmlns:xlink="http://www.w3.org/1999/xlink">

	<xsl:import href="sci_navegation.xsl"/>
	<xsl:import href="sci_arttext_pmc.xsl"/>
	<xsl:import href="sci_toolbox.xsl"/>
	<xsl:output indent="yes"/>
	<xsl:variable name="LANGUAGES_ELEM" select="//ARTICLE/LANGUAGES"/>
	<xsl:template match="*[@xlink:href] | *[@href]" mode="fix_img_extension">
		<xsl:variable name="href"><xsl:choose>
			<xsl:when test="@xlink:href"><xsl:value-of select="@xlink:href"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="@href"/></xsl:otherwise>
		</xsl:choose></xsl:variable>
		<xsl:variable name="size" select="string-length($href)"/>
		<xsl:variable name="c1" select="substring($href,$size - 4)"/>
		<xsl:variable name="c2" select="substring($href,$size - 3)"/>
		<xsl:choose>
			<xsl:when test="substring($c1,1,1)='.'">
				<xsl:choose>
					<xsl:when test="contains($c1,'.tif')"><xsl:value-of select="substring-before($href,'.tif')"/>.jpg</xsl:when>
					<xsl:otherwise><xsl:value-of select="$href"/></xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="substring($c2,1,1)='.'">
				<xsl:choose>
					<xsl:when test="contains($c2,'.tif')"><xsl:value-of select="substring-before($href,'.tif')"/>.jpg</xsl:when>
					<xsl:otherwise><xsl:value-of select="$href"/></xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise><xsl:value-of select="$href"/>.jpg</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:variable name="PID" select="//ARTICLE/@PID"/>
	<xsl:variable name="version">
		<xsl:choose>
			<xsl:when test=".//BODY">html</xsl:when>
			<xsl:when test=".//fulltext/front">xml</xsl:when>
			<xsl:otherwise>xml-file</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="TXTLANG" select="//ARTICLE/@TEXTLANG"/>
	<!--xsl:variable name="xml_article"><xsl:if test="$version='xml-file'">file:///<xsl:value-of select="concat(.//PATH_HTDOCS,'/xml_files/',.//filename)"/></xsl:if></xsl:variable-->
	<xsl:variable name="xml_article">
		<xsl:if test="$version='xml-file'"><xsl:choose>
			<xsl:when test="//TESTE">file://<xsl:value-of select="//TESTE"/></xsl:when>
			<xsl:otherwise>file:///<xsl:value-of select="concat(substring-before(.//PATH_HTDOCS,'htdocs'),'bases/xml/',.//ISSUE/ARTICLE[1]/filename)"/></xsl:otherwise>
		</xsl:choose></xsl:if>
	</xsl:variable>
	<xsl:variable name="document" select="document($xml_article)"/>
	<xsl:variable name="original" select="$document//article"/>
	
	<xsl:variable name="path_img" select="'/img/revistas/'"/>

	<xsl:variable name="issue_label">
		<xsl:choose>
			<xsl:when test="//ISSUE/@NUM = 'AHEAD'">
				<xsl:value-of select="substring(//ISSUE/@PUBDATE,1,4)"/>
				<xsl:if test="//ISSUE/@NUM">nahead</xsl:if>
			</xsl:when>
			<xsl:when test="//ISSUE/@NUM or //ISSUE/@VOL">
				<xsl:if test="//ISSUE/@VOL">v<xsl:value-of select="translate(//ISSUE/@VOL, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/></xsl:if>
				<xsl:if test="//ISSUE/@NUM">n<xsl:value-of select="translate(//ISSUE/@NUM, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/></xsl:if>
				<xsl:if test="//ISSUE/@SUPPL">s<xsl:value-of select="translate(//ISSUE/@SUPPL, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/></xsl:if>
				<xsl:if test="//ISSUE/@COMPL"><xsl:value-of select="//ISSUE/@COMPL"/></xsl:if>
			</xsl:when>
			<xsl:when test="$version='xml-file'">
				<xsl:apply-templates select="$document//front/article-meta"
					mode="scift-issue-label"/>
			</xsl:when>
			<xsl:when test="$version='xml'">
				<xsl:apply-templates select=".//front/article-meta" mode="scift-issue-label"/>
			</xsl:when>
			
			<xsl:otherwise> </xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:template match="front/article-meta" mode="scift-issue-label">
		<xsl:if test="volume">v<xsl:value-of select="volume"/></xsl:if>
		<xsl:if test="issue">
			<xsl:choose>
				<xsl:when test="contains(issue,'Suppl')">
					<xsl:variable name="n"><xsl:value-of
							select="normalize-space(substring-before(issue,'Suppl'))"
						/></xsl:variable>
					<xsl:variable name="s"><xsl:value-of
							select="normalize-space(substring-after(issue,'Suppl'))"
						/></xsl:variable>
					<xsl:if test="$n!=''">n<xsl:value-of select="$n"/></xsl:if>s<xsl:value-of
						select="$s"/><xsl:if test="$s=''">0</xsl:if>
				</xsl:when>
				<xsl:when test="contains(issue,' pr')">n<xsl:value-of select="substring-before(issue,' pr')"/>pr</xsl:when>
				<xsl:otherwise>n<xsl:value-of select="issue"/></xsl:otherwise>
			</xsl:choose>

		</xsl:if>
		<xsl:if test="supplement"><xsl:variable name="s"><xsl:choose>
					<xsl:when test="contains(supplement, 'Suppl')"><xsl:value-of
							select="substring-after(supplement,'Suppl')"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="supplement"/></xsl:otherwise>
				</xsl:choose></xsl:variable>s<xsl:value-of select="$s"/><xsl:if test="$s=''"
				>0</xsl:if>
		</xsl:if>

	</xsl:template>
	<xsl:variable name="var_IMAGE_PATH">
		<xsl:choose>
			<xsl:when test="//PATH_SERIMG and //SIGLUM and //ISSUE">
				<xsl:value-of select="//PATH_SERIMG"/>
				<xsl:value-of select="//SIGLUM"/>/<xsl:value-of select="$issue_label"/>/</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="//image-path"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="merge">true</xsl:variable>
	<xsl:variable name="xml_display_objects">
		<xsl:choose>
			<xsl:when test="$original//sec/@sec-type='display-objects'">true</xsl:when>
			<xsl:otherwise>false</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="TEXT_LANG">
		<xsl:choose>
			<xsl:when test="$TXTLANG!=''">
				<xsl:value-of select="$TXTLANG"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$original/@xml:lang"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="article" select=".//ISSUE/ARTICLE"/>
	<xsl:variable name="LANGUAGE" select="//LANGUAGE"/>
	<xsl:variable name="SCIELO_REGIONAL_DOMAIN" select="//SCIELO_REGIONAL_DOMAIN"/>
	<xsl:variable name="hasPDF" select="//ARTICLE/@PDF"/>
	<xsl:variable name="show_toolbox" select="//toolbox"/>
	<xsl:variable name="show_meta_citation_reference"
		select="//varScieloOrg/show_meta_citation_reference"/>
	<xsl:template match="fulltext-service-list"/>
	<xsl:template match="/">

		<xsl:choose>
			<xsl:when test="$version='xml-file' or $merge='true'">
				<xsl:apply-templates select="//SERIAL" mode="merged"/>
			</xsl:when>

			<xsl:otherwise>
				<xsl:apply-templates select="//SERIAL"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="ARTICLE" mode="redirect_press_release">
		<xsl:if test="@is='pr'">

			<xsl:variable name="X">/scielo.php?script=sci_arttext_pr&amp;pid=<xsl:value-of
					select="@PID"/></xsl:variable>
			<meta HTTP-EQUIV="REFRESH">
				<xsl:attribute name="Content">
					<xsl:value-of select="concat('0;URL=',$X)"/>
				</xsl:attribute>
			</meta>
		</xsl:if>

	</xsl:template>
	<xsl:template match="SERIAL" mode="meta_names">
		<link rel="canonical" href="{concat('http://',CONTROLINFO/SCIELO_INFO/SERVER, '/scielo.php?script=sci_arttext&amp;pid=', ISSUE/ARTICLE/@PID)}" />
		<meta http-equiv="Pragma" content="no-cache"/>
		<meta http-equiv="Expires" content="Mon, 06 Jan 1990 00:00:01 GMT"/>
		<meta Content-math-Type="text/mathml"/>

		<xsl:apply-templates select="//ARTICLE" mode="redirect_press_release"/>
		<!--Meta Google Scholar-->
		<meta name="citation_journal_title" content="{TITLEGROUP/TITLE}"/>
		<meta name="citation_journal_title_abbrev" content="{TITLEGROUP/SHORTTITLE}"/>
		<meta name="citation_publisher" content="{normalize-space(COPYRIGHT)}"/>
		<meta name="citation_title" content="{ISSUE/ARTICLE/citation_title}"/>
		<meta name="citation_language"
			content="{ISSUE/ARTICLE/citation_title/@lang}"/>
		<meta name="citation_date"
			content="{concat(substring(ISSUE/@PUBDATE,5,2),'/',substring(ISSUE/@PUBDATE,1,4))}"/>
		<meta name="citation_volume" content="{ISSUE/@VOL}"/>
		<meta name="citation_issue" content="{ISSUE/@NUM}"/>
		<meta name="citation_issn" content="{ISSN}"/>
		<meta name="citation_doi" content="{ISSUE/ARTICLE/@DOI}"/>
		<meta name="citation_abstract_html_url"
			content="{concat('http://',CONTROLINFO/SCIELO_INFO/SERVER, '/scielo.php?script=sci_abstract&amp;pid=', ISSUE/ARTICLE/@PID, '&amp;lng=', CONTROLINFO/LANGUAGE , '&amp;nrm=iso&amp;tlng=', ISSUE/ARTICLE/@TEXTLANG)}"/>
		<meta name="citation_fulltext_html_url"
			content="{concat('http://',CONTROLINFO/SCIELO_INFO/SERVER, '/scielo.php?script=sci_arttext&amp;pid=', ISSUE/ARTICLE/@PID, '&amp;lng=', CONTROLINFO/LANGUAGE , '&amp;nrm=iso&amp;tlng=', ISSUE/ARTICLE/@TEXTLANG)}"/>
		<xsl:apply-templates select="ISSUE/ARTICLE/AUTHORS/AUTH_PERS/AUTHOR" mode="AUTHORS_META"/>
		<meta name="citation_firstpage" content="{ISSUE/ARTICLE/@FPAGE}"/>
		<meta name="citation_lastpage" content="{ISSUE/ARTICLE/@LPAGE}"/>
		<meta name="citation_id" content="{ISSUE/ARTICLE/@DOI}"/>

		<xsl:apply-templates select="ISSUE/ARTICLE/LANGUAGES/PDF_LANGS/LANG" mode="meta_citation_pdf_url">
			<xsl:with-param name="orig_lang" select="ISSUE/ARTICLE/@ORIGINALLANG" />
		</xsl:apply-templates>

		<!--Reference Citation-->
		<xsl:if test="$show_meta_citation_reference='1'">
			<xsl:apply-templates select="ISSUE/ARTICLE/REFERENCES"/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="LANG" mode="meta_citation_pdf_url">
		<xsl:param name="orig_lang" />
		<xsl:variable name="lang" select="." />
		<meta>
			<xsl:attribute name="name">citation_pdf_url</xsl:attribute>
			<xsl:attribute name="language"><xsl:value-of select="$lang" /></xsl:attribute>
			<xsl:if test="$orig_lang = $lang">
				<xsl:attribute name="default">true</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="content"><xsl:value-of select="concat('http://',//CONTROLINFO/SCIELO_INFO/SERVER,'/pdf/',@TRANSLATION)" /></xsl:attribute>
		</meta>
	</xsl:template>

	<xsl:template match="SERIAL">

		<xsl:if test=".//mml:math">
			<xsl:processing-instruction name="xml-stylesheet"> type="text/xsl" href="/xsl/mathml.xsl"</xsl:processing-instruction>
		</xsl:if>
		<html xmlns="http://www.w3.org/1999/xhtml" lang="{normalize-space(CONTROLINFO/LANGUAGE)}">
			<head>
				<title>
					<xsl:value-of select="ISSUE/ARTICLE/citation_title" />
				</title>
				<xsl:apply-templates select="." mode="meta_names"/>
				<meta name="viewport" content="width=device-width, initial-scale=1"/>

				<link rel="stylesheet" type="text/css" href="/css/screen.css"/>
				<link rel="stylesheet" type="text/css" href="/design-system/1.0.0/css/bootstrap.css"/>
				<link rel="stylesheet" type="text/css" href="/design-system/1.0.0/css/article.css"/>
				<link rel="stylesheet" type="text/css" href="/css/scielo-ds-bridge.css?v=arttext-20260722-11"/>
				<xsl:apply-templates select="." mode="css"/>
	            <xsl:if test="//show_readcube_epdf = '1'">
	                <script src="http://content.readcube.com/scielo/epdf_linker.js" type="text/javascript" async="true"></script>
    	        </xsl:if>
				<xsl:call-template name="EDUCA_GOOGLE_TAG"/>
			</head>
			<body class="arttext-page">
				<xsl:call-template name="ACCESS_SKIP_LINK"/>
				<a name="top"/>
				<xsl:call-template name="ARTTEXT_MODERN_HEADER"/>
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
							<xsl:with-param name="show_search_portal">0</xsl:with-param>
							<xsl:with-param name="scope" select="TITLEGROUP/SIGLUM"/>
						</xsl:call-template>
					</div>
					<xsl:call-template name="ARTTEXT_BREADCRUMB"/>
					<main id="main-content" tabindex="-1" class="content">
						<article class="arttext-article-card">
							<xsl:call-template name="ARTTEXT_READING_TOOLBAR"/>
							<xsl:call-template name="ARTTEXT_CITATION_LINE"/>
							<h1 class="visually-hidden">
								<xsl:value-of select="ISSUE/ARTICLE/citation_title" disable-output-escaping="yes"/>
							</h1>
							<div class="issues-journal-logo">
								<img src="{//CONTROLINFO/SCIELO_INFO/PATH_SERIMG}{//TITLEGROUP/SIGLUM}/glogo.gif" alt="{//TITLEGROUP/TITLE}"/>
							</div>
							<xsl:choose>
								<xsl:when test="//NO_SCI_SERIAL='yes'">
									<h2 id="printISSN">
										<xsl:value-of
											select="$translations/xslid[@id='sci_arttext']/text[@find='original_version_published_in']"
										/>
									</h2>
								</xsl:when>
								<xsl:otherwise>
									<h2>
										<xsl:choose>
											<xsl:when test="//CONTROLINFO/NO_SCI_SERIAL='yes'">
												<xsl:value-of select="TITLEGROUP/TITLE"
													disable-output-escaping="yes"/>
											</xsl:when>
											<xsl:otherwise>
												<a>
													<xsl:call-template name="AddScieloLink">
													<xsl:with-param name="seq" select=".//ISSN_AS_ID"/>
													<xsl:with-param name="script"
													>sci_serial</xsl:with-param>
													</xsl:call-template>
													<xsl:value-of select="TITLEGROUP/TITLE"
													disable-output-escaping="yes"/>
												</a>
											</xsl:otherwise>
										</xsl:choose>
									</h2>
									<h2 id="printISSN">
										<xsl:apply-templates select=".//ISSUE_ISSN">
											<xsl:with-param name="LANG"
												select="normalize-space(CONTROLINFO/LANGUAGE)"/>
										</xsl:apply-templates>
									</h2>
								</xsl:otherwise>
							</xsl:choose>
							<h3>
								<xsl:apply-templates select="ISSUE/STRIP"/>
							</h3>
							<h4 id="doi">
								<xsl:apply-templates select="ISSUE/ARTICLE/@DOI" mode="display"/>&#160; </h4>
							<div class="index,{ISSUE/ARTICLE/@TEXTLANG}">
								<xsl:apply-templates select="ISSUE/ARTICLE/BODY"/>
							</div>
							<xsl:if test="$isProvisional='1' and $hasPDF='1'">
								<a>
									<xsl:call-template name="AddScieloLink">
										<xsl:with-param name="seq" select="ISSUE/ARTICLE/@PID"/>
										<xsl:with-param name="script">sci_pdf</xsl:with-param>
										<xsl:with-param name="txtlang" select="ISSUE/ARTICLE/@TEXTLANG"
										/>
									</xsl:call-template>
									<xsl:value-of
										select="$translations/xslid[@id='sci_arttext']/text[@find='fulltext_only_in_pdf']"
									/>
								</a>
							</xsl:if>
							<xsl:if test="ISSUE/ARTICLE/fulltext">
								<xsl:apply-templates select="ISSUE/ARTICLE[fulltext]"/>
							</xsl:if>
							<xsl:if test="not(ISSUE/ARTICLE/BODY) and not(ISSUE/ARTICLE/fulltext)">
								<xsl:apply-templates select="ISSUE/ARTICLE/EMBARGO/@date">
									<xsl:with-param name="lang" select="$interfaceLang"/>
								</xsl:apply-templates>
							</xsl:if>
							<div align="left"/>
							<div class="spacer">&#160;</div>
						</article>
					</main>
					<xsl:apply-templates select="." mode="footer-journal"/>
				</div>
				<xsl:call-template name="ARTTEXT_UTILS"/>

				<script language="javascript" src="applications/scielo-org/js/jquery-1.4.2.min.js"/>
				<script language="javascript" src="applications/scielo-org/js/toolbox.js"/>
				<script type="text/javascript" src="/js/educa-accessibility.js?v=20260615-details-1"></script>
				<xsl:call-template name="ARTTEXT_READING_SCRIPT"/>
				
			</body>
		</html>
	</xsl:template>

	<xsl:template match="SERIAL" mode="merged">
		<xsl:if test=".//mml:math">
			<xsl:processing-instruction name="xml-stylesheet"> type="text/xsl" href="/xsl/mathml.xsl"</xsl:processing-instruction>
		</xsl:if>
		<html xmlns="http://www.w3.org/1999/xhtml" lang="{normalize-space(CONTROLINFO/LANGUAGE)}">
			<head>
				<title>
					<xsl:value-of select="ISSUE/ARTICLE/citation_title" />
				</title>
				<xsl:apply-templates select="." mode="meta_names"/>
				<meta name="viewport" content="width=device-width, initial-scale=1"/>
				<xsl:apply-templates select="." mode="version-css"/>
				<xsl:apply-templates select="." mode="version-js"/>
	            <xsl:if test="//show_readcube_epdf = '1'">
	                <script src="http://content.readcube.com/scielo/epdf_linker.js" type="text/javascript" async="true"></script>
	            </xsl:if>
				<xsl:call-template name="EDUCA_GOOGLE_TAG"/>
				</head>
			<body class="arttext-page">
				<xsl:call-template name="ACCESS_SKIP_LINK"/>
				<a name="top"/>
				<xsl:call-template name="ARTTEXT_MODERN_HEADER"/>
				<div class="container">
					<div class="top">
						<div id="issues"/>
						<xsl:apply-templates select="." mode="common-display-nav-bar"/>
					</div>
					<xsl:call-template name="ARTTEXT_BREADCRUMB"/>
					<main id="main-content" tabindex="-1" class="content">
						<article class="arttext-article-card">
							<xsl:call-template name="ARTTEXT_READING_TOOLBAR"/>
							<xsl:call-template name="ARTTEXT_CITATION_LINE"/>
							<h1 class="visually-hidden">
								<xsl:value-of select="ISSUE/ARTICLE/citation_title" disable-output-escaping="yes"/>
							</h1>
							<xsl:apply-templates select="." mode="text-header"/>
							<xsl:apply-templates select="." mode="text-disclaimer"/>
							<xsl:apply-templates select="." mode="text-content"/>
						</article>
					</main>
					<xsl:if test="$version='html'">
						<xsl:apply-templates select="." mode="footer-journal"/>
					</xsl:if>
				</div>
				<xsl:call-template name="ARTTEXT_UTILS"/>
				<xsl:if test="$version!='html'">
					<div class="container">
						<div align="left"/>
						<div class="spacer">&#160;</div>
						<xsl:apply-templates select="." mode="footer-journal"/>
					</div>
				</xsl:if>
				<script type="text/javascript" src="/js/educa-accessibility.js?v=20260615-details-1"></script>
				<xsl:call-template name="ARTTEXT_READING_SCRIPT"/>
			</body>
		</html>
	</xsl:template>
	
	<xsl:template match="SERIAL" mode="version-head-title">
		<xsl:value-of select="TITLEGROUP/TITLE" disable-output-escaping="yes"/> - <xsl:value-of
			select="normalize-space(ISSUE/ARTICLE/citation_title)" disable-output-escaping="yes"/>
	</xsl:template>

	<xsl:template match="SERIAL" mode="version-css">
		<xsl:choose>
			<xsl:when test="$version='xml-file' or $version= 'xml'">
				<link rel="stylesheet" type="text/css" href="/css/screen.css"/>
				<link rel="stylesheet" type="text/css" href="/design-system/1.0.0/css/bootstrap.css"/>
				<link rel="stylesheet" type="text/css" href="/design-system/1.0.0/css/article.css"/>
				<link rel="stylesheet" type="text/css" href="/xsl/pmc/v3.0/xml.css"/>
				<link rel="stylesheet" type="text/css" href="/css/scielo-ds-bridge.css?v=arttext-20260722-11"/>
				<!--link rel="stylesheet" type="text/css" href="/xsl/pmc/v3.0/css/jpub-preview.css" /-->
			</xsl:when>
			<!--xsl:when test="$version='xml'">
            	<link rel="stylesheet" type="text/css" href="/css/screen.css"/>
				<link rel="stylesheet" type="text/css" href="/design-system/1.0.0/css/bootstrap.css"/>
				<link rel="stylesheet" type="text/css" href="/design-system/1.0.0/css/article.css"/>
				<link rel="stylesheet" type="text/css" href="/css/scielo-ds-bridge.css?v=arttext-20260722-11"/>
                <link xmlns="" rel="stylesheet" type="text/css" href="/css/pmc/ViewNLM.css"/>
                <link xmlns="" rel="stylesheet" type="text/css" href="/css/pmc/ViewScielo.css"/>

            </xsl:when-->
			<xsl:otherwise>
				<link rel="stylesheet" type="text/css" href="/css/screen.css"/>
				<link rel="stylesheet" type="text/css" href="/design-system/1.0.0/css/bootstrap.css"/>
				<link rel="stylesheet" type="text/css" href="/design-system/1.0.0/css/article.css"/>
				<link rel="stylesheet" type="text/css" href="/css/scielo-ds-bridge.css?v=arttext-20260722-11"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="SERIAL" mode="version-js">
		<xsl:choose>
			<xsl:when test="$version='xml-file'">
				<script language="javascript" src="applications/scielo-org/js/jquery-1.4.2.min.js"/>
				<script language="javascript" src="applications/scielo-org/js/toolbox.js"/>
				<xsl:if test="$original//math or $original//mml:math or $original//tex-math">
					<script type="text/javascript"
						src="https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.1/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
					</script>
				</xsl:if>
				<script language="javascript">
					function smaller(elem_img) {
						if ((elem_img.height &gt; elem_img.width) &amp;&amp; (elem_img.height &gt; 100)) {
							elem_img.className="inline-graphic-more-limited";
						} else if (elem_img.width &gt; 300) {
				
						} else if ((elem_img.height &gt; elem_img.width) &amp;&amp; (elem_img.height &gt; 70)) {
							elem_img.className="inline-graphic-limited";
						} 
					}
				</script>
			</xsl:when>
			<xsl:otherwise>
				<script language="javascript" src="applications/scielo-org/js/jquery-1.4.2.min.js"/>
				<script language="javascript" src="applications/scielo-org/js/toolbox.js"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	
	<xsl:template match="SERIAL" mode="common-display-nav-bar">
		<xsl:call-template name="NAVBAR">
			<xsl:with-param name="bar1">articles</xsl:with-param>
			<xsl:with-param name="bar2"></xsl:with-param>
			<xsl:with-param name="compact_nav">1</xsl:with-param>
			<xsl:with-param name="compact_variant">arttext</xsl:with-param>
			<xsl:with-param name="home">1</xsl:with-param>
			<xsl:with-param name="alpha">0</xsl:with-param>
			<xsl:with-param name="show_lang_switch">1</xsl:with-param>
			<xsl:with-param name="show_search_portal">0</xsl:with-param>
			<xsl:with-param name="scope" select="TITLEGROUP/SIGLUM"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="SERIAL" mode="text-header">
		<div class="issues-journal-logo">
			<img src="{//CONTROLINFO/SCIELO_INFO/PATH_SERIMG}{//TITLEGROUP/SIGLUM}/glogo.gif" alt="{//TITLEGROUP/TITLE}"/>
		</div>
		<xsl:choose>
			<xsl:when test="//NO_SCI_SERIAL='yes'">
				<!-- 
					when there is no sci_serial page, which means, no home page for journal, 
					because it is a repository website, for instance
				-->
				<h2 id="printISSN">
					<xsl:value-of
						select="$translations/xslid[@id='sci_arttext']/text[@find='original_version_published_in']"
					/>
				</h2>
				<h2>
					<xsl:value-of select="TITLEGROUP/TITLE" disable-output-escaping="yes"/>
				</h2>

			</xsl:when>
			<xsl:otherwise>
				<h2>
					<a>
						<xsl:call-template name="AddScieloLink">
							<xsl:with-param name="seq" select=".//ISSN_AS_ID"/>
							<xsl:with-param name="script">sci_serial</xsl:with-param>
						</xsl:call-template>
						<xsl:value-of select="TITLEGROUP/TITLE" disable-output-escaping="yes"/>
					</a>

				</h2>
				<h2 id="printISSN">
					<xsl:apply-templates select=".//ISSUE_ISSN">
						<xsl:with-param name="LANG" select="normalize-space(CONTROLINFO/LANGUAGE)"/>
					</xsl:apply-templates>
				</h2>
			</xsl:otherwise>
		</xsl:choose>
		<h3>
			<xsl:apply-templates select="ISSUE/STRIP"/>

		</h3>
		<h4 id="doi">
			<xsl:apply-templates select="ISSUE/ARTICLE/@DOI" mode="display"/>&#160; </h4>
	</xsl:template>
	<xsl:template match="SERIAL" mode="text-content">
		<div class="index,{ISSUE/ARTICLE/@TEXTLANG}">
			<xsl:choose>
				<xsl:when test="$version='html'">
					<xsl:comment>version=html</xsl:comment>
					<xsl:apply-templates select="ISSUE/ARTICLE/BODY"/>
				</xsl:when>

				<xsl:when test="$version='xml'">
					<xsl:comment>version=xml</xsl:comment>
					<xsl:apply-templates select="ISSUE/ARTICLE[fulltext]"/>
				</xsl:when>
				<xsl:when test="$version='xml-file'">
					<xsl:comment>version=xml-file</xsl:comment>
					<xsl:apply-templates select="$document" mode="text-content"/>
				</xsl:when>
			</xsl:choose>
		</div>
		<xsl:if test="$isProvisional='1' and $hasPDF='1'">
			<a>
				<xsl:call-template name="AddScieloLink">
					<xsl:with-param name="seq" select="ISSUE/ARTICLE/@PID"/>
					<xsl:with-param name="script">sci_pdf</xsl:with-param>
					<xsl:with-param name="txtlang" select="ISSUE/ARTICLE/@TEXTLANG"/>
				</xsl:call-template>
				<xsl:value-of
					select="$translations/xslid[@id='sci_arttext']/text[@find='fulltext_only_in_pdf']"
				/>
			</a>
		</xsl:if>

		<xsl:if
			test="not(ISSUE/ARTICLE/BODY) and not(ISSUE/ARTICLE/fulltext) and ISSUE/ARTICLE/EMBARGO/@date!=''">
			<xsl:apply-templates select="ISSUE/ARTICLE/EMBARGO/@date">
				<xsl:with-param name="lang" select="$interfaceLang"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>
	<xsl:template match="BODY">
		<xsl:apply-templates select="*|text()" mode="body-content"/>

	</xsl:template>

	<xsl:template match="REFERENCES/REFERENCE">
		<meta name="citation_reference"
			content="citation_title={TITLE_REFERENCE}; citation_author={AUTHORS_REFERENCE};citation_journal_title={JOURNAL_TITLE_REFERENCE};citation_volume={VOLUME_REFERENCE};citation_pages={PAGE_REFERENCE};citation_year={YEAR_REFERENCE};citation_fulltext_html_url={URL_REFERENCE};"
		/>
	</xsl:template>

	<xsl:template match="*|text()" mode="body-content">
		<xsl:value-of select="." disable-output-escaping="yes"/>
	</xsl:template>
	<xsl:template match="STRIP">
		<xsl:call-template name="SHOWSTRIP">
			<xsl:with-param name="SHORTTITLE" select="SHORTTITLE"/>
			<xsl:with-param name="VOL" select="VOL"/>
			<xsl:with-param name="NUM" select="NUM"/>
			<xsl:with-param name="SUPPL" select="SUPPL"/>
			<xsl:with-param name="CITY" select="CITY"/>
			<xsl:with-param name="MONTH" select="MONTH"/>
			<xsl:with-param name="YEAR" select="YEAR"/>
			<xsl:with-param name="reviewType">
				<xsl:if test="../ARTICLE/@hcomment!='1' or not(../ARTICLE/@hcomment)"
					>provisional</xsl:if>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="p[contains(.,'en PDF') and contains(., 'disponible')] | p[contains(.,'apenas em PDF')] | p[contains(.,'available only in PDF')] ">
		<p>
			<xsl:apply-templates select="$LANGUAGES_ELEM//PDF_LANGS/LANG[.=$TEXT_LANG]" mode="link">
				<xsl:with-param name="text" select="."/>
			</xsl:apply-templates>
			<xsl:if test="not($LANGUAGES_ELEM//PDF_LANGS/LANG[.=$TEXT_LANG])">
				<xsl:apply-templates select="$LANGUAGES_ELEM//PDF_LANGS/LANG[1]" mode="link">
					<xsl:with-param name="text" select="."/>
				</xsl:apply-templates>
			</xsl:if>
		</p>
	</xsl:template>
	<xsl:template match="PDF_LANGS/LANG" mode="link">
		<xsl:param name="text"></xsl:param>
		<a>
			<xsl:attribute name="href">/pdf/<xsl:value-of select="@TRANSLATION"/></xsl:attribute>
			<xsl:value-of select="$text"/>
		</a>
	</xsl:template>
	<xsl:template match="SERIAL" mode="text-disclaimer">
		<xsl:if test=".//ARTICLE/RELATED-DOC">
			<div class="disclaimer">
					<xsl:apply-templates select=".//ARTICLE/RELATED-DOC"/>			
				
			</div>
		</xsl:if>
		<!--xsl:if test=".//ARTICLE/RELATED-DOC[@TYPE='correction']">
			<div class="fixed-disclaimer">			
				<xsl:apply-templates select=".//ARTICLE/RELATED-DOC[@TYPE='correction']"/>			
			</div>
		</xsl:if-->
	</xsl:template>
	
	<xsl:template match="RELATED-DOC">
		<p>
			<strong>
				<xsl:choose>
					<xsl:when test="@TYPE='correction'">
						<xsl:value-of
							select="$translations/xslid[@id='sci_arttext']/text[@find='this_article_has_been_corrected']"
						/>: 
					</xsl:when>
					<xsl:when test="@TYPE='corrected-article'">
						<xsl:value-of
							select="$translations/xslid[@id='sci_arttext']/text[@find='this_corrects']"
						/>: 
					</xsl:when>
					<xsl:when test="@TYPE='retracted-article'">
						<xsl:value-of
							select="$translations/xslid[@id='sci_arttext']/text[@find='this_retracts']"
						/>: 
					</xsl:when>
					<xsl:when test="@TYPE='partial-retraction' or @TYPE='partial-retracted'">
						<xsl:value-of
							select="$translations/xslid[@id='sci_arttext']/text[@find='this_retracts_partially']"
						/>: 
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of
							select="$translations/xslid[@id='sci_arttext']/text[@find='related_to']"
						/>:
					</xsl:otherwise>
				</xsl:choose>
			</strong>
			<xsl:choose>
				<xsl:when test="@DOI">
					<a href="https://doi.org/{@DOI}"><xsl:value-of select="@DOI"/></a>
				</xsl:when>
				<xsl:otherwise>
					<a target="_blank">
						<xsl:call-template name="AddScieloLink">
							<xsl:with-param name="seq" select="@PID"/>
							<xsl:with-param name="script">sci_arttext</xsl:with-param>
							<xsl:with-param name="txtlang" select="$TXTLANG"/>
						</xsl:call-template><xsl:value-of select="ISSUE"/>
					</a>
				</xsl:otherwise>
			</xsl:choose>
			
		</p>
	</xsl:template>

	<xsl:template name="ARTTEXT_MODERN_HEADER">
		<xsl:variable name="lang" select="normalize-space(//CONTROLINFO/LANGUAGE)"/>
		<xsl:variable name="pid" select="//ISSUE/ARTICLE/@PID"/>
		<xsl:variable name="tlng" select="//ISSUE/ARTICLE/@TEXTLANG"/>
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
					<li><a href="/scielo.php?script=sci_arttext&amp;pid={$pid}&amp;lng=pt&amp;nrm=iso&amp;tlng=pt">Portugu&#234;s</a></li>
					<li><a href="/scielo.php?script=sci_arttext&amp;pid={$pid}&amp;lng=en&amp;nrm=iso&amp;tlng=en">English</a></li>
					<li><a href="/scielo.php?script=sci_arttext&amp;pid={$pid}&amp;lng=es&amp;nrm=iso&amp;tlng=es">Espa&#241;ol</a></li>
				</ul>
			</details>
		</header>
	</xsl:template>

	<xsl:template name="ARTTEXT_READING_NAV">
		<aside class="arttext-reading-nav" aria-label="Sum&#225;rio do artigo">
			<nav>
				<strong>Sum&#225;rio</strong>
				<a href="#article-body" class="is-active">Texto</a>
				<a href="#article-references">Refer&#234;ncias bibliogr&#225;ficas</a>
				<a href="#article-publication-dates">Datas de publica&#231;&#227;o</a>
			</nav>
		</aside>
	</xsl:template>

	<xsl:template name="ARTTEXT_READING_TOOLBAR">
		<xsl:variable name="lang" select="normalize-space(//CONTROLINFO/LANGUAGE)"/>
		<xsl:variable name="tlng" select="//ISSUE/ARTICLE/@TEXTLANG"/>
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
						<a href="/scielo.php?script=sci_arttext&amp;pid={//PREVIOUS/@PID}&amp;lng={$lang}&amp;nrm=iso&amp;tlng={$tlng}">&#8249; Anterior</a>
					</xsl:when>
					<xsl:otherwise><span class="is-disabled">&#8249; Anterior</span></xsl:otherwise>
				</xsl:choose>
				<span class="is-current">Atual</span>
				<xsl:choose>
					<xsl:when test="//NEXT/@PID">
						<a href="/scielo.php?script=sci_arttext&amp;pid={//NEXT/@PID}&amp;lng={$lang}&amp;nrm=iso&amp;tlng={$tlng}">Seguinte &#8250;</a>
					</xsl:when>
					<xsl:otherwise><span class="is-disabled">Seguinte &#8250;</span></xsl:otherwise>
				</xsl:choose>
			</div>
			<div class="arttext-reading-actions">
				<details class="arttext-tool-menu">
					<summary>Texto (<xsl:value-of select="translate($tlng, 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>)</summary>
					<ul>
						<xsl:choose>
							<xsl:when test="//ARTICLE/@ORIGINALLANG or //ARTICLE/LANGUAGES/ART_TEXT_LANGS/LANG">
								<xsl:for-each select="//ARTICLE/@ORIGINALLANG | //ARTICLE/LANGUAGES/ART_TEXT_LANGS/LANG">
									<li><a href="/scielo.php?script=sci_arttext&amp;pid={//ISSUE/ARTICLE/@PID}&amp;lng={$lang}&amp;nrm=iso&amp;tlng={.}"><xsl:value-of select="translate(., 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/></a></li>
								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise>
								<li><a href="/scielo.php?script=sci_arttext&amp;pid={//ISSUE/ARTICLE/@PID}&amp;lng={$lang}&amp;nrm=iso&amp;tlng={$tlng}"><xsl:value-of select="translate($tlng, 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/></a></li>
							</xsl:otherwise>
						</xsl:choose>
					</ul>
				</details>
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

	<xsl:template name="ARTTEXT_CITATION_LINE">
		<xsl:variable name="docType">
			<xsl:choose>
				<xsl:when test="//ISSUE/ARTICLE/@DOCTYPE='editorial'">Editorial</xsl:when>
				<xsl:when test="//ISSUE/ARTICLE/@DOCTYPE='review'">Revis&#227;o</xsl:when>
				<xsl:otherwise>Artigo</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<div class="arttext-citation-line">
			<span class="arttext-citation-text">
				<xsl:value-of select="$docType"/>
				<xsl:text> &#8226; </xsl:text>
				<xsl:value-of select="//TITLEGROUP/SHORTTITLE" disable-output-escaping="yes"/>
				<xsl:if test="//ISSUE/@VOL">
					<xsl:text> </xsl:text><xsl:value-of select="//ISSUE/@VOL"/>
				</xsl:if>
				<xsl:if test="//ISSUE/@NUM">
					<xsl:text>(</xsl:text><xsl:value-of select="//ISSUE/@NUM"/><xsl:text>)</xsl:text>
				</xsl:if>
				<xsl:if test="//ISSUE/STRIP/YEAR">
					<xsl:text> &#8226; </xsl:text><xsl:value-of select="//ISSUE/STRIP/YEAR"/>
				</xsl:if>
				<xsl:if test="//ISSUE/ARTICLE/@DOI">
					<xsl:text> &#8226; DOI: </xsl:text>
					<a target="_blank">
						<xsl:attribute name="href">https://doi.org/<xsl:value-of select="//ISSUE/ARTICLE/@DOI"/></xsl:attribute>
						<xsl:text>https://doi.org/</xsl:text><xsl:value-of select="//ISSUE/ARTICLE/@DOI"/>
					</a>
				</xsl:if>
			</span>
			<button type="button" class="arttext-copy-citation" data-copy="https://doi.org/{//ISSUE/ARTICLE/@DOI}" aria-label="Copiar DOI">
				<svg viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="M10 13a5 5 0 0 0 7.1 0l2-2a5 5 0 0 0-7.1-7.1l-1.1 1.1"/><path d="M14 11a5 5 0 0 0-7.1 0l-2 2A5 5 0 0 0 12 20.1l1.1-1.1"/></svg>
				<span>copiar</span>
			</button>
		</div>
	</xsl:template>

	<xsl:template name="ARTTEXT_BREADCRUMB">
		<xsl:variable name="lang" select="normalize-space(//CONTROLINFO/LANGUAGE)"/>
		<xsl:variable name="journalPid" select="//ISSN_AS_ID"/>
		<xsl:variable name="issuePid" select="//CURRENTISSUE/@PID"/>
		<xsl:variable name="articlePid" select="//ISSUE/ARTICLE/@PID"/>
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
						<li class="breadcrumb-item">Artigo</li>
					</ol>
					<a class="btn btn-sm btn-secondary scielo__btn-with-icon--only serial-share-btn" href="mailto:?subject={//ISSUE/ARTICLE/citation_title}&amp;body=http://{//CONTROLINFO/SCIELO_INFO/SERVER}/scielo.php?script=sci_arttext%26pid={$articlePid}%26lng={$lang}%26nrm=iso%26tlng={//ISSUE/ARTICLE/@TEXTLANG}" aria-label="Compartilhar">
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

	<xsl:template name="ARTTEXT_UTILS">
		<div class="serial-template-utils arttext-template-utils">
			<a href="mailto:educ@fcc.org.br?subject=Reportar%20erro" class="serial-template-report">Reportar erro</a>
			<a href="#main-content" class="serial-template-accessibility">Acessibilidade</a>
		</div>
	</xsl:template>

	<xsl:template name="ARTTEXT_READING_SCRIPT">
		<script type="text/javascript">
		(function () {
			var root = document.querySelector('.arttext-page');
			if (!root) { return; }
			var article = root.querySelector('.arttext-article-card');
			var nav = root.querySelector('.arttext-reading-nav nav');
			if (!article) { return; }

			function shouldNormalizeAllCapsTitle(value, minLetters) {
				var letters = (value || '').replace(/[^A-Za-zÀ-ÖØ-öø-ÿ]/g, '');
				if (letters.length &lt; (minLetters || 8)) { return false; }
				return /[A-ZÁÀÂÃÄÉÈÊËÍÌÎÏÓÒÔÕÖÚÙÛÜÇÑ]/.test(letters) &amp;&amp; !/[a-záàâãäéèêëíìîïóòôõöúùûüçñ]/.test(letters);
			}

			function restoreTitleAcronyms(value) {
				return value.replace(/\b(apa|bncc|capes|cfc|cnpq|covid|eja|enade|enem|fcc|ideb|ies|inep|libras|ocde|pibic|pisa|pnaic|saeb|tdah|tdic|unesco|ufba|ufmg|ufpe|ufpr|ufrgs|ufrj|ufsc|usp)\b/gi, function (match) {
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

			function normalizeTextElement(element, minLetters) {
				if (!element) { return; }
				var clone = element.cloneNode(true);
				var openAccessIcon = clone.querySelector('.arttext-title-open-access');
				if (openAccessIcon) { openAccessIcon.parentNode.removeChild(openAccessIcon); }
				var value = clone.textContent.replace(/\s+/g, ' ').trim();
				if (!shouldNormalizeAllCapsTitle(value, minLetters)) { return; }
				function normalizeNode(node) {
					if (node.nodeType === 3 &amp;&amp; node.nodeValue.trim()) {
						node.nodeValue = sentenceCaseTitle(node.nodeValue);
						return;
					}
					if (node.nodeType === 1 &amp;&amp; !node.classList.contains('arttext-title-open-access')) {
						Array.prototype.forEach.call(node.childNodes, normalizeNode);
					}
				}
				Array.prototype.forEach.call(element.childNodes, normalizeNode);
			}

			function normalizeArticleSectionHeadings() {
				Array.prototype.forEach.call(article.querySelectorAll('.subsec, .sub-subsec'), function (heading) {
					normalizeTextElement(heading, 3);
				});
			}

			var body = article.querySelector('#article-body') || article.querySelector('[id$="-body"].body') || article.querySelector('.body');
			if (body) { body.setAttribute('id', 'article-body'); }

			function alignBodyTypographyWithAbstract() {
				if (!body) { return; }
				var abstractParagraph = article.querySelector('.trans-abstract p:not(.sec), .abstract p:not(.sec)');
				if (!abstractParagraph || !window.getComputedStyle) { return; }
				var computed = window.getComputedStyle(abstractParagraph);
				Array.prototype.forEach.call(body.querySelectorAll('p:not(.sec):not(.subsec):not(.sub-subsec), p:not(.sec):not(.subsec):not(.sub-subsec) *'), function (node) {
					node.style.fontFamily = computed.fontFamily;
					node.style.fontSize = computed.fontSize;
					node.style.lineHeight = computed.lineHeight;
					node.style.fontWeight = computed.fontWeight;
					node.style.color = computed.color;
				});
			}

			var title = article.querySelector('[class^="index"] .title');
			if (title &amp;&amp; !title.querySelector('.arttext-title-open-access')) {
				var lock = document.createElement('span');
				lock.className = 'arttext-title-open-access';
				lock.setAttribute('title', 'Acesso aberto');
				lock.setAttribute('aria-label', 'Acesso aberto');
				lock.innerHTML = '&lt;svg viewBox="0 0 24 24" aria-hidden="true" focusable="false"&gt;&lt;path d="M7 10V8a5 5 0 0 1 9.5-2.2"&gt;&lt;/path&gt;&lt;rect x="5" y="10" width="14" height="10" rx="2"&gt;&lt;/rect&gt;&lt;path d="M12 14v3"&gt;&lt;/path&gt;&lt;/svg&gt;';
				title.insertBefore(lock, title.firstChild);
			}
			normalizeArticleSectionHeadings();
			alignBodyTypographyWithAbstract();

			var refs = article.querySelector('.ref');
			if (refs) {
				var refWrap = refs.closest('.section') || refs.parentNode;
				if (refWrap &amp;&amp; !refWrap.id) { refWrap.id = 'article-references'; }
			}

			var dates = article.querySelector('.fn-author, .history, .articleDates');
			if (dates) {
				var dateWrap = dates.closest('.section') || dates.parentNode;
				if (dateWrap &amp;&amp; !dateWrap.id) { dateWrap.id = 'article-publication-dates'; }
			}

			var copy = article.querySelector('.arttext-copy-citation');
			if (copy) {
				copy.addEventListener('click', function () {
					var value = copy.getAttribute('data-copy') || '';
					if (!value) { value = article.querySelector('.arttext-citation-text').textContent; }
					if (navigator.clipboard &amp;&amp; navigator.clipboard.writeText) {
						navigator.clipboard.writeText(value);
					}
					copy.textContent = 'Copiado';
					setTimeout(function () { copy.textContent = 'Copiar'; }, 1600);
				});
			}

			if (nav) {
				var links = Array.prototype.slice.call(nav.querySelectorAll('a[href^="#"]'));
				var targets = links.map(function (link) {
					var id = link.getAttribute('href').slice(1);
					return document.getElementById(id);
				});
				function setActive() {
					var active = 0;
					targets.forEach(function (target, index) {
						if (target &amp;&amp; target.getBoundingClientRect().top &lt; 140) { active = index; }
					});
					links.forEach(function (link, index) {
						link.classList.toggle('is-active', index === active);
					});
				}
				window.addEventListener('scroll', setActive, { passive: true });
				setActive();
			}
		}());
		</script>
	</xsl:template>
	
	
</xsl:stylesheet>
