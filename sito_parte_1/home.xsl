<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="html" indent="yes" encoding="utf-8" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" version="1.0" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>
<xsl:template match="/">
	<html xml:lang="en" lang="it">
  	<head>
    	<title> home - piazza Marconi zero </title>
      <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>
      <meta name="title" content="gruppo 'piazza Marconi zero' - home"/>
      <meta name="description" content="home page del sito del gruppo di Valdobbiadene 'piazza Marconi zero'"/>
      <meta name="keywords" content="Valdobbiadene, gruppo, giovani, home page"/>
      <meta name="language" content="italian it"/>
      <link href="style.css" rel="stylesheet" type="text/css" media="all"/>
		</head>
    <body>

    	<div id="header">
      	<div id="logo"></div>
      	<h1 id="intestazione"> piazza Marconi zero </h1>
			</div>
 
      <div id="login">
      	<h4> login </h4>
        <p> inserisci username e password </p>
        <p>
        	<label for="username"> username </label>
          <input type="text" size="10" id="username"/>
        </p>
        <p>
          <label for="password"> password </label>
          <input type="password" size="10" maxlength="8" id="password"/>
        </p>
        <input type="submit" value="Ok"/>
			</div>
 
      <div id="nav_bar">
	      <dl>
	        <dt class="menu_title"> naviga </dt>
	          <dd><a href="home.xml"> home </a></dd>
            <dd><a href="info.html"> chi siamo </a></dd>
          <dt class="menu_title"> tematiche </dt>
          <!--CARICARE DINAMICAMENTE ELENCO TEMATICHE SONDAGGI-->
          <xsl:for-each select="tematiche/tematica">
	          <dd>
		          <a>
	              <xsl:attribute name="href">
	                <xsl:value-of select="link"/>
								</xsl:attribute>
                <xsl:value-of select="nome"/>
              </a>
            </dd>
					</xsl:for-each>
          <dt class="menu_title"> suggerimenti </dt>
            <dd><a href="#"> scrivici </a></dd>
				</dl>
    	</div>
 
			<div id="corpo">
      	<h2> News </h2>
        <!--NELLA HOME DIREI NIENTE CONTENUTO STATICO. PER QUELLO C'�IL CHI SIAMO-->
        	<p> Qui andra' l'elenco delle news. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>
			</div>

      <div id="footer">
      	<p>
          <a href="http://validator.w3.org/check?uri=referer">
          	<img src="http://www.w3.org/Icons/valid-xhtml10-blue" alt="Valid XHTML 1.0 Strict" class="valid"/>
          </a>
          <a href="http://jigsaw.w3.org/css-validator/check/referer">
           	<img style="border:0;width:88px;height:31px" src="http://jigsaw.w3.org/css-validator/images/vcss-blue" alt="CSS Valido!" class="valid"/>
          </a>
        </p>
     </div>
 
		</body>
	</html>
</xsl:template>
</xsl:stylesheet>
