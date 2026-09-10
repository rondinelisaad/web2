<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:include href="sci_navegation.xsl"/>
	<xsl:include href="journalStatus.xsl"/>
	<xsl:variable name="analytics_code" select="//ANALYTICS_CODE"/>
	<xsl:variable name="forceType" select="//CONTROLINFO/ENABLE_FORCETYPE"/>
	<xsl:variable name="ISSN_AS_ID" select="concat(substring-before(/SERIAL/ISSN_AS_ID,'-'),substring-after(/SERIAL/ISSN_AS_ID,'-'))"/>
	<xsl:variable name="show_scimago" select="//show_scimago"/>
	
	<xsl:variable name="scimago_status" select="//scimago_status"/>
	<xsl:variable name="has_article_pr">
		<xsl:choose>
			<xsl:when test="//PRESSRELEASE/article[@prpid != '']">true</xsl:when>
			<xsl:otherwise>false</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="has_issue_pr">
		<xsl:choose>
			<xsl:when test="//PRESSRELEASE/issue[@pid != '']">true</xsl:when>
			<xsl:otherwise>false</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="pref">
		<xsl:choose>
			<xsl:when test="//CONTROLINFO/LANGUAGE='en' ">i</xsl:when>
			<xsl:when test="//CONTROLINFO/LANGUAGE='es' ">e</xsl:when>
			<xsl:when test="//CONTROLINFO/LANGUAGE='pt' ">p</xsl:when>
		</xsl:choose>
	</xsl:variable>
	<xsl:output method="html" indent="no" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/>
	<xsl:template match="SERIAL">
		<html lang="{normalize-space(//CONTROLINFO/LANGUAGE)}">
			<head>
				<title>
					<xsl:value-of select="TITLEGROUP/TITLE" disable-output-escaping="yes"/> - <xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='home_page']"/>
				</title>
				<meta http-equiv="Pragma" content="no-cache"/>
				<meta http-equiv="Expires" content="Mon, 06 Jan 1990 00:00:01 GMT"/>
				<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
				<meta name="viewport" content="width=device-width, initial-scale=1"/>
				<xsl:if test="//NO_SCI_SERIAL='yes'">
					<xsl:variable name="X">http://<xsl:value-of select="//CONTROLINFO/SCIELO_INFO/SERVER"/>
						<xsl:value-of select="//CONTROLINFO/SCIELO_INFO/PATH_DATA"/>scielo.php?script=sci_artlist&amp;pid=<xsl:value-of select="//PAGE_PID"/>&amp;lng=<xsl:value-of select="normalize-space(//CONTROLINFO/LANGUAGE)"/>&amp;nrm=<xsl:value-of select="normalize-space(//CONTROLINFO/STANDARD)"/>
						<xsl:apply-templates select="." mode="repo_url_param"/>
					</xsl:variable>
					<meta HTTP-EQUIV="REFRESH">
						<xsl:attribute name="Content"><xsl:value-of select="concat('0;URL=',$X)"/></xsl:attribute>
					</meta>
				</xsl:if>
				<link rel="STYLESHEET" TYPE="text/css" href="/css/scielo.css"/>
				<link rel="STYLESHEET" TYPE="text/css" href="/css/include_layout.css"/>
				<link rel="STYLESHEET" TYPE="text/css" href="/css/include_styles.css"/>
				<link rel="stylesheet" type="text/css" href="/design-system/1.0.0/css/bootstrap.css"/>
				<link rel="stylesheet" type="text/css" href="/design-system/1.0.0/css/article.css"/>
				<link rel="stylesheet" type="text/css" href="/css/scielo-ds-bridge.css?v=serial-20260614-27"/>
				<!-- link pro RSS aparecer automaticamente no Browser -->
				<xsl:call-template name="AddRssHeaderLink">
					<xsl:with-param name="pid" select="//CURRENT/@PID"/>
					<xsl:with-param name="lang" select="//LANGUAGE"/>
					<xsl:with-param name="server" select="CONTROLINFO/SCIELO_INFO/SERVER"/>
					<xsl:with-param name="script">rss.php</xsl:with-param>
				</xsl:call-template>
				<script type="text/javascript" src="/applications/scielo-org/js/functions.js"/>
				<script type="text/javascript" src="/article.js"/>
				<script type="text/javascript" src="/js/jquery-1.9.1.min.js" />
				<xsl:call-template name="EDUCA_GOOGLE_TAG"/>
			</head>
			<body class="serial-page">
				<xsl:call-template name="ACCESS_SKIP_LINK"/>
				<header class="serial-modern-header">
					<details class="home-main-menu serial-modern-menu">
						<summary class="serial-modern-menu-btn">&#9776; Menu</summary>
						<ul class="home-main-dropdown">
							<li><a href="/search_mvp.php?lang={normalize-space(CONTROLINFO/LANGUAGE)}"><xsl:call-template name="SERIAL_UI_TEXT"><xsl:with-param name="key">search</xsl:with-param></xsl:call-template></a></li>
							<li><a href="/scielo.php?script=sci_alphabetic&amp;lng={normalize-space(CONTROLINFO/LANGUAGE)}&amp;nrm=iso"><xsl:call-template name="SERIAL_UI_TEXT"><xsl:with-param name="key">journal_list</xsl:with-param></xsl:call-template></a></li>
							<li><a href="https://educa.fcc.org.br/metricas/?lang=pt">Métricas e Indicadores</a></li>
							<li><a href="/about/?lang={normalize-space(CONTROLINFO/LANGUAGE)}"><xsl:call-template name="SERIAL_UI_TEXT"><xsl:with-param name="key">about_educa</xsl:with-param></xsl:call-template></a></li>
							<li><a href="/equipe/equipe_p.htm"><xsl:call-template name="SERIAL_UI_TEXT"><xsl:with-param name="key">team_educa</xsl:with-param></xsl:call-template></a></li>
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
								<li><a href="/scielo.php?script=sci_serial&amp;pid={ISSN_AS_ID}&amp;lng=pt&amp;nrm=iso">Português</a></li>
							</xsl:if>
							<xsl:if test="normalize-space(CONTROLINFO/LANGUAGE) != 'en'">
								<li><a href="/scielo.php?script=sci_serial&amp;pid={ISSN_AS_ID}&amp;lng=en&amp;nrm=iso">English</a></li>
							</xsl:if>
							<xsl:if test="normalize-space(CONTROLINFO/LANGUAGE) != 'es'">
								<li><a href="/scielo.php?script=sci_serial&amp;pid={ISSN_AS_ID}&amp;lng=es&amp;nrm=iso">Español</a></li>
							</xsl:if>
						</ul>
					</div>
				</header>
				<xsl:if test="//NO_SCI_SERIAL!='yes' or not(//NO_SCI_SERIAL)">
					<div class="container">
						<main id="main-content" tabindex="-1">
						<h1 class="visually-hidden">
							<xsl:value-of select="TITLEGROUP/TITLE" disable-output-escaping="yes"/>
						</h1>
						<div>
							<xsl:attribute name="class">
								<xsl:text>middle</xsl:text>
								<xsl:choose>
									<xsl:when test="($has_issue_pr = 'false') and ($has_article_pr = 'false')">
										<xsl:text> no-right-col</xsl:text>
									</xsl:when>
									<xsl:otherwise>
										<xsl:text> has-right-col</xsl:text>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
							<!--
                                monta as divs: leftCol e mainContent
                            -->
							<xsl:apply-templates select="CONTROLINFO">
								<xsl:with-param name="YEAR" select="substring(@LASTUPDT,1,4)"/>
								<xsl:with-param name="MONTH" select="substring(@LASTUPDT,5,2)"/>
								<xsl:with-param name="DAY" select="substring(@LASTUPDT,7,2)"/>
							</xsl:apply-templates>
							<!--
                                monta a div: rightCol
                            -->
							<xsl:choose>
								<xsl:when test="$journal_manager='1'">
									<div class="rightCol" style="display: none;" id="rightCol">
										<h2 class="sectionHeading">
											<xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='press_releases']"/>
										</h2>
										<span id="pr_issue_area" style="display: none;">
											<strong>
												<xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='numbers']"/>
											</strong>
											<span class="PressReleases" id="issuePressRelease"></span>
										</span>
										<span id="pr_article_area" style="display: none;">
											<strong>
												<xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='articles']"/>
											</strong>
											<span class="PressReleases" id="articlePressRelease"></span>
										</span>
									</div>
								</xsl:when>
								<xsl:otherwise>
									<div class="rightCol">
										<xsl:if test="($has_issue_pr = 'false') and ($has_article_pr = 'false')">
											<xsl:attribute name="style">display: none;</xsl:attribute>
										</xsl:if>
										<h2 class="sectionHeading">
											<xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='press_releases']"/>
										</h2>
										<xsl:if test="$has_issue_pr != 'false'">
											<strong>
												<xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='numbers']"/>
											</strong>
											<ul class="pressReleases">
												<xsl:apply-templates select="//PRESSRELEASE/issue" mode="pr">
													<xsl:sort select="@data" order="descending"/>
												</xsl:apply-templates>
											</ul>
										</xsl:if>
										<xsl:if test="$has_article_pr != 'false'">
											<strong>
												<xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='articles']"/>
											</strong>
											<ul class="pressReleases">
												<xsl:apply-templates select="//PRESSRELEASE/article" mode="pr">
													<xsl:sort select="@data" order="descending"/>
												</xsl:apply-templates>
											</ul>
										</xsl:if>
									</div>
								</xsl:otherwise>
							</xsl:choose>
							
						</div>
						<div class="spacer">&#160;</div>
						</main>
						<!--
                            monta a div: footer
                        -->
						<xsl:apply-templates select="." mode="footer-journal"/>

					</div>
				</xsl:if>
				<xsl:if test="$journal_manager=1">
				  <script type="text/javascript">
				  var lng = '<xsl:value-of select="CONTROLINFO/LANGUAGE"/>';
				  var pid = '<xsl:value-of select="//PAGE_PID"/>';
				  function qry_prs() {
				    var url = "pressrelease/pressreleases_from_pid.php?lng="+lng+"&amp;pid="+pid;
				    $.ajax({
				      url: url,
				      success: function (data) {
				      	jdata = jQuery.parseJSON(data);

				      	if (jdata['issue'].length > 0 || jdata['article'].length > 0) {
				      		$("#rightCol").show();
				      	}
				      	if (jdata['issue'].length > 0){
				      		$("#pr_issue_area").show();
				      	}
				      	if (jdata['article'].length > 0){
				      		$("#pr_article_area").show();
				      	}
				      	var issue_html = '<ul class="PressReleases" style="padding-left: 20px; margin-left: 0px;">';
				      	for (var item in jdata['issue']){
				      	    var pr_url = 'pressrelease/pressrelease_display.php?lng='+lng+'&amp;id='+jdata['issue'][item]['id']+'&amp;pid='+jdata['issue'][item]['pid'];
				      		issue_html += '<li><a href="'+pr_url+'"><b>'
				      		           +jdata['issue'][item]['issue_label']
				      		           +'</b><br/>'
				      		           +jdata['issue'][item]['title']
				      		           +'</a></li>';
				      	}
				      	issue_html += '</ul>';

				      	var article_html = '<ul class="PressReleases" style="padding-left: 20px; margin-left: 0px;">';
				      	for (var item in jdata['article']){
				      		var pr_url = 'pressrelease/pressrelease_display.php?lng='+lng+'&amp;id='+jdata['article'][item]['id']+'&amp;pid='+jdata['article'][item]['pid'];
				      		article_html += '<li><a href="'+pr_url+'"> <b>'
				      					 +jdata['article'][item]['issue_label']
				      					 +'</b><br/> '
				      					 +jdata['article'][item]['title']
				      					 +'</a></li>';
				      	}
				      	article_html += '</ul>';

				      	$("#issuePressRelease").html(issue_html);
				      	$("#articlePressRelease").html(article_html);
				      }
				    });
				  }
				  $(document).ready(function() {
				      qry_prs();
				  });
				</script>
			</xsl:if>
			</body>
		</html>
	</xsl:template>
	<!--
press release do issue
-->
	<xsl:template match="issue" mode="pr">
		<xsl:variable name="supl">
			<xsl:value-of select="string-length(normalize-space(@sup))"/>
		</xsl:variable>
		<xsl:variable name="voll">
			<xsl:value-of select="string-length(normalize-space(@vol))"/>
		</xsl:variable>
		<xsl:variable name="numl">
			<xsl:value-of select="string-length(normalize-space(@num))"/>
		</xsl:variable>
		<xsl:variable name="year" select="substring(@data,1,4)"/>
		<xsl:variable name="month" select="substring(@data,5,2)"/>
		<xsl:variable name="day" select="substring(@data,7,2)"/>
		<xsl:variable name="currlang" select="//CONTROLINFO/LANGUAGE"/>
		<li>
			<a href="javascript:void();" onClick="OpenArticleInfoWindow(850,500,'/scielo.php?script=sci_arttext_pr&amp;pid={@pid}&amp;lng={$currlang}&amp;nrm=iso&amp;tlng={@lang}');">
				<strong>
					<xsl:if test="$currlang='pt'">
						<xsl:value-of select="concat($month,'/',$year)"/>
					</xsl:if>
					<xsl:if test="$currlang='es'">
						<xsl:value-of select="concat($month,'/',$year)"/>
					</xsl:if>
					<xsl:if test="$currlang='en'">
						<xsl:value-of select="concat($year,'/',$month)"/>
					</xsl:if>
     -
    <xsl:if test="$voll != 0">v<xsl:value-of select="@vol"/>&#160;</xsl:if>
					<xsl:if test="$numl != 0">n.<xsl:value-of select="@num"/>&#160;</xsl:if>
					<xsl:if test="$supl != 0">s.<xsl:value-of select="@sup"/>
					</xsl:if>
				</strong>
				<span>
					<xsl:value-of select="title"/>
				</span>
			</a>
		</li>
	</xsl:template>
	<!--
press release do artigo
-->
	<xsl:template match="article" mode="pr">
		<xsl:variable name="supl">
			<xsl:value-of select="string-length(normalize-space(@sup))"/>
		</xsl:variable>
		<xsl:variable name="voll">
			<xsl:value-of select="string-length(normalize-space(@vol))"/>
		</xsl:variable>
		<xsl:variable name="numl">
			<xsl:value-of select="string-length(normalize-space(@num))"/>
		</xsl:variable>
		<xsl:variable name="year" select="substring(@data,1,4)"/>
		<xsl:variable name="month" select="substring(@data,5,2)"/>
		<xsl:variable name="day" select="substring(@data,7,2)"/>
		<xsl:variable name="currlang" select="//CONTROLINFO/LANGUAGE"/>
		<li>
			<a href="javascript:void();" onClick="OpenArticleInfoWindow(850,500,'/scielo.php?script=sci_arttext_pr&amp;pid={@prpid}&amp;lng={$currlang}&amp;nrm=iso&amp;tlng={title/@lang}');">
				<strong>
					<xsl:if test="$currlang='pt'">
						<xsl:value-of select="concat($month,'/',$year)"/>
					</xsl:if>
					<xsl:if test="$currlang='es'">
						<xsl:value-of select="concat($month,'/',$year)"/>
					</xsl:if>
					<xsl:if test="$currlang='en'">
						<xsl:value-of select="concat($year,'/',$month)"/>
					</xsl:if>
    -
    <xsl:if test="$voll != 0">v<xsl:value-of select="@vol"/>&#160;</xsl:if>
					<xsl:if test="$numl != 0">n.<xsl:value-of select="@num"/>&#160;</xsl:if>
					<xsl:if test="$supl != 0">s.<xsl:value-of select="@sup"/>
					</xsl:if>
				</strong>
				<span>
					<xsl:value-of select="title"/>
				</span>
			</a>
		</li>
	</xsl:template>
	<!--
        nome do publicador
    -->
	<xsl:template match="PUBLISHER">
		<xsl:value-of select="NAME" disable-output-escaping="yes"/>
		<br/>
	</xsl:template>
	<!--
        missao da revista
    -->
	<xsl:template match="MISSION">
		<font color="#000080">
			<xsl:value-of select="." disable-output-escaping="yes"/>
			<br/>
		</font>
		<br/>
	</xsl:template>
	<!--
		links dos idiomas da interface
	-->
	<xsl:template match="CONTROLINFO" mode="change-language">
		<br/>
		<xsl:if test="//CONTROLINFO/LANGUAGE != 'pt'">
			<a>
				<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER"/><xsl:value-of select="SCIELO_INFO/PATH_DATA"/>scielo.php?script=<xsl:value-of select="//PAGE_NAME"/>&amp;pid=<xsl:value-of select="//PAGE_PID"/>&amp;lng=pt&amp;nrm=iso</xsl:attribute>
				<font class="linkado" size="-1">
					<xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='portuguese']"/>
				</font>
			</a>
			<br/>
		</xsl:if>
		<xsl:if test="//CONTROLINFO/LANGUAGE != 'en'">
			<a>
				<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER"/><xsl:value-of select="SCIELO_INFO/PATH_DATA"/>scielo.php?script=<xsl:value-of select="//PAGE_NAME"/>&amp;pid=<xsl:value-of select="//PAGE_PID"/>&amp;lng=en&amp;nrm=iso</xsl:attribute>
				<font class="linkado" size="-1">
					<xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='english']"/>
				</font>
			</a>
			<br/>
		</xsl:if>
		<xsl:if test="//CONTROLINFO/LANGUAGE != 'es'">
			<a>
				<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER"/><xsl:value-of select="SCIELO_INFO/PATH_DATA"/>scielo.php?script=<xsl:value-of select="//PAGE_NAME"/>&amp;pid=<xsl:value-of select="//PAGE_PID"/>&amp;lng=es&amp;nrm=iso</xsl:attribute>
				<font class="linkado" size="-1">
					<xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='spanish']"/>
				</font>
			</a>
			<br/>
		</xsl:if>
	</xsl:template>
	<!--
		formacao do link de pagina secundaria
	-->
	<xsl:template match="CONTROLINFO" mode="link_to_secondary_page">
		<xsl:param name="itemName"/>
		<xsl:param name="itemName2"/>
		<xsl:param name="label"/>
		<li>
			<a>
				<xsl:attribute name="href">http://<xsl:value-of select="SCIELO_INFO/SERVER"/><xsl:value-of select="SCIELO_INFO/PATH_SERIAL_HTML"/><xsl:value-of select="/SERIAL/TITLEGROUP/SIGLUM"/>/<xsl:value-of select="$pref"/><xsl:if test="$itemName2"><xsl:value-of select="$itemName2"/></xsl:if><xsl:if test="not($itemName2)"><xsl:value-of select="$itemName"/></xsl:if>.htm</xsl:attribute>
				<xsl:value-of select="$label"/>
			</a>
		</li>
	</xsl:template>
	<!--
		formacao dos links das paginas secundarias
	-->
	<xsl:template match="CONTROLINFO" mode="links">
		<ul class="contextMenu">
			<!--link de submissao-->
			<xsl:apply-templates select="..//link"/>
			<xsl:apply-templates select="." mode="link_to_secondary_page">
				<xsl:with-param name="itemName" select="'aboutj'"/>
				<xsl:with-param name="label">
					<xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='about_the_journal']"/>
				</xsl:with-param>
			</xsl:apply-templates>
			<xsl:apply-templates select="." mode="link_to_secondary_page">
				<xsl:with-param name="itemName" select="'edboard'"/>
				<xsl:with-param name="label">
					<xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='editorial_board']"/>
				</xsl:with-param>
			</xsl:apply-templates>
			<xsl:apply-templates select="." mode="link_to_secondary_page">
				<xsl:with-param name="itemName" select="'instruc'"/>
				<xsl:with-param name="label">
					<xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='instructions_to_authors']"/>
				</xsl:with-param>
			</xsl:apply-templates>
			<xsl:if test=" ENABLE_STAT_LINK = 1 or ENABLE_CIT_REP_LINK = 1 ">
				<li>
    				<strong><xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='statistics']"/></strong>
	                <ul>
                        <li>
                            <a href="{SCIELO_INFO/SERVER_SCIELO}/statjournal.php?lang={LANGUAGE}&amp;issn={/SERIAL/ISSN_AS_ID}&amp;collection={$analytics_code}">SciELO</a>
                        </li>

                        <!-- monta o grafico scimago -->
                        <xsl:variable name="graphMago" select="document('../scimago/scimago.xml')/SCIMAGOLIST/title[@ISSN = $ISSN_AS_ID]/@SCIMAGO_ID"/>
                        <xsl:if test="$show_scimago!=0 and normalize-space($scimago_status) = normalize-space('online')">
                            <xsl:if test="$graphMago">
                                <li> 
                                    <strong>
                                        <a>
                                            <xsl:attribute name="href">http://www.scimagojr.com/journalsearch.php?q=<xsl:value-of select="$graphMago"/>&amp;tip=sid&amp;clean=0</xsl:attribute>
                                            <xsl:attribute name="target">_blank</xsl:attribute>
                                            Scimago    
                                        </a>
                                    </strong>
                                    <a>
                                        <xsl:attribute name="href">http://www.scimagojr.com/journalsearch.php?q=<xsl:value-of select="$graphMago"/>&amp;tip=sid&amp;clean=0</xsl:attribute>
                                        <xsl:attribute name="target">_blank</xsl:attribute>
                                        <img>
                                            <xsl:attribute name="src">http://www.scimagojr.com/journal_img.php?id=<xsl:value-of select="$graphMago"/></xsl:attribute>
                                            <xsl:attribute name="alt"><xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='scimago_journal_country_rank']"/></xsl:attribute>
                                            <xsl:attribute name="border">0</xsl:attribute>
                                            <xsl:attribute name="width">185</xsl:attribute>
                                        </img>
                                    </a>
                                </li>
                            </xsl:if>
                        </xsl:if>                           

                        <!-- google analytics metrics -->
                        <div id="google_metrics" style="display:none; margin-top: 10px;">
                            <li>                
                                <div style="margin-bottom: 5px">
                                    <a href="#" id="h5_m5_link" target="_blank"><xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='google_scholar_metrics']"/></a>
                                </div>
                                <div id="google_metrics_years">
                                </div>
                            </li>
				                    <!-- display google scholar metrics (h5 e m5 index) -->
				                    <script type="text/javascript">    
								              $(document).ready(function() {
								                  var url =  "/google_metrics/get_h5_m5.php?issn=<xsl:value-of select="//SERIAL/ISSN_AS_ID"/>&amp;callback=?";
								                  $.getJSON(url,  function(data) {
								                  		var url_h5m5 = data['url']
					                        		var text_h5 =  '<xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='google_scholar_h5_index']"/>';
					                        		var text_m5 = '<xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='google_scholar_m5_index']"/>';
					                        		html_data ='<div><strong>'+data['year']+'</strong></div>';
					                            html_data +='<div><strong>'+text_h5+':</strong> '+data['h5']+'</div>';
					                            html_data +='<div><strong>'+text_m5+':</strong> '+data['m5']+'</div>';
																			html_data +='<div style="margin-top: 5px"><a href="'+url_h5m5+'" id="h5_m5_see_more" target="_blank"><xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find='more_details']"/></a></div>';
					                            $("#google_metrics_years").html(html_data);
								                      $("#google_metrics").show();
								                  });
								              });
				                    </script>
                        </div>
                    </ul>
				</li>
			</xsl:if>
		</ul>
	</xsl:template>
	<!--
        submissao online
    -->
	<xsl:template name="SERIAL_UI_TEXT">
		<xsl:param name="key"/>
		<xsl:param name="lang" select="normalize-space(/SERIAL/CONTROLINFO/LANGUAGE)"/>
		<xsl:choose>
			<xsl:when test="$key='search'"><xsl:choose><xsl:when test="$lang='en'">Search</xsl:when><xsl:when test="$lang='es'">Búsqueda</xsl:when><xsl:otherwise>Pesquisa</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='journal_list'"><xsl:choose><xsl:when test="$lang='en'">Journal list</xsl:when><xsl:when test="$lang='es'">Lista de revistas</xsl:when><xsl:otherwise>Lista de periódicos</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='about_educa'"><xsl:choose><xsl:when test="$lang='en'">About Educ@</xsl:when><xsl:when test="$lang='es'">Acerca de Educ@</xsl:when><xsl:otherwise>Sobre o Educ@</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='team_educa'"><xsl:choose><xsl:when test="$lang='en'">Educ@ Team</xsl:when><xsl:when test="$lang='es'">Equipo Educ@</xsl:when><xsl:otherwise>Equipe Educ@</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='published_by'"><xsl:choose><xsl:when test="$lang='en'">Published by:</xsl:when><xsl:when test="$lang='es'">Publicación de:</xsl:when><xsl:otherwise>Publicação de:</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='area'"><xsl:choose><xsl:when test="$lang='en'">Area:</xsl:when><xsl:when test="$lang='es'">Área:</xsl:when><xsl:otherwise>Área:</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='print_issn'"><xsl:choose><xsl:when test="$lang='en'">Print version ISSN:</xsl:when><xsl:when test="$lang='es'">Versión impresa ISSN:</xsl:when><xsl:otherwise>Versão impressa ISSN:</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='online_issn'"><xsl:choose><xsl:when test="$lang='en'">Online version ISSN:</xsl:when><xsl:when test="$lang='es'">Versión en línea ISSN:</xsl:when><xsl:otherwise>Versão on-line ISSN:</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='online_submission'"><xsl:choose><xsl:when test="$lang='en'">Manuscript submission</xsl:when><xsl:when test="$lang='es'">Envío de manuscritos</xsl:when><xsl:otherwise>Submissão de manuscritos</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='journal_site'"><xsl:choose><xsl:when test="$lang='en'">Journal website</xsl:when><xsl:when test="$lang='es'">Sitio de la revista</xsl:when><xsl:otherwise>Site do periódico</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='about_journal'"><xsl:choose><xsl:when test="$lang='en'">About the journal</xsl:when><xsl:when test="$lang='es'">Acerca de la revista</xsl:when><xsl:otherwise>Sobre o periódico</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='editorial_policy'"><xsl:choose><xsl:when test="$lang='en'">Editorial policy</xsl:when><xsl:when test="$lang='es'">Política editorial</xsl:when><xsl:otherwise>Política editorial</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='editorial_board'"><xsl:choose><xsl:when test="$lang='en'">Editorial Board</xsl:when><xsl:when test="$lang='es'">Comité editorial</xsl:when><xsl:otherwise>Corpo Editorial</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='instructions'"><xsl:choose><xsl:when test="$lang='en'">Instructions to authors</xsl:when><xsl:when test="$lang='es'">Instrucciones a los autores</xsl:when><xsl:otherwise>Instruções aos autores</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='contact'"><xsl:choose><xsl:when test="$lang='en'">Contact</xsl:when><xsl:when test="$lang='es'">Contacto</xsl:when><xsl:otherwise>Contato</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='journal_home'"><xsl:choose><xsl:when test="$lang='en'">Journal home</xsl:when><xsl:when test="$lang='es'">Home de la revista</xsl:when><xsl:otherwise>Home do periódico</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='all_issues'"><xsl:choose><xsl:when test="$lang='en'">All issues</xsl:when><xsl:when test="$lang='es'">Todos los números</xsl:when><xsl:otherwise>Todos os números</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='previous_issue'"><xsl:choose><xsl:when test="$lang='en'">Previous issue</xsl:when><xsl:when test="$lang='es'">Número anterior</xsl:when><xsl:otherwise>Número anterior</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='next_issue'"><xsl:choose><xsl:when test="$lang='en'">Next issue</xsl:when><xsl:when test="$lang='es'">Número siguiente</xsl:when><xsl:otherwise>Número seguinte</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='current_issue'"><xsl:choose><xsl:when test="$lang='en'">Current issue</xsl:when><xsl:when test="$lang='es'">Número actual</xsl:when><xsl:otherwise>Número atual</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='metrics'"><xsl:choose><xsl:when test="$lang='en'">Metrics</xsl:when><xsl:when test="$lang='es'">Métricas</xsl:when><xsl:otherwise>Métricas</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='journals'"><xsl:choose><xsl:when test="$lang='en'">Journals</xsl:when><xsl:when test="$lang='es'">Revistas</xsl:when><xsl:otherwise>Periódicos</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='mission'"><xsl:choose><xsl:when test="$lang='en'">Our Mission</xsl:when><xsl:when test="$lang='es'">Nuestra Misión</xsl:when><xsl:otherwise>Nossa Missão</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='latest_issue'"><xsl:choose><xsl:when test="$lang='en'">Most recent issue</xsl:when><xsl:when test="$lang='es'">Número más reciente</xsl:when><xsl:otherwise>Número mais recente</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='not_available'"><xsl:choose><xsl:when test="$lang='en'">Not available</xsl:when><xsl:when test="$lang='es'">No disponible</xsl:when><xsl:otherwise>Não disponível</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='latest_articles'"><xsl:choose><xsl:when test="$lang='en'">Latest articles</xsl:when><xsl:when test="$lang='es'">Artículos más recientes</xsl:when><xsl:otherwise>Artigos mais recentes</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='previous_articles'"><xsl:choose><xsl:when test="$lang='en'">Previous articles</xsl:when><xsl:when test="$lang='es'">Artículos anteriores</xsl:when><xsl:otherwise>Artigos anteriores</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='next_articles'"><xsl:choose><xsl:when test="$lang='en'">Next articles</xsl:when><xsl:when test="$lang='es'">Próximos artículos</xsl:when><xsl:otherwise>Próximos artigos</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='loading_articles'"><xsl:choose><xsl:when test="$lang='en'">Loading latest articles...</xsl:when><xsl:when test="$lang='es'">Cargando artículos recientes...</xsl:when><xsl:otherwise>Carregando artigos recentes...</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='read_more'"><xsl:choose><xsl:when test="$lang='en'">Read more</xsl:when><xsl:when test="$lang='es'">Continuar leyendo</xsl:when><xsl:otherwise>Continue lendo</xsl:otherwise></xsl:choose></xsl:when>
			<xsl:when test="$key='view_current_issue_articles'"><xsl:choose><xsl:when test="$lang='en'">View articles published in the current issue</xsl:when><xsl:when test="$lang='es'">Ver artículos publicados en el número actual</xsl:when><xsl:otherwise>Ver artigos publicados no número atual</xsl:otherwise></xsl:choose></xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="link" mode="modern-action">
		<xsl:variable name="t" select="@type"/>
		<a class="list-group-item" href="{.}" target="_blank" rel="noopener noreferrer">
			<svg class="journal-side-icon" viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="M8 8h-3v11h11v-3"/><path d="M13 5h6v6"/><path d="M11 13l8-8"/></svg>
			<xsl:choose>
				<xsl:when test="$t='online_submission'"><xsl:call-template name="SERIAL_UI_TEXT"><xsl:with-param name="key">online_submission</xsl:with-param></xsl:call-template></xsl:when>
				<xsl:when test="$t='journal_site'"><xsl:call-template name="SERIAL_UI_TEXT"><xsl:with-param name="key">journal_site</xsl:with-param></xsl:call-template></xsl:when>
				<xsl:otherwise><xsl:value-of select="@label"/></xsl:otherwise>
			</xsl:choose>
		</a>
	</xsl:template>

	<xsl:template match="link">
		<xsl:variable name="t" select="@type"/>
		<xsl:variable name="label">
			<xsl:value-of select="$translations/xslid[@id='sci_serial']/text[@find=$t]"/><xsl:value-of select="@label"/>
		</xsl:variable>
		<xsl:if test="$label!=''">
			<li>
				<xsl:if test="$t='online_submission'">
					<xsl:attribute name="id">btn_submission</xsl:attribute>
				</xsl:if>
				<a href="{.}" target="{$t}">
					<xsl:if test="$t != 'online_submission'">
						<xsl:value-of select="$label"/>
					</xsl:if>
				</a>
				<br/>
			</li>
		</xsl:if>
	</xsl:template>
	<!--
		textos traduzidos
	-->
	<!-- 
	CONTROLINFO
	-->
	<xsl:template match="CONTROLINFO">
		<xsl:param name="YEAR"/>
		<xsl:param name="MONTH"/>
		<xsl:param name="DAY"/>
		<xsl:variable name="journalHome" select="concat('/scielo.php?script=sci_serial&amp;pid=', /SERIAL/ISSN_AS_ID, '&amp;lng=', normalize-space(LANGUAGE), '&amp;nrm=iso')"/>
		<xsl:variable name="issuesUrl" select="concat('/scielo.php?script=sci_issues&amp;pid=', /SERIAL/ISSN_AS_ID, '&amp;lng=', normalize-space(LANGUAGE), '&amp;nrm=iso')"/>
		<section class="d-block journalInfo">
			<div class="container">
				<div class="row">
					<div class="col-12 col-lg-9 pt-4 pb-4">
						<a href="{$journalHome}" class="journalInfo-logo-link">
							<xsl:call-template name="ImageLogo">
								<xsl:with-param name="src">
									<xsl:value-of select="SCIELO_INFO/PATH_SERIMG"/>
									<xsl:value-of select="/SERIAL/TITLEGROUP/SIGLUM"/>/glogo.gif</xsl:with-param>
								<xsl:with-param name="alt">
									<xsl:value-of select="/SERIAL/TITLEGROUP/TITLE" disable-output-escaping="yes"/>
								</xsl:with-param>
							</xsl:call-template>
						</a>
						<h1 class="h4">
							<img src="/design-system/1.0.0/img/logo-open-access.svg" alt="Open-access" class="logo-open-access"/>
							<xsl:value-of select="/SERIAL/TITLEGROUP/TITLE" disable-output-escaping="yes"/>
						</h1>
						<span class="publisher">
							<xsl:call-template name="SERIAL_UI_TEXT"><xsl:with-param name="key">published_by</xsl:with-param></xsl:call-template>
							<xsl:text> </xsl:text>
							<strong class="namePlublisher"><xsl:value-of select="/SERIAL/PUBLISHERS/PUBLISHER/NAME" disable-output-escaping="yes"/></strong>
						</span>
						<br/>
						<span class="theme">
							<span class="area"><xsl:call-template name="SERIAL_UI_TEXT"><xsl:with-param name="key">area</xsl:with-param></xsl:call-template></span>
							<xsl:text> </xsl:text>
							<xsl:value-of select="/SERIAL/TITLEGROUP/SUBJECT" disable-output-escaping="yes"/>
						</span>
						<span class="issn">
							<xsl:for-each select="/SERIAL/TITLE_ISSN">
								<div>
									<span class="issnLabel">
										<xsl:choose>
											<xsl:when test="@TYPE='PRINT'"><xsl:call-template name="SERIAL_UI_TEXT"><xsl:with-param name="key">print_issn</xsl:with-param></xsl:call-template></xsl:when>
											<xsl:otherwise><xsl:call-template name="SERIAL_UI_TEXT"><xsl:with-param name="key">online_issn</xsl:with-param></xsl:call-template></xsl:otherwise>
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
							<xsl:apply-templates select="/SERIAL/link[@type='online_submission']" mode="modern-action"/>
							<xsl:apply-templates select="/SERIAL/link[@type='journal_site']" mode="modern-action"/>
							<a class="list-group-item" href="/revistas/{/SERIAL/TITLEGROUP/SIGLUM}/{$pref}aboutj.htm"><svg class="journal-side-icon" viewBox="0 0 24 24" aria-hidden="true" focusable="false"><circle cx="12" cy="12" r="9"/><path d="M12 10v6"/><path d="M12 7h.01"/></svg> <xsl:call-template name="SERIAL_UI_TEXT"><xsl:with-param name="key">about_journal</xsl:with-param></xsl:call-template></a>
							<a class="list-group-item" href="/revistas/{/SERIAL/TITLEGROUP/SIGLUM}/{$pref}edboard.htm"><svg class="journal-side-icon" viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg> <xsl:call-template name="SERIAL_UI_TEXT"><xsl:with-param name="key">editorial_board</xsl:with-param></xsl:call-template></a>
							<a class="list-group-item" href="/revistas/{/SERIAL/TITLEGROUP/SIGLUM}/{$pref}instruc.htm"><svg class="journal-side-icon" viewBox="0 0 24 24" aria-hidden="true" focusable="false"><circle cx="12" cy="12" r="9"/><path d="M9.5 9a2.7 2.7 0 1 1 4.8 1.7c-.9.7-1.5 1.2-1.8 2.3"/><path d="M12 17h.01"/></svg> <xsl:call-template name="SERIAL_UI_TEXT"><xsl:with-param name="key">instructions</xsl:with-param></xsl:call-template></a>
							<xsl:if test="/SERIAL/CONTACT/EMAILS/EMAIL">
								<a class="list-group-item" href="mailto:{/SERIAL/CONTACT/EMAILS/EMAIL[1]}"><svg class="journal-side-icon" viewBox="0 0 24 24" aria-hidden="true" focusable="false"><rect x="3" y="5" width="18" height="14" rx="2"/><path d="M3 7l9 6 9-6"/></svg> <xsl:call-template name="SERIAL_UI_TEXT"><xsl:with-param name="key">contact</xsl:with-param></xsl:call-template></a>
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
						<a href="{$journalHome}" class="btn scielo__btn-with-icon--left selected">
							<svg class="serial-home-icon" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
								<path d="M10 20v-6h4v6h5v-8h3L12 3 2 12h3v8z"/>
							</svg>
							<xsl:call-template name="SERIAL_UI_TEXT"><xsl:with-param name="key">journal_home</xsl:with-param></xsl:call-template>
						</a>
					</div>
					<div class="col-md-8 col-sm-8 serial-level-issues">
						<div class="btn-group">
							<a href="{$issuesUrl}" class="btn"><xsl:call-template name="SERIAL_UI_TEXT"><xsl:with-param name="key">all_issues</xsl:with-param></xsl:call-template></a>
							<xsl:choose>
								<xsl:when test="//PREVIOUS/@PID">
									<a href="/scielo.php?script=sci_issuetoc&amp;pid={//PREVIOUS/@PID}&amp;lng={normalize-space(LANGUAGE)}&amp;nrm=iso" class="btn">
										<xsl:attribute name="title"><xsl:call-template name="SERIAL_UI_TEXT"><xsl:with-param name="key">previous_issue</xsl:with-param></xsl:call-template></xsl:attribute>
										<xsl:text>&#171; </xsl:text><xsl:call-template name="SERIAL_UI_TEXT"><xsl:with-param name="key">previous_issue</xsl:with-param></xsl:call-template>
									</a>
								</xsl:when>
								<xsl:otherwise><a href="#" class="btn disabled"><xsl:attribute name="title"><xsl:call-template name="SERIAL_UI_TEXT"><xsl:with-param name="key">previous_issue</xsl:with-param></xsl:call-template></xsl:attribute><xsl:text>&#171; </xsl:text><xsl:call-template name="SERIAL_UI_TEXT"><xsl:with-param name="key">previous_issue</xsl:with-param></xsl:call-template></a></xsl:otherwise>
							</xsl:choose>
							<xsl:choose>
								<xsl:when test="//NEXT/@PID">
									<a href="/scielo.php?script=sci_issuetoc&amp;pid={//NEXT/@PID}&amp;lng={normalize-space(LANGUAGE)}&amp;nrm=iso" class="btn">
										<xsl:attribute name="title"><xsl:call-template name="SERIAL_UI_TEXT"><xsl:with-param name="key">next_issue</xsl:with-param></xsl:call-template></xsl:attribute>
										<xsl:call-template name="SERIAL_UI_TEXT"><xsl:with-param name="key">next_issue</xsl:with-param></xsl:call-template><xsl:text> &#187;</xsl:text>
									</a>
								</xsl:when>
								<xsl:otherwise><a href="#" class="btn disabled"><xsl:attribute name="title"><xsl:call-template name="SERIAL_UI_TEXT"><xsl:with-param name="key">next_issue</xsl:with-param></xsl:call-template></xsl:attribute><xsl:call-template name="SERIAL_UI_TEXT"><xsl:with-param name="key">next_issue</xsl:with-param></xsl:call-template><xsl:text> &#187;</xsl:text></a></xsl:otherwise>
							</xsl:choose>
							<xsl:if test="ISSUES/CURRENT/@PID">
								<a href="/scielo.php?script=sci_issuetoc&amp;pid={ISSUES/CURRENT/@PID}&amp;lng={normalize-space(LANGUAGE)}&amp;nrm=iso" class="btn active unselected">
									<xsl:attribute name="title"><xsl:call-template name="SERIAL_UI_TEXT"><xsl:with-param name="key">current_issue</xsl:with-param></xsl:call-template></xsl:attribute>
									<xsl:call-template name="SERIAL_UI_TEXT"><xsl:with-param name="key">current_issue</xsl:with-param></xsl:call-template>
								</a>
							</xsl:if>
						</div>
					</div>
					<div class="col-md-2 col-sm-2 text-end serial-level-tools">
						<div class="btn-group" role="group">
							<xsl:attribute name="aria-label"><xsl:call-template name="SERIAL_UI_TEXT"><xsl:with-param name="key">search</xsl:with-param></xsl:call-template></xsl:attribute>
							<a href="/search_mvp.php?lang={normalize-space(LANGUAGE)}&amp;journal={/SERIAL/ISSN_AS_ID}" class="btn single"><xsl:call-template name="SERIAL_UI_TEXT"><xsl:with-param name="key">search</xsl:with-param></xsl:call-template></a>
							<a href="https://educa.fcc.org.br/metricas/?lang=pt" class="btn scielo__btn-with-icon--left"><xsl:call-template name="SERIAL_UI_TEXT"><xsl:with-param name="key">metrics</xsl:with-param></xsl:call-template></a>
						</div>
					</div>
				</div>
			</div>
			<div class="container d-xl-none">
				<div class="row">
					<div class="col">
						<div class="btn-group mobile-main">
							<a href="{$journalHome}" class="btn btn-secondary scielo__btn-with-icon--only selected">
								<svg class="serial-home-icon" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
									<path d="M10 20v-6h4v6h5v-8h3L12 3 2 12h3v8z"/>
								</svg>
							</a>
							<a href="{$issuesUrl}" class="btn btn-secondary"><xsl:call-template name="SERIAL_UI_TEXT"><xsl:with-param name="key">all_issues</xsl:with-param></xsl:call-template></a>
							<a href="/search_mvp.php?lang={normalize-space(LANGUAGE)}&amp;journal={/SERIAL/ISSN_AS_ID}" class="btn btn-secondary"><xsl:call-template name="SERIAL_UI_TEXT"><xsl:with-param name="key">search</xsl:with-param></xsl:call-template></a>
							<a href="https://educa.fcc.org.br/metricas/?lang=pt" class="btn btn-secondary"><xsl:call-template name="SERIAL_UI_TEXT"><xsl:with-param name="key">metrics</xsl:with-param></xsl:call-template></a>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col">
						<div class="btn-group mobile-issues">
							<xsl:choose>
								<xsl:when test="//PREVIOUS/@PID">
									<a href="/scielo.php?script=sci_issuetoc&amp;pid={//PREVIOUS/@PID}&amp;lng={normalize-space(LANGUAGE)}&amp;nrm=iso" class="btn btn-secondary scielo__btn-with-icon--only"><xsl:attribute name="title"><xsl:call-template name="SERIAL_UI_TEXT"><xsl:with-param name="key">previous_issue</xsl:with-param></xsl:call-template></xsl:attribute><span class="material-icons-outlined">&#8249;</span></a>
								</xsl:when>
								<xsl:otherwise><a href="#" class="btn btn-secondary scielo__btn-with-icon--only disabled"><xsl:attribute name="title"><xsl:call-template name="SERIAL_UI_TEXT"><xsl:with-param name="key">previous_issue</xsl:with-param></xsl:call-template></xsl:attribute><span class="material-icons-outlined">&#8249;</span></a></xsl:otherwise>
							</xsl:choose>
							<xsl:choose>
								<xsl:when test="//NEXT/@PID">
									<a href="/scielo.php?script=sci_issuetoc&amp;pid={//NEXT/@PID}&amp;lng={normalize-space(LANGUAGE)}&amp;nrm=iso" class="btn btn-secondary scielo__btn-with-icon--only"><xsl:attribute name="title"><xsl:call-template name="SERIAL_UI_TEXT"><xsl:with-param name="key">next_issue</xsl:with-param></xsl:call-template></xsl:attribute><span class="material-icons-outlined">&#8250;</span></a>
								</xsl:when>
								<xsl:otherwise><a href="#" class="btn btn-secondary scielo__btn-with-icon--only disabled"><xsl:attribute name="title"><xsl:call-template name="SERIAL_UI_TEXT"><xsl:with-param name="key">next_issue</xsl:with-param></xsl:call-template></xsl:attribute><span class="material-icons-outlined">&#8250;</span></a></xsl:otherwise>
							</xsl:choose>
							<xsl:if test="ISSUES/CURRENT/@PID">
								<a href="/scielo.php?script=sci_issuetoc&amp;pid={ISSUES/CURRENT/@PID}&amp;lng={normalize-space(LANGUAGE)}&amp;nrm=iso" class="btn btn-secondary"><xsl:call-template name="SERIAL_UI_TEXT"><xsl:with-param name="key">current_issue</xsl:with-param></xsl:call-template></a>
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
						<li class="breadcrumb-item"><a href="/scielo.php?lng={normalize-space(LANGUAGE)}">
							<svg class="serial-home-icon serial-home-icon-breadcrumb" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
								<path d="M3 11.5L12 4l9 7.5"/>
								<path d="M5.5 10.5V20h5v-6h3v6h5v-9.5"/>
							</svg>
						</a></li>
						<li class="breadcrumb-item"><a href="/scielo.php?script=sci_alphabetic&amp;lng={normalize-space(LANGUAGE)}&amp;nrm=iso"><xsl:call-template name="SERIAL_UI_TEXT"><xsl:with-param name="key">journals</xsl:with-param></xsl:call-template></a></li>
						<li class="breadcrumb-item"><xsl:value-of select="/SERIAL/TITLEGROUP/TITLE" disable-output-escaping="yes"/></li>
					</ol>
					<a class="btn btn-sm btn-secondary scielo__btn-with-icon--only serial-share-btn" href="mailto:?subject={/SERIAL/TITLEGROUP/TITLE}&amp;body=http://{SCIELO_INFO/SERVER}/scielo.php?script=sci_serial%26pid={/SERIAL/ISSN_AS_ID}%26lng={normalize-space(LANGUAGE)}%26nrm=iso">
						<xsl:attribute name="aria-label"><xsl:choose><xsl:when test="normalize-space(LANGUAGE)='en'">Share</xsl:when><xsl:when test="normalize-space(LANGUAGE)='es'">Compartir</xsl:when><xsl:otherwise>Compartilhar</xsl:otherwise></xsl:choose></xsl:attribute>
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

		<section class="journalContent mb-5">
			<div class="container">
				<div class="row">
					<div class="col-12">
						<h2 class="scielo__text-title--4"><xsl:call-template name="SERIAL_UI_TEXT"><xsl:with-param name="key">mission</xsl:with-param></xsl:call-template></h2>
						<p><xsl:value-of select="/SERIAL/MISSION" disable-output-escaping="yes"/></p>
					</div>
					<div class="col-12 mt-4">
						<span class="text">
							<strong><small><xsl:call-template name="SERIAL_UI_TEXT"><xsl:with-param name="key">latest_issue</xsl:with-param></xsl:call-template></small></strong>
							<p>
								<xsl:choose>
									<xsl:when test="ISSUES/CURRENT/@PID">
										<a href="/scielo.php?script=sci_issuetoc&amp;pid={ISSUES/CURRENT/@PID}&amp;lng={normalize-space(LANGUAGE)}&amp;nrm=iso">
											<strong>
												<xsl:value-of select="/SERIAL/TITLEGROUP/TITLE" disable-output-escaping="yes"/>
												<xsl:if test="ISSUES/CURRENT/@VOL">, Volume: <xsl:value-of select="ISSUES/CURRENT/@VOL"/></xsl:if>
												<xsl:if test="ISSUES/CURRENT/@NUM">, Número: <xsl:value-of select="ISSUES/CURRENT/@NUM"/></xsl:if>
											</strong>
										</a>
									</xsl:when>
									<xsl:otherwise><strong><xsl:call-template name="SERIAL_UI_TEXT"><xsl:with-param name="key">not_available</xsl:with-param></xsl:call-template></strong></xsl:otherwise>
								</xsl:choose>
							</p>
						</span>
					</div>
				</div>
			</div>
		</section>

		<section class="journalContent mb-5">
			<div class="container">
				<div class="row">
					<div class="col">
						<h2 class="scielo__text-title--4"><xsl:call-template name="SERIAL_UI_TEXT"><xsl:with-param name="key">latest_articles</xsl:with-param></xsl:call-template></h2>
						<div class="serial-latest" data-journal="{/SERIAL/ISSN_AS_ID}" data-lang="{normalize-space(LANGUAGE)}" data-current-volume="{ISSUES/CURRENT/@VOL}" data-current-url="/scielo.php?script=sci_issuetoc&amp;pid={ISSUES/CURRENT/@PID}&amp;lng={normalize-space(LANGUAGE)}&amp;nrm=iso">
							<div class="serial-latest-carousel">
								<button class="serial-latest-nav serial-latest-prev" type="button" hidden="hidden"><xsl:attribute name="aria-label"><xsl:call-template name="SERIAL_UI_TEXT"><xsl:with-param name="key">previous_articles</xsl:with-param></xsl:call-template></xsl:attribute>&#8249;</button>
								<div class="scielo-slider serial-latest-track" aria-live="polite">
									<div class="card serial-latest-loading">
										<a href="/scielo.php?script=sci_issuetoc&amp;pid={ISSUES/CURRENT/@PID}&amp;lng={normalize-space(LANGUAGE)}&amp;nrm=iso" class="stretched-link card-link">
											<div class="card-body">
												<div class="h6 card-subtitle mb-1">
													<xsl:if test="ISSUES/CURRENT/@VOL">VOLUME: <xsl:value-of select="ISSUES/CURRENT/@VOL"/></xsl:if>
												</div>
												<strong class="card-title text-primary"><xsl:call-template name="SERIAL_UI_TEXT"><xsl:with-param name="key">loading_articles</xsl:with-param></xsl:call-template></strong>
												<span class="serial-card-spacer"></span>
											</div>
											<div class="card-footer">
												<span class="btn btn-secondary d-block mx-0 my-0 w-100"><xsl:call-template name="SERIAL_UI_TEXT"><xsl:with-param name="key">read_more</xsl:with-param></xsl:call-template></span>
											</div>
										</a>
									</div>
								</div>
								<button class="serial-latest-nav serial-latest-next" type="button" hidden="hidden"><xsl:attribute name="aria-label"><xsl:call-template name="SERIAL_UI_TEXT"><xsl:with-param name="key">next_articles</xsl:with-param></xsl:call-template></xsl:attribute>&#8250;</button>
							</div>
						</div>
					</div>
				</div>
			</div>
		</section>

		<script type="text/javascript">
		(function () {
			var readMoreLabel = '<xsl:call-template name="SERIAL_UI_TEXT"><xsl:with-param name="key">read_more</xsl:with-param></xsl:call-template>';
			var fallbackTitle = '<xsl:call-template name="SERIAL_UI_TEXT"><xsl:with-param name="key">view_current_issue_articles</xsl:with-param></xsl:call-template>';
			function text(value) {
				return value == null ? '' : String(value);
			}

			function makeCard(item, fallbackVolume) {
				var card = document.createElement('div');
				card.className = 'card';
				var link = document.createElement('a');
				link.className = 'stretched-link card-link';
				link.href = item.article_url || '#';
				var body = document.createElement('div');
				body.className = 'card-body';
				var subtitle = document.createElement('div');
				subtitle.className = 'h6 card-subtitle mb-1';
				var meta = [];
				meta.push('VOLUME: ' + (item.volume || fallbackVolume || '-'));
				meta.push('PUBLICADO EM: ' + (item.publication_date || item.pub_year || '-'));
				subtitle.textContent = meta.join(' - ');
				var title = document.createElement('strong');
				title.className = 'card-title text-primary';
				title.textContent = text(item.title) || text(item.pid);
				var spacer = document.createElement('span');
				spacer.className = 'serial-card-spacer';
				var footer = document.createElement('div');
				footer.className = 'card-footer';
				var button = document.createElement('span');
				button.className = 'btn btn-secondary d-block mx-0 my-0 w-100';
				button.textContent = readMoreLabel;
				body.appendChild(subtitle);
				body.appendChild(title);
				body.appendChild(spacer);
				footer.appendChild(button);
				link.appendChild(body);
				link.appendChild(footer);
				card.appendChild(link);
				return card;
			}

			function fallback(root, track) {
				var card = root.querySelector('.serial-latest-loading');
				if (card) {
					card.querySelector('.card-title').textContent = fallbackTitle;
				}
				track.classList.remove('is-carousel');
			}

			function init(root) {
				var track = root.querySelector('.serial-latest-track');
				var journal = root.getAttribute('data-journal') || '';
				var lang = root.getAttribute('data-lang') || 'pt';
				var fallbackVolume = root.getAttribute('data-current-volume') || '';
				if (!track || !journal) {
					return;
				}
				fetch('/latest_articles.php?journal=' + encodeURIComponent(journal) + '&amp;lang=' + encodeURIComponent(lang) + '&amp;limit=12', { credentials: 'same-origin' })
					.then(function (response) { return response.ok ? response.json() : null; })
					.then(function (data) {
						var items = data &amp;&amp; data.ok &amp;&amp; data.items ? data.items : [];
						if (!items.length) {
							fallback(root, track);
							return;
						}
						track.innerHTML = '';
						items.forEach(function (item) {
							track.appendChild(makeCard(item, fallbackVolume));
						});
						track.classList.toggle('is-carousel', items.length &gt; 4);
						if (items.length &gt; 4) {
							var prev = root.querySelector('.serial-latest-prev');
							var next = root.querySelector('.serial-latest-next');
							var scroll = function (direction) {
								track.scrollBy({ left: direction * track.clientWidth, behavior: 'smooth' });
							};
							if (prev) { prev.hidden = false; }
							if (next) { next.hidden = false; }
							if (prev) { prev.addEventListener('click', function () { scroll(-1); }); }
							if (next) { next.addEventListener('click', function () { scroll(1); }); }
						}
					})
					.catch(function () {
						fallback(root, track);
					});
			}

			Array.prototype.forEach.call(document.querySelectorAll('.serial-latest'), init);
		}());
		</script>

		<div class="serial-template-utils">
			<a href="mailto:educ@fcc.org.br?subject=Reportar%20erro" class="serial-template-report"><xsl:choose><xsl:when test="normalize-space(/SERIAL/CONTROLINFO/LANGUAGE)='en'">Report error</xsl:when><xsl:when test="normalize-space(/SERIAL/CONTROLINFO/LANGUAGE)='es'">Reportar error</xsl:when><xsl:otherwise>Reportar erro</xsl:otherwise></xsl:choose></a>
			<a href="#main-content" class="serial-template-accessibility"><xsl:choose><xsl:when test="normalize-space(/SERIAL/CONTROLINFO/LANGUAGE)='en'">Accessibility</xsl:when><xsl:when test="normalize-space(/SERIAL/CONTROLINFO/LANGUAGE)='es'">Accesibilidad</xsl:when><xsl:otherwise>Acessibilidade</xsl:otherwise></xsl:choose></a>
		</div>
		<script type="text/javascript" src="/js/educa-accessibility.js?v=20260615-details-1"></script>
	</xsl:template>
</xsl:stylesheet>
