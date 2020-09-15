<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Body --->
<!--- @@author: Sean Coyne (http://www.n42designs.com/) --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />

<!--- ensure all the videos listed actually exist --->
<cfloop from="#arrayLen(stobj.aVideos)#" to="1" index="i" step="-1">
	<cfif application.fapi.findType(stobj.aVideos[i]) neq "youtubeVideo">
		<cfset arrayDeleteAt(stobj.aVideos,i) />
	</cfif>	
</cfloop>

<skin:pagination array="#stobj.aVideos#" typename="youtubeVideo">	
	<skin:view typename="youtubeVideo" objectid="#stObject.objectId#" webskin="displayTeaserEmbeddedVideo" />
</skin:pagination>

<cfsetting enablecfoutputonly="false" />