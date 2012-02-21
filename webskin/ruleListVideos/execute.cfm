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
			<!--- ensure the video exists --->
			<cfif application.fapi.findType(videoId) eq "youtubeVideo">
				<cfset arrayAppend(aVideosToDisplay, videoId) />
			</cfif>
		</cfloop>
	</cfloop>
<cfelseif arrayLen(stobj.aVideos)>
	<cfloop array="#stobj.aVideos#" index="videoId">
		<!--- ensure the video exists --->
		<cfif application.fapi.findType(videoId) eq "youtubeVideo">
			<cfset aVideosToDisplay = stobj.aVideos />
		</cfif>
	</cfloop>
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