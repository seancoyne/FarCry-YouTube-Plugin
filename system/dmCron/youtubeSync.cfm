<cfsetting enablecfoutputonly="true" requesttimeout="600" />
<!--- @@displayname: YouTube Video Sync --->
<!--- @@author: Sean Coyne (http://www.n42designs.com/) --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />

<!--- don't run this concurrently --->
<cftry>
	<cflock name="youTubeSync" timeout="5">
		
		<cfset application.fapi.getContentType("youtubeVideo").sync() />
		
	</cflock>
	<cfcatch>
		<!--- probably already running --->
		<cfdump var="#cfcatch#" />
	</cfcatch>
</cftry>

<cfsetting enablecfoutputonly="false" />