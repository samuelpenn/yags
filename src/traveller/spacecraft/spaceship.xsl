<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
        xmlns:xhtml="http://www.w3.org/1999/xhtml"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:ss="http://glendale.org.uk/alfresco/spaceship"
        xmlns:spacecraft="uk.org.glendale.alfresco.yags.Spacecraft"
        xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
        xmlns:xalan="http://xml.apache.org/xalan"
        exclude-result-prefixes="xhtml"
        extension-element-prefixes="spacecraft">
<!--
  <xsl:output method="html"  encoding="UTF-8" indent="yes"
              doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
              doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/>
-->
    <xsl:preserve-space elements="*"/>

    <xalan:component prefix="spacecraft">
        <xalan:script lang="javaclass"
                      src="xalan://uk.org.glendale.alfresco.yags.Spacecraft"/>
    </xalan:component>

    <!--
        Generate HTML page for a spacecraft. These are static pages, so all dynamic
        content must be auto-generated at this point.
    -->
    <xsl:template match="/">
        <!--
        <xsl:variable name="list" select="alf:parseXMLDocuments('news', '/')"/>
        -->
        <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
            <head>
                <title><xsl:value-of select="/ss:spaceship/ss:description/ss:name"/></title>

                <link title="Default" href="default.css" type="text/css" rel="stylesheet" />
                <link title="Default" href="/assets/css/default.css" type="text/css" rel="stylesheet" />
            </head>

            <body>

                <div class="body">
                    <h1>
                        <xsl:value-of select="/ss:spaceship/ss:description/ss:name"/>
                        <xsl:text> - </xsl:text>
                        <xsl:value-of select="/ss:spaceship/ss:attributes/ss:displacement"/>
                        <xsl:text>dt </xsl:text>
                        <xsl:value-of select="/ss:spaceship/ss:description/ss:type"/>
                    </h1>
<xsl:text>
</xsl:text>

                    <xsl:apply-templates select="/ss:spaceship/ss:description"/>
<xsl:text>
</xsl:text>

                    <xsl:apply-templates select="/ss:spaceship/ss:attributes"/>
<xsl:text>
</xsl:text>
                    <xsl:apply-templates select="/ss:spaceship/ss:mounts"/>
<xsl:text>
</xsl:text>
                </div>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="ss:description">
        <div class="description">
            <table>
                <tr>
                    <th>In-service Date</th>
                    <td><xsl:value-of select="ss:inService"/></td>
                    <th>Manufacturer</th>
                    <td><xsl:value-of select="ss:manufacturer"/></td>
                </tr>
            </table>

            <p>
                <xsl:value-of select="ss:physical" disable-output-escaping="yes"/>
            </p>

            <h4>Background and History</h4>

            <p>
                <xsl:value-of select="ss:background" disable-output-escaping="yes"/>
            </p>
        </div>
    </xsl:template>

    <xsl:template name="damageRows">
        <xsl:param name="count"/>

        <xsl:choose>
            <xsl:when test="$count = 0"></xsl:when>
            <xsl:otherwise>
                <td><img src="circle.jpg" width="16px" height="16px"/></td>
                <xsl:call-template name="damageRows">
                    <xsl:with-param name="count" select="$count - 1"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="ss:attributes">
        <div class="attributes">
            <h2>Attributes</h2>

            <!--
                <c:set var="ship" value="${spacecraft:loadDocument(pageContext, null)}"/>
            -->
            <xsl:variable name="sc" select="spacecraft:new(/)"/>

            <table class="attributes">
                <tr>
                    <th>Configuration</th><td><xsl:value-of select="ss:configuration"/></td>
                    <th>Displacement</th><td><xsl:value-of select="ss:displacement"/>dt</td>
                    <th>Tech Level</th><td><xsl:value-of select="ss:techLevel"/></td>
                </tr>
                <tr>
                    <th>Size</th><td><xsl:value-of select="spacecraft:getSize($sc)"/></td>
                    <th>Toughness</th>
                    <td>
                        <xsl:value-of select="spacecraft:getHealth($sc)"/>
                        <xsl:text> (</xsl:text><xsl:value-of select="ss:health"/>)
                    </td>
                    <th>Agility</th>
                    <td>
                        <xsl:value-of select="spacecraft:getAgility($sc)"/>
                        <xsl:text> (</xsl:text><xsl:value-of select="ss:agility"/>)
                    </td>
                </tr>

                <tr>
                    <th>Signature</th>
                    <td><xsl:value-of select="spacecraft:getSignature($sc)"/></td>

                    <th>Sensors</th>
                    <td><xsl:value-of select="spacecraft:getPerception($sc)"/></td>

                    <th>Computers</th>
                    <td><xsl:value-of select="spacecraft:getIntelligence($sc)"/></td>
                </tr>

                <tr>
                    <td class="title" colspan="6">
                        Statistics
                    </td>
                </tr>

                <tr>
                    <th>Volume</th>
                    <td><xsl:value-of select="spacecraft:getVolume($sc)"/>dt</td>
                    <th>Surface area</th>
                    <td><xsl:value-of select="spacecraft:getSurfaceArea($sc)"/></td>
                    <th>Mass</th>
                    <td><xsl:value-of select="spacecraft:getMass($sc)"/></td>
                </tr>

                <tr>
                    <th>Free space</th>
                    <td><xsl:value-of select="spacecraft:getFreeSpace($sc)"/>dt</td>
                    <th>Free area</th>
                    <td><xsl:value-of select="spacecraft:getFreeArea($sc)"/></td>
                    <th>Cargo hold</th>
                    <td><xsl:value-of select="spacecraft:getCargo($sc)"/>dt</td>
                </tr>

                <tr>
                    <th>Drive</th>
                    <td><xsl:value-of select="spacecraft:getDrive($sc)"/>dt</td>

                    <th>Fuel</th>
                    <td><xsl:value-of select="spacecraft:getFuel($sc)"/>dt</td>

                    <th>Jump Drive</th>
                    <td><xsl:value-of select="spacecraft:getJumpDrive($sc)"/>dt</td>
                </tr>

                <tr>
                    <td class="title" colspan="6">
                        Performance
                    </td>
                </tr>

                <tr>
                    <th>Acceleration</th>
                    <td><xsl:value-of select="spacecraft:getAcceleration($sc)"/>g</td>

                    <th>Delta Vee</th>
                    <td><xsl:value-of select="spacecraft:getDeltaVee($sc)"/>km/s</td>

                    <th>Jump Rating</th>
                    <td>
                        <xsl:choose>
                            <xsl:when test="spacecraft:getJumpRating($sc) = 0">-</xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="spacecraft:getJumpRating($sc)"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </td>
                </tr>

                <tr>
                    <th>Air speed</th>
                    <td></td>

                    <xsl:choose>
                        <xsl:when test="spacecraft:getRepulsorAltitude($sc) = 0">
                            <th>Repulsor speed</th>
                            <td>-</td>
                            <th>Repulsor altitude</th>
                            <td>-</td>
                        </xsl:when>
                        <xsl:otherwise>
                            <th>Repulsor speed</th>
                            <td><xsl:value-of select="spacecraft:getRepulsorSpeed($sc)"/>m/s</td>

                            <th>Repulsor altitude</th>
                            <td><xsl:value-of select="spacecraft:getRepulsorAltitude($sc)"/>m</td>
                        </xsl:otherwise>
                    </xsl:choose>
                </tr>

                <tr>
                    <td class="title" colspan="6">
                        Crew
                    </td>
                </tr>

                <tr>
                    <th>Crew</th>
                    <td><xsl:value-of select="spacecraft:getBridgeCrew($sc)"/></td>

                    <th>Workload</th>
                    <td><xsl:value-of select="spacecraft:getEngineeringWorkload($sc)"/>hrs/wk</td>

                    <th>Jump Rating</th>
                    <td><xsl:value-of select="spacecraft:getJumpRating($sc)"/></td>
                </tr>

                <tr>
                    <td class="title" colspan="6">
                        Combat
                    </td>
                </tr>

                <tr>
                    <th>Soak</th>
                    <td><xsl:value-of select="spacecraft:getSoak($sc)"/></td>
                    <th>Hull soak</th>
                    <td><xsl:value-of select="spacecraft:getBasicSoak($sc)"/></td>
                    <th>Armour soak</th>
                    <td><xsl:value-of select="spacecraft:getArmourSoak($sc)"/></td>
                </tr>
            </table>

            <h3>Hull Toughness</h3>

            <table class="damage">
                <tr>
                    <th>Light (0)</th>
                    <th><xsl:value-of select="spacecraft:getLightDamage($sc)"/></th>
                    <xsl:call-template name="damageRows">
                        <xsl:with-param name="count" select="spacecraft:getLightDamage($sc)"/>
                    </xsl:call-template>
                </tr>
                <tr>
                    <th>Moderate (-10)</th>
                    <th><xsl:value-of select="spacecraft:getModerateDamage($sc)"/></th>
                    <xsl:call-template name="damageRows">
                        <xsl:with-param name="count" select="spacecraft:getModerateDamage($sc)"/>
                    </xsl:call-template>
                </tr>
                <tr>
                    <th>Heavy (-25)</th>
                    <th><xsl:value-of select="spacecraft:getHeavyDamage($sc)"/></th>
                    <xsl:call-template name="damageRows">
                        <xsl:with-param name="count" select="spacecraft:getHeavyDamage($sc)"/>
                    </xsl:call-template>
                </tr>
                <tr>
                    <th>Crippled</th>
                    <th><xsl:value-of select="spacecraft:getCrippledDamage($sc)"/></th>
                    <xsl:call-template name="damageRows">
                        <xsl:with-param name="count" select="spacecraft:getCrippledDamage($sc)"/>
                    </xsl:call-template>
                </tr>
            </table>
        </div>
    </xsl:template>

    <xsl:template match="ss:mounts">
        <table class="mounts">
            <tr>
                <th>Turret</th>
                <th>Type</th>
                <th>System</th>
                <th>TL</th>
                <th>Atk</th>
                <th>Dmg</th>
                <th>Size</th>
                <th>Inc</th>
                <th>Short</th>
            </tr>

            <xsl:apply-templates select="ss:mount"/>
        </table>
    </xsl:template>

    <xsl:template match="ss:mount">
        <tr>
            <td><xsl:value-of select="@name"/></td>
            <td><xsl:value-of select="@type"/></td>

            <xsl:if test="ss:weapon">
                <xsl:variable name="weapon" select="ss:weapon/@type"/>
                <xsl:variable name="mount" select="@type"/>

                <xsl:variable name="tl">
                    <xsl:choose>
                        <xsl:when test="ss:weapon/@techLevel">
                            <xsl:value-of select="ss:weapon/@techLevel"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="../../ss:attributes/ss:techLevel"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="wpn" select="document('weapons.xml')/ss:weapons/ss:weapon[@name=$weapon]/ss:mount[@name=$mount]"/>

                <xsl:apply-templates select="document('weapons.xml')/ss:weapons/ss:weapon[@name=$weapon]/ss:mount[@name=$mount]/ss:stat[@tech=$tl]"/>
            </xsl:if>
        </tr>
    </xsl:template>

    <!-- Doesn't quite work, new table row needed.
    <xsl:template match="ss:weapon">
        <xsl:variable name="weapon" select="@type"/>
        <xsl:variable name="mount" select="../@type"/>

        <xsl:variable name="tl">
            <xsl:choose>
                <xsl:when test="@techLevel">
                    <xsl:value-of select="@techLevel"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="../../../ss:attributes/ss:techLevel"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="wpn" select="document('weapons.xml')/ss:weapons/ss:weapon[@name=$weapon]/ss:mount[@name=$mount]"/>

        <xsl:apply-templates select="document('weapons.xml')/ss:weapons/ss:weapon[@name=$weapon]/ss:mount[@name=$mount]/ss:stat[@tech=$tl]"/>
    </xsl:template>
    -->

    <xsl:template match="ss:stat">
        <td><xsl:value-of select="@name"/></td>
        <td><xsl:value-of select="@tech"/></td>
        <td><xsl:value-of select="@atk"/></td>
        <td><xsl:value-of select="@dmg"/></td>
        <td><xsl:value-of select="../@size"/>/<xsl:value-of select="@size"/></td>
        <td><xsl:value-of select="@inc"/>"</td>
        <td><xsl:value-of select="@short"/>"</td>
    </xsl:template>

</xsl:stylesheet>
