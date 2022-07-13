<?xml version='1.0'?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	version="1.0"> 
	<xsl:output method="text"/>

	<xsl:template match='/DocumentSummarySet'>
		<xsl:apply-templates select="DocumentSummary/d_study_results"/>
	</xsl:template>

	<xsl:template match="d_study_results">
		<xsl:variable name="sid" select="d_study_id"/>
		<xsl:for-each select="d_study_disease_list/d_disease_info[d_disease_importance='primary']/d_disease_name">
			<xsl:text>"</xsl:text><xsl:value-of select="."/><xsl:text>",</xsl:text><xsl:value-of select="$sid"/>
		        <xsl:text>
</xsl:text>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
