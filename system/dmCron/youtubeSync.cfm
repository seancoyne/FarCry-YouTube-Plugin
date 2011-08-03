<cfsetting enablecfoutputonly="true" requesttimeout="600" />
<!--- @@displayname: YouTube Video Sync --->
<!--- @@author: Sean Coyne (http://www.n42designs.com/) --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />

<cfset oPlaylist = application.fapi.getContentType("youtubePlaylist") />
<cfset oVideo = application.fapi.getContentType("youtubeVideo") />

<!--- don't run this concurrently --->
<cftry>
	<cflock name="youTubeSync" timeout="5">

		<!--- load the playlists --->
		<cfset qPlaylists = application.stPlugins.youtube.oYouTube.getPlaylists(user = application.fapi.getConfig(key = 'youtube', name = 'username')) />
		
		<cfset stPlaylistVideos = {} />
		
		<!--- loop over the playlists, if found, update, if not, create it --->
		<cfloop query="qPlaylists">
				
			<cfset stPlaylist = oPlaylist.saveFromAPI(application.stPlugins.youtube.oCustomFunctions.queryRowToStruct(qPlaylists,qPlaylists.currentRow)) />
			
			<!--- load the videos for this playlist --->
			<cfset qVideos = application.stPlugins.youtube.oYouTube.getPlaylist(plurl = qPlaylists.url[qPlaylists.currentRow]) />
			
			<!--- save a copy of the query for use later --->
			<cfset stPlaylistVideos[stPlaylist.objectid] = duplicate(qVideos) />
			
			<!--- loop over the videos, if found, update, if not, create it --->
			<cfloop query="qVideos">
				
				<cfset stVideo = oVideo.saveFromAPI(application.stPlugins.youtube.oCustomFunctions.queryRowToStruct(qVideos,qVideos.currentRow)) />
				
				<!--- add it to the playlist (if necessary) ---->
				<cfif not oPlaylist.playlistContainsVideo(playlistId = stPlaylist.objectId, videoId = stVideo.objectId)>
					
					<cfset oPlaylist.addVideoToPlaylist(playlistId = stPlaylist.objectId, videoId = stVideo.objectId) />
					
				</cfif>
				
			</cfloop>
			
		</cfloop>
		
		<!--- get the user's videos that aren't on playlists and add/update those --->
		
		<!--- first, get all the user's videos --->
		<cfset qUserVideos = application.stPlugins.youtube.oYouTube.getVideosByUser(username = application.fapi.getConfig(key = 'youtube', name = 'username')) />	
		
		<!--- filter out the videos that are on playlists (they have already been processed --->
		<cfquery name="qNonPlaylistVideos" dbtype="query">
			select * from qUserVideos where
			1 = 1
			<cfloop collection="#stPlaylistVideos#" item="playlistId">
				<cfset q = stPlaylistVideos[playlistId] />
				and id not in (<cfqueryparam list="true" cfsqltype="cf_sql_varchar" value="#valueList(q.id)#" />)
			</cfloop>
		</cfquery>
		<!--- save a copy of this for use later (deletion phase) --->
		<cfset stPlaylistVideos["noplaylist"] = duplicate(qNonPlaylistVideos) />
		
		<!--- add/update the videos that aren't on playlists --->
		<cfloop query="qNonPlaylistVideos">
			<cfset stVideo = oVideo.saveFromAPI(application.stPlugins.youtube.oCustomFunctions.queryRowToStruct(qNonPlaylistVideos,qNonPlaylistVideos.currentRow)) />
		</cfloop>
		
		<!--- now, check for FarCry records that have no matching record from the API.  If found, it was removed, so delete from FarCry --->
		
		<!--- get the playlist records from FarCry --->
		<cfset qPlaylistRecords = application.fapi.getContentObjects(typename = "youtubePlaylist", lProperties = "objectid, playlistid") />
		
		<!--- grab the ones that aren't in the API data --->
		<cfquery name="qPlaylistsToDelete" dbtype="query">
			select objectid from qPlaylistRecords where playlistid not in (<cfqueryparam list="true" cfsqltype="cf_sql_varchar" value="#valueList(qPlaylists.playlistid)#" />)
		</cfquery>
		
		<!--- delete 'em --->
		<cfloop query="qPlaylistsToDelete">
			<cfset oPlaylist.deleteData(objectid = qPlaylistsToDelete.objectid[qPlaylistsToDelete.currentRow]) />	
		</cfloop>
		
		<!--- get the video records from FarCry --->
		<cfset qVideoRecords = application.fapi.getContentObjects(typename = "youtubeVideo", lProperties = "objectid, id") />
		
		<!--- grab the ones that aren't in the API data --->
		<cfquery name="qVideosToDelete" dbtype="query">
			select objectid from qVideoRecords where
			 
			1 = 1
			
			<cfloop collection="#stPlaylistVideos#" item="playlistId">
				<cfset q = stPlaylistVideos[playlistId] />
				and id not in (<cfqueryparam list="true" cfsqltype="cf_sql_varchar" value="#valueList(q.id)#" />)
			</cfloop>
			
		</cfquery>
		
		<!--- delete 'em --->
		<cfloop query="qVideosToDelete">
			
			<!--- delete it from any playlists --->
			<cfset oPlaylist.removeVideoFromAllPlaylists(qVideosToDelete.objectid[qVideosToDelete.currentRow]) />
			
			<!--- delete the record --->
			<cfset oVideo.deleteData(objectid = qVideosToDelete.objectid[qVideosToDelete.currentRow]) />
			
		</cfloop>
		
	</cflock>
	<cfcatch>
		<!--- probably already running --->
		<cfdump var="#cfcatch#" />
	</cfcatch>
</cftry>

<cfsetting enablecfoutputonly="false" />