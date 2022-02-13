<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:xi="http://www.w3.org/2001/XInclude"
    xmlns:h="http://www.w3.org/1999/xhtml" 
    xmlns:t="http://www.tei-c.org/ns/1.0" 
    xmlns:cligs="https://cligs.hypotheses.org/ns/cligs"
    exclude-result-prefixes="xs h t xi cligs"
    
    xmlns="http://www.tei-c.org/ns/1.0" 
    version="2.0">
    
    <xsl:variable name="today">
        <xsl:value-of select="substring(string(current-date()), 1, 10)"/>
    </xsl:variable>
    
    <xsl:param name="textId">xxxxxx</xsl:param>
    
    <xsl:template match="t:TEI">
        <TEI xmlns="http://www.tei-c.org/ns/1.0" xml:lang="it" xml:id="{$textId}">
            <xsl:apply-templates/>
        </TEI>
    </xsl:template>
    <xsl:template match="t:titleStmt">
        <titleStmt>
            <title>
                <xsl:value-of select="concat(t:title[@type='main'],' : ELTeC edition')"/>
            </title>
            <author>
                <xsl:attribute name="ref">
                    <xsl:value-of select="concat('viaf:',t:author/t:idno[@type='viaf'])"/>
                </xsl:attribute>
                <xsl:value-of select="concat(t:author/t:name[@type='full'],' (?-?)')"/>
            </author>
        </titleStmt>
    </xsl:template>
    
    <xsl:template match="t:principal">
       <respStmt>
           <resp>principal</resp>
           <name><xsl:apply-templates/></name>
       </respStmt> 
    </xsl:template>
    
<xsl:template match="t:extent">
    <extent>
        <xsl:apply-templates select="t:measure[@unit eq 'words']"/>
    </extent>
</xsl:template>    
    
     <xsl:template match="t:publicationStmt">
        <publicationStmt>
            <p><xsl:text>Incorporated into the ELTeC </xsl:text>
            <date><xsl:value-of select="$today"/></date>
            <xsl:comment><xsl:apply-templates/></xsl:comment></p></publicationStmt>
    </xsl:template>
    
    <xsl:template match="t:encodingDesc">
        <encodingDesc n="eltec-1"><p>Downcoded from CLIGS</p></encodingDesc>
    </xsl:template>
   
    <xsl:template match="t:bibl[@type='print-source']">
      <!--  <title>
            <xsl:value-of select="substring-before(substring-after(.,'&#x22;'),'&#x22;')"/>
        </title>
        <xsl:value-of select="substring-before(substring-after(.,','),',')"/>-->
      <xsl:apply-templates/>
       
    </xsl:template>
    
    <xsl:template match="t:bibl[@type='print-source']/t:date">
        <date>
            <xsl:value-of select="."/>
            <xsl:text>(</xsl:text>
            <xsl:value-of select="../../t:bibl[@type='first-edition']/t:date/@when"/>
         <xsl:text>)</xsl:text>
        </date>
    </xsl:template>
    
   <xsl:template match="t:sourceDesc">
       <sourceDesc><bibl type="digitalSource">
           <ref>
               <xsl:attribute name="target"><xsl:value-of select="../t:publicationStmt/t:idno[@type='url']"/></xsl:attribute>
               <xsl:text>CLIGS version</xsl:text>
           </ref>
       <relatedItem type="copyText">
       <bibl type="printSource">
           <xsl:apply-templates select="t:bibl[@type='print-source']"/>
       </bibl></relatedItem>
       </bibl>
       </sourceDesc>
   </xsl:template>
   
    <xsl:template match="t:profileDesc">
        
        <xsl:variable name="date">
            <xsl:value-of select="../t:fileDesc/t:sourceDesc/t:bibl[@type='first-edition']/t:date/@when"/>
        </xsl:variable>
        <xsl:variable name="wordCount">
            <xsl:value-of select="../t:fileDesc/t:extent/t:measure[@unit='words']"/>
        </xsl:variable>
        <xsl:variable name="gender">
            <xsl:value-of select="t:textClass/t:keywords/t:term[@type='author.gender']"/>
        </xsl:variable>
        
        <xsl:variable name="timeSlot">
            <xsl:choose>
                <xsl:when test="$date le '1859'">T1</xsl:when>
                <xsl:when test="$date le '1879'">T2</xsl:when>
                <xsl:when test="$date le '1899'">T3</xsl:when>
                <xsl:when test="$date le '1920'">T4</xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="size">
            <xsl:choose>
                <xsl:when test="xs:integer($wordCount) le 50000">short</xsl:when>
                <xsl:when test="xs:integer($wordCount) le 100000">medium</xsl:when>
                <xsl:when test="xs:integer($wordCount) gt 100000">long</xsl:when>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="sex">
            <xsl:choose>
                <xsl:when test="$gender eq 'male'">M</xsl:when>
                <xsl:when test="$gender eq 'female'">F</xsl:when>
                <xsl:otherwise>U</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>     
        
    <profileDesc>
        <langUsage>
            <language ident="ita">Italian</language>
        </langUsage>
        <textDesc>
            <authorGender xmlns="http://distantreading.net/eltec/ns" key="{$sex}"/>
            <size xmlns="http://distantreading.net/eltec/ns" key="{$size}"/>
            <canonicity xmlns="http://distantreading.net/eltec/ns" key="medium"/>
            <timeSlot xmlns="http://distantreading.net/eltec/ns" key="{$timeSlot}"/>
        </textDesc>
    </profileDesc>
    </xsl:template>
    
    <xsl:template match="t:change">
        <change when="{@when}">
            <xsl:value-of select="@who"/>
            <xsl:text> : </xsl:text>
            <xsl:value-of select="."/>
        </change>
    </xsl:template>
    <xsl:template match="t:revisionDesc">
     <revisionDesc>   <change when="{$today}">LB convert to ELTeC-1</change>
       <xsl:for-each select="t:change">
           <xsl:sort order="descending" select="@when"/>
           <xsl:apply-templates select="."/>
       </xsl:for-each>
        </revisionDesc>
    </xsl:template>
    
    <xsl:template match="t:ab[@type='abstract']">
        <head type="summary">
            <xsl:apply-templates/>
        </head>
    </xsl:template>
    
    <xsl:template match="t:ab">
        <p><xsl:apply-templates/></p>
    </xsl:template>
    
    <xsl:template match="t:floatingText|t:lg/t:head">
        <xsl:comment>
            <xsl:apply-templates/>
        </xsl:comment>
    </xsl:template>
   <!-- throw away tags but keep content -->
    <xsl:template match="t:lg"><xsl:apply-templates/></xsl:template>
   <!-- throw away -->
    <xsl:template match="@default|@part|@status"/>
    <xsl:template match="t:ref[@target='#']"/>
    
    <xsl:template match="* | @* ">
        <xsl:copy>
            <xsl:apply-templates select="* | @* |  comment() | text()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="text()">
        <xsl:value-of select="."/>
        <!-- could normalize() here -->
    </xsl:template>
</xsl:stylesheet>