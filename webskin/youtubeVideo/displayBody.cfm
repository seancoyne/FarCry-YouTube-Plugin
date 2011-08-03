<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Body --->
<!--- @@author: Sean Coyne (http://www.n42designs.com/) --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />

<!--- parse the video ID from the link --->
<cfset videoId = application.stPlugins.youtube.oCustomFunctions.queryStringGetVar(stobj.link,"v") />

<cfoutput>
	<h2>#stobj.title#</h2>
	
	<cfif len(trim(stobj.description))>
	<p>#application.stPlugins.youtube.oCustomFunctions.xhtmlParagraphFormat(stobj.description)#</p>
	</cfif>
	
	<!--- display the embed code --->
	<div class="youtubeVideo">
	#application.stPlugins.youtube.oYouTube.getEmbedCode(videoId)#
	</div>
	
</cfoutput>

<cfsetting enablecfoutputonly="false" />