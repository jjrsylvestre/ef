<?xml version='1.0'?>

<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:xml="http://www.w3.org/XML/1998/namespace"
    xmlns:b64="https://github.com/ilyakharlamov/xslt_base64"
    xmlns:exsl="http://exslt.org/common"
    xmlns:date="http://exslt.org/dates-and-times"
    xmlns:str="http://exslt.org/strings"
    exclude-result-prefixes="b64"
    extension-element-prefixes="exsl date str"
>

<xsl:import href="./mathbook-xsl.d/pretext-html.xsl" />

<!-- customizations -->
<!-- <xsl:param name="html.google-universal" select="'UA-132951299-1'" /> --> <!-- TODO -->
<xsl:param name="html.knowl.example" select="'no'" />
<xsl:param name="html.knowl.exercise.inline" select="'no'" />
<xsl:param name="numbering.projects.level" select="'2'" />
<!-- <xsl:param name="numbering.theorem.level" select="'1'" /> -->
<!-- <xsl:param name="numbering.maximum.level" select="'2'" /> -->
<xsl:param name="html.css.extra" select="'ef.css'" />


</xsl:stylesheet>
