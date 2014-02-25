<cfsetting enablecfoutputonly="true" requesttimeout="1200" />
<!--- @@displayname: YouTube Video Sync --->
<!--- @@author: Sean Coyne (http://www.n42designs.com/) --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />

<!--- don't run this concurrently --->
<cftry>
	<cflock name="youTubeSync" timeout="5">
		<cfset application.fapi.getContentType("youtubeVideo").sync() />
		<cfoutput>Complete!</cfoutput>
	</cflock>
	<cfcatch>
		<!--- probably already running --->
		<cfdump var="#cfcatch#" />
	</cfcatch>
</cftry>

<cfsetting enablecfoutputonly="false" />