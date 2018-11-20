<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    exclude-result-prefixes="xs h t"
    xmlns:h="http://www.w3.org/1999/xhtml" 
    xmlns:t="http://www.tei-c.org/ns/1.0" 
    
    xmlns="http://www.tei-c.org/ns/1.0" 
    version="2.0">
  
<!-- tags to lose -->
    <xsl:template
        match="t:abbr|t:docDate|t:docTitle|t:docImprint|t:lg|t:num|t:opener|t:q|t:said|t:sic|t:sp|t:space">
        <xsl:apply-templates/>
    </xsl:template>
    
  <!-- change to p -->
    
    <xsl:template match="t:dateline|t:epigraph">
        <p><xsl:apply-templates/></p>
    </xsl:template>
   
   <xsl:template match="t:signed">
       <xsl:choose>
           <xsl:when test="parent::t:p"><xsl:apply-templates/></xsl:when>
           <xsl:when test="parent::t:closer"><xsl:apply-templates/></xsl:when>
           <xsl:otherwise><p><xsl:apply-templates/></p></xsl:otherwise>
       </xsl:choose>
   </xsl:template>
    
    <xsl:template match="t:speaker">
        <p><label><xsl:apply-templates/></label></p>
    </xsl:template>
   <!-- divs -->
   
    <xsl:template match="t:div1|t:div2|t:div3">
        <div>
            <xsl:attribute name="type">
                <xsl:choose>
                    <xsl:when test="@type='capitolo'">chapter</xsl:when>
                    <xsl:when test="@type='cap'">chapter</xsl:when>                   
                    <xsl:when test="@type='part'">part</xsl:when>
                    <xsl:when test="@type='ded'">liminal</xsl:when>
                    <xsl:otherwise/>
                        
                    
                </xsl:choose>
            </xsl:attribute>
            <xsl:apply-templates/>
        </div><!-- need to sort out @type values -->
    </xsl:template>
    
    <!-- other oddities -->
    
    <xsl:template match="t:argument">
        <head><xsl:value-of select="."/></head>
    </xsl:template>
    
    <xsl:template match="t:floatingText">
        <quote>
            <xsl:apply-templates select="t:body"/>
        </quote>
    </xsl:template>
    
    <!-- copy everything else -->
    
    <xsl:template match="* | @* | processing-instruction()">
        <xsl:copy>
            <xsl:apply-templates select="* | @* | processing-instruction() | comment() | text()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="text()">
        <xsl:value-of select="."/>
        <!-- could normalize() here -->
    </xsl:template>
</xsl:stylesheet>