<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Embed Video --->
<!--- @@author: Sean Coyne (sean@n42designs.com) --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />

<!--- ensure the video exists --->
<cfif application.fapi.findType(stobj.video) eq "youtubeVideo"> 
	<skin:view objectid="#stobj.video#" typename="youtubeVideo" webskin="displayTeaserEmbeddedVideo" />
</cfif>

<cfsetting enablecfoutputonly="false" />