<?xml version='1.0'?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0">
    <xsl:output method="text"/>

    <xsl:template match="/DescriptorRecordSet">
      <xsl:apply-templates select="DescriptorRecord"/>
    </xsl:template>

    <xsl:template match="DescriptorRecord">
        <xsl:variable name="uid" select="DescriptorUI"/>
        <xsl:for-each select="TreeNumberList/TreeNumber[starts-with(.,'C')]">
                <xsl:value-of select="$uid"/>,<xsl:value-of select="."/><xsl:text>
</xsl:text>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
