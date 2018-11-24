<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    exclude-result-prefixes="xs h t"
    xmlns:h="http://www.w3.org/1999/xhtml" 
    xmlns:t="http://www.tei-c.org/ns/1.0" 
    
    xmlns="http://www.tei-c.org/ns/1.0" 
    version="2.0">
  
  <!-- elements and attributes to lose -->
    
  <xsl:template match="t:space"/>
   <xsl:template match="@anchored|@rend"/>
    
<!-- tags to lose -->
    <xsl:template
        match="t:abbr|t:docDate|t:docTitle|t:docImprint|t:lg|t:num|t:opener|t:q|t:said|t:sic|t:sp">
        <xsl:apply-templates/>
    </xsl:template>
    
  <!-- change to p -->
    
    <xsl:template match="t:epigraph">
        <p><xsl:apply-templates/></p>
    </xsl:template>
   
   <xsl:template match="t:signed|t:dateline">
       <xsl:choose>
            <xsl:when test="parent::t:closer"><xsl:apply-templates/></xsl:when>
           <xsl:otherwise><p><xsl:apply-templates/></p></xsl:otherwise>
       </xsl:choose>
   </xsl:template>
    
        <xsl:template match="t:speaker">
        <p><label><xsl:apply-templates/></label></p>
    </xsl:template>
   
    <!-- divs -->
   
   <xsl:template match="t:div[@type='sez_diario']">
       <milestone unit="diary_entry"/>
       <xsl:apply-templates/>
   </xsl:template>
   
    <xsl:template match="t:div1|t:div2|t:div3|t:div[not(@type='sez_diario')]">
        <div>
             <xsl:attribute name="type">
                <xsl:choose>
                    <xsl:when test="@type='capitolo'">chapter</xsl:when>
                    <xsl:when test="@type='cap'">chapter</xsl:when>                   
                    <xsl:when test="@type='part'">part</xsl:when>
                    <xsl:when test="@type='ded'">liminal</xsl:when>
                    <xsl:when test="@type='prefazione'">liminal</xsl:when>
                    <xsl:when test="@type='introduzione'">liminal</xsl:when>
                    <xsl:when test="@type='epigragfe'">liminal</xsl:when>
                    <xsl:when test="@type='novella'">chapter</xsl:when>
                    
                    <xsl:otherwise><xsl:value-of select="@type"/> unknown</xsl:otherwise>                       
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
    
    <xsl:template match="t:TEI">
        <TEI><xsl:attribute name="xml:id">
            <xsl:value-of select="concat('BI',substring-after(//t:publicationStmt/t:idno[1],'bibit'))"/>
        </xsl:attribute>
        <xsl:attribute name="xml:lang">it</xsl:attribute>
            <xsl:apply-templates/>
</TEI>    </xsl:template>
    
    <!-- tweak header -->
    
    <xsl:template match="t:titleStmt">
        <titleStmt>
            <title><xsl:value-of select="t:title"/><xsl:text>: edizion ELTeC</xsl:text></title>
        <author><xsl:value-of select="normalize-space(t:author)"/><xsl:text> (? - ?)</xsl:text></author>
    <respStmt><resp>ELTeC encoding</resp><name>Lou Burnard</name></respStmt>
        <xsl:apply-templates select="t:respStmt"/></titleStmt>
    </xsl:template>
    
    <xsl:template match="t:extent">
        <extent>
            <measure type="words"/>
            <xsl:if test="count(//t:pb) &gt; 1">
            <measure type="pages"><xsl:value-of select="count(//t:pb)"/></measure></xsl:if>            
        </extent>
    </xsl:template>
    
    <xsl:template match="t:publicationStmt">
        <publicationStmt><p>Published as part of ELTeC : <date></date></p></publicationStmt>
    </xsl:template>
    
    <xsl:template match="t:sourceDesc">
        <sourceDesc>
    <xsl:apply-templates/>
            <bibl type="copyText">
                <date><xsl:value-of select="//t:profileDesc/t:creation/t:date"/></date>
            </bibl>
        </sourceDesc>
    </xsl:template>
    
    <xsl:template match="t:encodingDesc">
        <encodingDesc><p><xsl:comment>
            <xsl:value-of select="."/>
        </xsl:comment></p>
        </encodingDesc>
    </xsl:template>
    
    <xsl:template match="t:profileDesc">
        <profileDesc xmlns:e="http://distantreading.net/eltec/ns">
            <xsl:copy-of select="t:langUsage"/>
            <textDesc>
                <e:authorGender key="M"/>
                <e:size key="medium"/>
                <e:canonicity key="high"/>
                <e:timeSlot key="T?"/>
            </textDesc>
        </profileDesc></xsl:template>
     
     <xsl:template match="t:change"/>
    
     <xsl:template match="t:revisionDesc">
         <revisionDesc>
             <change when="2018-11-24">LB: convert to eltec </change>
             <xsl:for-each select="t:change">
                 <xsl:sort select="t:date" order="descending"/>
             <change>
                 <xsl:if test="starts-with(t:date,'200')">
                     <xsl:attribute name="when">
                         <xsl:value-of select="substring-before(t:date,'T00')"/>
                     </xsl:attribute>
                 </xsl:if>
<xsl:value-of select="t:name"/>
    <xsl:text>: </xsl:text>
                 <xsl:value-of select="text()"/>
             </change>
             </xsl:for-each>
             
         </revisionDesc>
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