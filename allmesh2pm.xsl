<?xml version='1.0'?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	version="1.0"> 
	<xsl:output method="text"/>

	<xsl:template match='/PubmedArticleSet'>
		<xsl:apply-templates select="PubmedArticle/MedlineCitation"/>
	</xsl:template>

	<xsl:template match="MedlineCitation">
		<xsl:variable name="pmid" select="PMID"/>
		<xsl:for-each select="MeshHeadingList/MeshHeading/DescriptorName">
			<xsl:value-of select="@UI"/>,<xsl:value-of select="$pmid"/>
		        <xsl:text>
</xsl:text>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
