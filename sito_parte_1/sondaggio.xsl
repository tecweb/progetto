<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="html" indent="yes" encoding="utf-8" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" version="1.0" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>
  <xsl:template match="/sondaggio">
<html xml:lang="en" lang="it">
  <head>
    <title>chi siamo - piazza Marconi zero</title>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>
    <meta name="title" content="gruppo 'piazza Marconi zero' - chi siamo"/>
    <meta name="description" content="pagina di informazioni sul gruppo di 
      Valdobbiadene 'piazza Marconi zero'"/>
    <meta name="keywords" content="Valdobbiadene, gruppo, giovani, chi siamo, informazioni"/>
    <meta name="language" content="italian it"/>
    <link href="style.css" rel="stylesheet" type="text/css" media="all"/>
  </head>
  <body>
    <div id="header">
      <span id="logo"></span>
      <h1 id="intestazione"> piazza Marconi zero </h1>
    </div>
    <div id="login">
      <h4> login </h4>
      <p> inserisci username e password </p>
      <p><label for="username"> username </label>
        <input type="text" size="10" id="username"/></p>
      <p><label for="password"> password </label>
        <input type="password" size="10" maxlength="8" id="password"/></p>
      <input type="submit" value="Ok"/>
    </div>
    <div id="nav_bar">
      <!--SEZIONE DA RISISTEMARE-->
      <dl>
        <dt class="menu_title"> naviga </dt>
          <dd><a href="home.xml"> home </a></dd>
          <dd><a href="info.html"> chi siamo </a></dd>
        <dt class="menu_title"> tematiche </dt> 
          <!--CARICARE DINAMICAMENTE ELENCO TEMATICHE SONDAGGI-->
          <dd><a href="biomasse.xml"> biomasse </a></dd>
				<dt class="menu_title"> suggerimenti </dt>
					<dd><a href="#"> scrivici </a></dd>
      </dl> 
    </div>
    <div id="body">
      <h2> <xsl:value-of select="nome"></xsl:value-of></h2>
	      <form class="poll_questions" method="post" action="/cgi-bin/save_vote.pl">
	      <xsl:for-each select="domanda">
        <fieldset>
          <h4 class="domanda"> <xsl:value-of select="problema"></xsl:value-of> </h4>
          <xsl:for-each select="opzione">
          <p> 
            <label>
            <xsl:attribute name="for">cid<xsl:number/>
            </xsl:attribute>
            <xsl:value-of select="node()"></xsl:value-of>
            </label> 
              <input type="radio" value="t">
                <xsl:attribute name="name">question<xsl:number/></xsl:attribute>
                <xsl:attribute name="id">cid<xsl:number/></xsl:attribute>
              </input> 
          </p>
          </xsl:for-each>
        </fieldset>
        </xsl:for-each>
        <p><input type="submit" value="Conferma" /></p>
      </form>
			<p><a href="tematica.html"> torna al problema </a></p>
			<p><a href="commenti.html"> vai alla pagina dei commenti </a></p>
    </div>		
    <div id="footer">
      <p>
        <a href="http://validator.w3.org/check?uri=referer"><img
          src="http://www.w3.org/Icons/valid-xhtml10-blue"
          alt="Valid XHTML 1.0 Strict" class="valid"/></a>
        <a href="http://jigsaw.w3.org/css-validator/check/referer">
          <img style="border:0;width:88px;height:31px"
           src="http://jigsaw.w3.org/css-validator/images/vcss-blue"
           alt="CSS Valido!" class="valid"/>
        </a>
      </p>
    </div>
  </body>
</html>
  </xsl:template>
</xsl:stylesheet>
