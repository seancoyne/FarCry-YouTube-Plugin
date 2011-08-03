<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: List Videos --->
<!--- @@author: Sean Coyne (http://www.n42designs.com/) --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />
<cfimport taglib="/farcry/core/tags/formtools" prefix="ft" />

<cfset aVideosToDisplay = [] />

<cfif arrayLen(stobj.aPlaylists)>
	<cfloop array="#stobj.aPlaylists#" index="playlistId">
		<cfset stPlaylist = application.fapi.getContentObject(typename = "youtubePlaylist", objectid = playlistId) />
		<cfloop array="#stPlaylist.aVideos#" index="videoId">
			<cfset arrayAppend(aVideosToDisplay, videoId) />
		</cfloop>
	</cfloop>
<cfelseif arrayLen(stobj.aVideos)>
	<cfset aVideosToDisplay = stobj.aVideos />
</cfif>

<cfif arrayLen(aVideosToDisplay)>
	
	<cfoutput><div class="ruleListVideos"></cfoutput>
	
	<cfif stobj.bShowTitle>
		<cfoutput><h3>#stobj.title#</h3></cfoutput>
	</cfif>

	<cfloop array="#aVideosToDisplay#" index="videoId">
		<skin:view objectid="#videoId#" typename="youtubeVideo" webskin="displayTeaserStandard" bShowDescription="#stobj.bShowDescriptions#" />
	</cfloop>
	
	<cfoutput></div></cfoutput>
		
</cfif>

<cfsetting enablecfoutputonly="false" />