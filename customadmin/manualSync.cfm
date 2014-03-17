<cfsetting enablecfoutputonly="true" requesttimeout="600" />
<!--- @@displayname: Manually Sync from API --->
<!--- @@author: Sean Coyne (sean@n42designs.com) --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />
<cfimport taglib="/farcry/core/tags/admin" prefix="admin" />

<admin:header title="Manual Sync" />

<cfif structKeyExists(url,"sync")>
	<!--- don't run this concurrently --->
	<cftry>
		<cflock name="youTubeSync" timeout="5" throwontimeout="true">
			<cflog application="true" file="youtube" type="information" text="Starting Manual YouTube sync..." />
			<cftry>
				<cfset application.fapi.getContentType("youtubeVideo").sync() />
				<cfcatch>
					<cfsetting requesttimeout="1220" />
					<cflog application="true" file="youtube" type="error" text="Error running  Manual YouTube sync (1).  Error was: #cfcatch.message#" />
				</cfcatch>
			</cftry>
			<cflog application="true" file="youtube" type="information" text=" Manual YouTube sync complete!" />
			<cfoutput><p>Complete!</p></cfoutput>
		</cflock>
		<cfcatch>
			<!--- probably already running --->
			<cfdump var="#cfcatch#" />
			<cflog application="true" file="youtube" type="error" text="Error running  Manual YouTube sync (2).  Error was: #cfcatch.message#" />
		</cfcatch>
	</cftry>
<cfelse>
	<cfoutput><p>This will manually re-sync the videos from the YouTube API.  Be warned, this can take a while.  <a href="./customadmin.cfm?module=#url.module#&amp;plugin=#url.plugin#&amp;sync=1">Continue</a> when ready.</p></cfoutput>	
</cfif>

<admin:footer />

<cfsetting enablecfoutputonly="false" />