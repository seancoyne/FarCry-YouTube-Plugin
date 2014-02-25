<cfsetting enablecfoutputonly="true" requesttimeout="600" />
<!--- @@displayname: Manually Sync from API --->
<!--- @@author: Sean Coyne (sean@n42designs.com) --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />
<cfimport taglib="/farcry/core/tags/admin" prefix="admin" />

<admin:header title="Manual Sync" />

<cfif structKeyExists(url,"sync")>
	<cfset application.fapi.getContentType("youtubeVideo").sync() />
	<cfoutput><p>Complete!</p></cfoutput>
<cfelse>
	<cfoutput><p>This will manually re-sync the videos from the YouTube API.  Be warned, this can take a while.  <a href="./customadmin.cfm?module=#url.module#&amp;plugin=#url.plugin#&amp;sync=1">Continue</a> when ready.</p></cfoutput>	
</cfif>

<admin:footer />

<cfsetting enablecfoutputonly="false" />