<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Standard Teaser --->
<!--- @@author: Sean Coyne (http://www.n42designs.com/) --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />

<cfset thumbURL = "" />
<cfloop array="#stobj.aVideos#" index="videoId">
	<cfset stVideo = application.fapi.getContentObject(typename = "youtubeVideo", objectid = videoId) />
	<cfif len(trim(stVideo.thumbnail_url))>
		<cfset thumbURL = stVideo.thumbnail_url />
		<cfbreak />
	</cfif>
</cfloop>

<cfoutput>
	<div class="youtubePlaylistTeaser">
		<h3><cfif len(trim(thumbURL))><skin:buildlink objectid="#stobj.objectid#"><img src="#thumbURL#" alt="#stobj.title#" /></skin:buildLink> </cfif><skin:buildLink objectid="#stobj.objectid#">#stobj.title#</skin:buildLink></h3>
		<cfif len(trim(stobj.content))>
			<p>#application.stPlugins.youtube.oCustomFunctions.xhtmlParagraphFormat(stobj.content)#</p>
		</cfif>
		<p>#arrayLen(stobj.aVideos)# videos</p>
	</div>
</cfoutput>

<cfsetting enablecfoutputonly="false" />