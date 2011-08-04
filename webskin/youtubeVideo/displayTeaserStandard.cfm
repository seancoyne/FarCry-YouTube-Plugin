<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Standard Teaser --->
<!--- @@author: Sean Coyne (http://www.n42designs.com/) --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />

<skin:loadJs id="jquery" />
<skin:loadJs id="fancybox" />
<skin:loadJs id="youtube" />

<skin:loadCss id="fancybox" />

<cfparam name="stParam.bShowDescription" type="boolean" default="true" />
	
<cfoutput>
	<div class="youtubeVideoTeaser">
		<h3></cfoutput>
		
		<cfif len(trim(stobj.thumbnail_url))>
			<skin:buildlink objectid="#stobj.objectid#" view="displayPageFancybox" class="fancybox">
				<cfoutput><img src="#stobj.thumbnail_url#" alt="#xmlFormat(stobj.title)#" /></cfoutput>
			</skin:buildlink>
		</cfif>
		
		<skin:buildlink objectid="#stobj.objectid#" linkText="#stobj.title#" />
		
		<cfoutput></h3>
		<cfif stParam.bShowDescription eq true><p>#application.stPlugins.youtube.oCustomFunctions.abbreviate(stobj.description)#</p></cfif>
	</div>
</cfoutput>

<cfsetting enablecfoutputonly="false" />