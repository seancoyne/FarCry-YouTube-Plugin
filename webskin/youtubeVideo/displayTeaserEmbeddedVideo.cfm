<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Embedded Video --->
<!--- @@author: Sean Coyne (sean@n42designs.com) --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />

<!--- parse the video ID from the link --->
<cfset videoId = application.stPlugins.youtube.oCustomFunctions.queryStringGetVar(stobj.link,"v") />

<cfoutput>
<!--- display the embed code --->
<div class="youtubeVideo">
#application.stPlugins.youtube.oYouTube.getEmbedCode(videoId)#
</div>
</cfoutput>

<cfsetting enablecfoutputonly="false" />