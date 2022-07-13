<?xml version='1.0'?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	version="1.0"> 
	<xsl:output method="text"/>

	<xsl:template match='/DocumentSummarySet'>
		<xsl:apply-templates select="DocumentSummary"/>
	</xsl:template>

	<xsl:template match="DocumentSummary">
		<xsl:variable name="acc" select="Accession"/>
		<xsl:for-each select="PubMedIds/int">
			<xsl:value-of select="."/>,<xsl:value-of select="$acc"/><xsl:text>
</xsl:text>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
