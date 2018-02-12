<?xml version="1.0" encoding="UTF-8"?>
<!-- Edited with oXygen 6.2 -->
<!-- Last update by Zorba on 2007/04/24 -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:variable name="image_prefix">./items/BTN</xsl:variable>
	<xsl:output method="html"/>
	<xsl:template match="/">
		<HTML>
			<HEAD/>
			<TITLE>
				<xsl:text>DOTA Allstars Items and Recipes Table </xsl:text>
				<xsl:value-of select="items/@version"/>
			</TITLE>
			<BODY>
				<xsl:apply-templates/>
			</BODY>
		</HTML>
	</xsl:template>
	<!-- Recipes tables -->
	<xsl:template match="shop[count(*/requires) > 0]">
		<TABLE width="100%" border="1">
			<TBODY>
				<TR>
					<TH width="20%"><xsl:value-of select="@name"/></TH>
					<TH width="35%">Items Required / Costs</TH>
					<TH width="45%">Properties</TH>
				</TR>
				<xsl:apply-templates mode="recipe"/>					
			</TBODY>
		</TABLE>
		<HR size="12"/>
	</xsl:template>
	<!-- Basic items tables -->
	<xsl:template match="shop">
		<TABLE width="100%" border="1">
			<TBODY>
				<TR><TH colspan="4"><xsl:value-of select="@name"/></TH></TR>
				<xsl:for-each select="item[position() mod 4 =1]">
					<xsl:call-template name="fourItems">
						<xsl:with-param name="item" select="."></xsl:with-param>
					</xsl:call-template>
				</xsl:for-each>
			</TBODY>
		</TABLE>
		<HR size="12"/>
	</xsl:template>	
	<!-- Table row for recipe -->
	<xsl:template match="item" mode="recipe">
		<TR>
			<!-- Item name and icon -->
			<TD align="center">
				<P><A><xsl:attribute name="name"><xsl:value-of select="@name"/></xsl:attribute>
					<B><xsl:value-of select="@name"/></B></A>
					(<xsl:call-template name="total-cost">
						<xsl:with-param name="item" select="."/>
					</xsl:call-template>)
				</P>
				<P>
					<xsl:call-template name="itemImage">
						<xsl:with-param name="item" select="."/>
					</xsl:call-template>
				</P>
			</TD>
			<!-- Dependencies -->
			<TD align="center">
				<xsl:if test="requires">
					<!-- images of componants -->
					<xsl:for-each select="requires">
						<xsl:if test="position() &gt; 1"> + </xsl:if>
						<xsl:variable name="requiredName" select="text()"/>
						<xsl:variable name="requiredItem" select="/items/shop/item[@name=$requiredName]"/>
						<A>
							<xsl:attribute name="href">#<xsl:value-of select="$requiredItem/@name"/></xsl:attribute>
							<xsl:attribute name="title"><xsl:value-of select="$requiredItem/@name"/></xsl:attribute>
							<xsl:call-template name="itemImageOf">
								<xsl:with-param name="itemName" select="$requiredItem/@name"/>
							</xsl:call-template>
						</A>
					</xsl:for-each>
					<!-- Recipe scroll -->
					<xsl:if test="@cost &gt; 0"> + 
						<xsl:element name="IMG">
							<xsl:attribute name="name">Recipe</xsl:attribute>
							<xsl:attribute name="alt">Recipe</xsl:attribute>
							<xsl:attribute name="src"><xsl:value-of select="$image_prefix"/>SnazzyScroll.gif</xsl:attribute>
						</xsl:element>						
					</xsl:if>
					<!-- descriptions of componants -->
					<TABLE width="95%" align="center"><TBODY>
						<xsl:for-each select="requires">
							<xsl:variable name="requiredName" select="text()"/>
							<xsl:variable name="requiredItem" select="/items/shop/item[@name=$requiredName]"/>
							<TR>
								<TD><xsl:value-of select="text()"/></TD>
								<TD>
									<xsl:call-template name="total-cost">
										<xsl:with-param name="item" select="$requiredItem"/>
									</xsl:call-template>
								</TD>
							</TR>
						</xsl:for-each>
						<xsl:if test="@cost &gt; 0">
							<TR>
								<TD><xsl:value-of select="@name"/> recipe</TD>
								<TD><xsl:value-of select="@cost"/></TD>
							</TR>
						</xsl:if>
					</TBODY></TABLE>
				</xsl:if>
			</TD>
			<!-- Properties -->
			<TD>
				<xsl:apply-templates select="." mode="properties"/>
				<P><xsl:call-template name="used-in">
					<xsl:with-param name="item" select="."/>
				</xsl:call-template></P>
			</TD>
		</TR>
	</xsl:template>
	<!-- Table row for basic item -->
	<xsl:template match="item" mode="basic">
		<TD width="25%">
			<TABLE width="100%" align="top"><TBODY><TR>
				<TD><P><A><xsl:attribute name="name"><xsl:value-of select="@name"/></xsl:attribute>
					<B><xsl:value-of select="@name"/></B></A>
				</P></TD>
				<TD><xsl:value-of select="@cost"/></TD>
			</TR></TBODY></TABLE>
			<TABLE width="100%"><TBODY><TR>
				<TD width="10%">
					<xsl:call-template name="itemImage">
						<xsl:with-param name="item" select="."/>
					</xsl:call-template>
				</TD>
				<TD width="90%">
					<xsl:apply-templates select="." mode="properties"/>
					<BR/>
					<xsl:call-template name="used-in">
						<xsl:with-param name="item" select="."/>
						<xsl:with-param name="text" select="'In '"/>
					</xsl:call-template>
				</TD>
			</TR></TBODY></TABLE>
		</TD>
	</xsl:template>
	<!-- Properties of item -->
	<xsl:template match="item" mode="properties">
		<xsl:choose>
			<xsl:when test="@str = @int and @int = @agi"> + <xsl:value-of select="@str"/> all stats,</xsl:when>
			<xsl:otherwise>
				<xsl:if test="@str"> +<xsl:value-of select="@str"/> str,</xsl:if>
				<xsl:if test="@int"> +<xsl:value-of select="@int"/> int,</xsl:if>
				<xsl:if test="@agi"> +<xsl:value-of select="@agi"/> agi,</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="@damage"> +<xsl:value-of select="@damage"/> dmg,</xsl:if>
		<xsl:if test="@armor"> +<xsl:value-of select="@armor"/> armor,</xsl:if>
		<xsl:if test="@life"> +<xsl:value-of select="@life"/> hp,</xsl:if>
		<xsl:if test="@mana"> +<xsl:value-of select="@mana"/> mana,</xsl:if>
		<xsl:if test="@moveSpeed"> +<xsl:value-of select="@moveSpeed"/> run speed,</xsl:if>
		<xsl:if test="@attackSpeed"> +<xsl:value-of select="@attackSpeed"/>% attack speed,</xsl:if>
		<xsl:if test="@hitRegen"> + <xsl:value-of select="@hitRegen"/> hp/sec regen,</xsl:if>
		<xsl:if test="@manaRegen"> +<xsl:value-of select="@manaRegen"/>% mana regen,</xsl:if>
		<xsl:apply-templates select="special"/>
	</xsl:template>	
	<!-- Special properties -->
	<xsl:template match="special">
		<p>
			<xsl:choose>
				<xsl:when test="@type = 'Activate'"><B>Activated</B>
					<xsl:if test="@mana"> (<xsl:value-of select="@mana"/> mana, <xsl:value-of
						select="@cooldown"/> sec cooldown)</xsl:if> : 
				</xsl:when>
				<xsl:when test="@type = 'Aura'"><B>Aura : </B></xsl:when>
				<xsl:when test="@type = 'Effect'"><B>Effect : </B></xsl:when>
				<xsl:when test="@type = 'Orb'"><B>Orb Effect : </B></xsl:when>
			</xsl:choose>
			<xsl:if test="@chance != 100"><xsl:value-of select="@chance"/>% chance </xsl:if>
			<xsl:value-of select="text()"/>
		</p>		
	</xsl:template>
	<!-- 4 basic items / row -->
	<xsl:template name="fourItems">
		<xsl:param name="item"/>
		<TR>
			<xsl:apply-templates select="$item" mode="basic"/>
			<xsl:apply-templates select="$item/following-sibling::*[position() &lt; 4]" mode="basic"/>
		</TR>
	</xsl:template>
	<!-- Item's image (via a node) -->
	<xsl:template name="itemImage">
		<xsl:param name="item"/>
		<xsl:param name="width" select="64"/>
		<xsl:param name="height" select="64"/>
		<xsl:if test="$item/@image">
			<xsl:element name="IMG">
				<xsl:attribute name="border">0</xsl:attribute>
				<xsl:attribute name="alt"><xsl:value-of select="$item/@name"/></xsl:attribute>
				<xsl:attribute name="src"><xsl:value-of select="$image_prefix"/><xsl:value-of select="$item/@image"/></xsl:attribute>
				<xsl:attribute name="width"><xsl:value-of select="$width"/></xsl:attribute>
				<xsl:attribute name="height"><xsl:value-of select="$height"/></xsl:attribute>
			</xsl:element>
		</xsl:if>
	</xsl:template>	
	<!-- Item's image (via his name) -->
	<xsl:template name="itemImageOf">
		<xsl:param name="itemName"/>
		<xsl:variable name="item" select="/items/shop/item[@name=$itemName]"/>
		<xsl:element name="IMG">
			<xsl:attribute name="border">0</xsl:attribute>
			<xsl:attribute name="name"><xsl:value-of select="$item/@name"/></xsl:attribute>
			<xsl:attribute name="alt"><xsl:value-of select="$item/@name"/></xsl:attribute>
			<xsl:attribute name="src"><xsl:value-of select="$image_prefix"/><xsl:value-of select="$item/@image"/></xsl:attribute>
		</xsl:element>
	</xsl:template>	
	<!-- Item is used by -->
	<xsl:template name="used-in">
		<xsl:param name="item"/>
		<xsl:param name="text" select="'Used in : '"/>
		<xsl:for-each select="//item[requires = $item/@name]">
			<xsl:if test="position() = 1"><i><xsl:value-of select="$text"/></i></xsl:if>
			<A>
				<xsl:attribute name="href">#<xsl:value-of select="@name"/></xsl:attribute>
				<xsl:call-template name="itemImage">
					<xsl:with-param name="item" select="."/>
					<xsl:with-param name="height" select="32"/>
					<xsl:with-param name="width" select="32"/>
				</xsl:call-template>
			</A>
			<xsl:text> </xsl:text>
		</xsl:for-each>
	</xsl:template>
	<!-- item/@cost + require-costs(item) -->
	<xsl:template name="total-cost">
		<xsl:param name="item"/>
		<xsl:variable name="requiredCost">
			<xsl:call-template name="require-costs">
				<xsl:with-param name="item" select="$item"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:value-of select="$requiredCost+$item/@cost"/>
	</xsl:template>
	<!-- sum of total-cost(item/requires) -->
	<xsl:template name="require-costs">
		<xsl:param name="item"/>
		<xsl:param name="i" select="1"/>
		<xsl:param name="cost" select="0"/>
		<xsl:choose>
			<xsl:when test="$item/requires[position()=$i]">
				<xsl:variable name="requiredName" select="$item/requires[position()=$i]"/>
				<xsl:variable name="requiredItem" select="/items/shop/item[@name=$requiredName]"/>
				<xsl:variable name="requiredCost">
					<xsl:call-template name="total-cost">
						<xsl:with-param name="item" select="$requiredItem"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:call-template name="require-costs">
					<xsl:with-param name="item" select="$item"/>
					<xsl:with-param name="i" select="$i+1"/>
					<xsl:with-param name="cost">
						<xsl:value-of select="$cost+$requiredCost"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$cost"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
