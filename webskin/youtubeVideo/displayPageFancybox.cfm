<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Display in Fancybox --->
<!--- @@author: Sean Coyne (http://www.n42designs.com/) --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />

<!--- parse the video ID from the link --->
<cfset videoId = application.stPlugins.youtube.oCustomFunctions.queryStringGetVar(stobj.link,"v") />

<cfoutput>#application.stPlugins.youtube.oYouTube.getEmbedCode(videoId)#</cfoutput>

<cfsetting enablecfoutputonly="false" />