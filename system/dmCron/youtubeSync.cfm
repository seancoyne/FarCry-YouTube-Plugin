<cfsetting enablecfoutputonly="true" requesttimeout="1200" />
<!--- @@displayname: YouTube Video Sync --->
<!--- @@author: Sean Coyne (http://www.n42designs.com/) --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />

<!--- don't run this concurrently --->
<cftry>
	<cflock name="youTubeSync" timeout="5" throwontimeout="true">
		<cflog application="true" file="youtube" type="information" text="Starting YouTube sync..." />
		<cftry>
			<cfset application.fapi.getContentType("youtubeVideo").sync() />
			<cfcatch>
				<cfsetting requesttimeout="1220" />
				<cflog application="true" file="youtube" type="error" text="Error running YouTube sync (1).  Error was: #cfcatch.message#" />
			</cfcatch>
		</cftry>
		<cflog application="true" file="youtube" type="information" text="YouTube sync complete!" />
		<cfoutput><p>Complete!</p></cfoutput>
	</cflock>
	<cfcatch>
		<!--- probably already running --->
		<!--- <cfdump var="#cfcatch#" /> --->
		<cflog application="true" file="youtube" type="error" text="Error running YouTube sync (2).  Error was: #cfcatch.message#" />
	</cfcatch>
</cftry>

<cfsetting enablecfoutputonly="false" />