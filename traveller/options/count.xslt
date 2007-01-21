<?xml version="1.0"?>

<xsl:transform     xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                   xmlns:yb="http://yagsbook.sourceforge.net/xml"
                   xmlns:y="http://yagsbook.sourceforge.net/xml/yags"
                   version="1.0">

    <xsl:output method="text"/>

    <xsl:template match="/yb:characters">
        <xsl:apply-templates select="yb:character"/>
    </xsl:template>

    <xsl:template match="//yb:character">
        <xsl:value-of select="@name"/>

        <xsl:variable name="skills">
            <xsl:call-template name="y:sum-skill-points"/>
        </xsl:variable>

        <xsl:variable name="techniques">
            <xsl:call-template name="y:sum-advantage-points"/>
        </xsl:variable>

        <xsl:text> - </xsl:text>

        <xsl:value-of select="$skills + $techniques - 64"/> (<xsl:value-of select="$skills - 64"/> / <xsl:value-of select="$techniques"/>)
<xsl:text>
</xsl:text>
    </xsl:template>

    <xsl:template match="y:advantages">
        <xsl:value-of select="sum(y:advantage[@score]/@score)"/>
    </xsl:template>

    <xsl:template name="count" match="y:skills">
        <xsl:param name="idx" select="1"/>
        <xsl:param name="total" select="0"/>

        <xsl:if test="y:group/y:skill[$idx]">
            <xsl:value-of select="y:group/y:skill[$idx]/@score"/>
            <xsl:call-template name="count">
                <xsl:with-param name="idx" value="$idx + 1"/>
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="not(y:group/y:skill[$idx])">
            <xsl:value-of select="$total"/>
        </xsl:if>
    </xsl:template>


    <xsl:template match="y:skill">
        <xsl:value-of select="@name"/>
        (<xsl:value-of select="(@score * (@score +1)) div 2"/>)
    </xsl:template>

    <xsl:template name="y:sum-skill-points">
        <xsl:param name="i" select="1"/>
        <xsl:param name="j" select="1"/>
        <xsl:param name="total" select="0"/>

        <xsl:if test="y:statistics/y:skills/y:group[$j]/y:skill[$i]">
            <xsl:variable name="score"
                          select="y:statistics/y:skills/y:group[$j]/y:skill[$i]/@score"/>
            <xsl:variable name="cost" select="(($score * ($score + 1)) div 2)"/>

            <xsl:call-template name="y:sum-skill-points">
                <xsl:with-param name="i" select="$i + 1"/>
                <xsl:with-param name="j" select="$j"/>
                <xsl:with-param name="total" select="$total + $cost"/>
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="not(y:statistics/y:skills/y:group[$j]/y:skill[$i])">
            <xsl:if test="y:statistics/y:skills/y:group[$j + 1]">
                <xsl:call-template name="y:sum-skill-points">
                    <xsl:with-param name="i" select="1"/>
                    <xsl:with-param name="j" select="$j + 1"/>
                    <xsl:with-param name="total" select="$total"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="not(y:statistics/y:skills/y:group[$j + 1])">
                <xsl:value-of select="$total"/>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <xsl:template name="y:sum-advantage-points">
        <xsl:param name="i" select="1"/>
        <xsl:param name="total" select="0"/>

        <xsl:if test="y:statistics/y:advantages/y:advantage[$i]">
            <xsl:variable name="cost">
                <xsl:choose>
                    <xsl:when test="y:statistics/y:advantages/y:advantage[$i]/@cost">
                        <xsl:value-of
                                     select="y:statistics/y:advantages/y:advantage[$i]/@cost"/>
                    </xsl:when>
                    <xsl:otherwise>0</xsl:otherwise>
                </xsl:choose>
            </xsl:variable>

            <xsl:call-template name="y:sum-advantage-points">
                <xsl:with-param name="i" select="$i + 1"/>
                <xsl:with-param name="total" select="$total + $cost"/>
            </xsl:call-template>
        </xsl:if>
        <xsl:if test="not(y:statistics/y:advantages/y:advantage[$i])">
            <xsl:value-of select="$total"/>
        </xsl:if>
    </xsl:template>

</xsl:transform>
