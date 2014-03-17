<cfcomponent output="false" extends="farcry.core.packages.types.types" fuAlias="video" displayname="YouTube Video" hint="Manages videos imported from YouTube" bFriendly="true" bObjectBroker="true">
	
	<cfproperty ftSeq="100" ftFieldset="Video" ftLabel="ID" ftDisplayOnly="true" name="id" type="nstring" ftType="string" default="" />
	<cfproperty ftSeq="110" ftFieldset="Video" ftLabel="Title" ftDisplayOnly="true" name="title" bLabel="true" type="nstring" ftType="string" default="" />
	<cfproperty ftSeq="120" ftFieldset="Video" ftLabel="Author" ftDisplayOnly="true" name="author" type="nstring" ftType="string" default="" />
	<cfproperty ftSeq="130" ftFieldset="Video" ftLabel="Author URL" ftDisplayOnly="true" name="authorurl" type="nstring" ftType="url" default="" />
	<cfproperty ftSeq="140" ftFieldset="Video" ftLabel="Description" ftDisplayOnly="true" name="description" type="longchar" ftType="longchar" default="" />
	<cfproperty ftSeq="150" ftFieldset="Video" ftLabel="Content" ftDisplayOnly="true" name="content" type="longchar" ftType="longchar" default="" />
	<cfproperty ftSeq="160" ftFieldset="Video" ftLabel="Categories" ftDisplayOnly="true" name="categories" type="longchar" ftType="longchar" default="" />
	<cfproperty ftSeq="170" ftFieldset="Video" ftLabel="Keywords" ftDisplayOnly="true" name="keywords" type="longchar" ftType="longchar" default="" />
	<cfproperty ftSeq="180" ftFieldset="Video" ftLabel="Link" ftDisplayOnly="true" name="link" type="nstring" ftType="url" default="" />
	<cfproperty ftSeq="190" ftFieldset="Video" ftLabel="Duration" ftDisplayOnly="true" name="duration" type="nstring" ftType="string" default="" />
	
	<cfproperty ftSeq="200" ftFieldset="Status" ftLabel="Video Status" ftDisplayOnly="true" name="videostatus" type="nstring" ftType="string" default="public" />
	<cfproperty ftSeq="210" ftFieldset="Status" ftLabel="Published (YouTube)" ftDisplayOnly="true" name="published" type="date" ftType="datetime" default="" />
	<cfproperty ftSeq="225" ftFieldset="Status" ftLabel="Updated (YouTube)" ftDisplayOnly="true" name="updated" type="date" ftType="datetime" default="" />
	
	<cfproperty ftSeq="300" ftFieldset="Statistics" ftLabel="Favorite Count" ftDisplayOnly="true" name="favoritecount" type="integer" ftType="integer" default="0" />
	<cfproperty ftSeq="310" ftFieldset="Statistics" ftLabel="View Count" ftDisplayOnly="true" name="viewcount" type="integer" ftType="integer" default="0" />
	<cfproperty ftSeq="320" ftFieldset="Statistics" ftLabel="Total" ftDisplayOnly="true" name="total" type="integer" ftType="integer" default="0" />

	<cfproperty ftSeq="400" ftFieldset="Comments" ftLabel="Num. Comments" ftDisplayOnly="true" name="numcomments" type="integer" ftType="integer" default="0" />
	<cfproperty ftSeq="410" ftFieldset="Comments" ftLabel="Comments URL" ftDisplayOnly="true" name="commentsurl" type="nstring" ftType="url" default="" />
	
	<cfproperty ftSeq="500" ftFieldset="Ratings" ftLabel="Num. Ratings" ftDisplayOnly="true" name="numratings" type="integer" ftType="integer" default="0" />
	<cfproperty ftSeq="510" ftFieldset="Ratings" ftLabel="Avg. Rating" ftDisplayOnly="true" name="averagerating" type="numeric" ftType="numeric" default="0" />
	
	<cfproperty ftSeq="600" ftFieldset="Thumbnail" ftLabel="Thumb. Height" ftDisplayOnly="true" name="thumbnail_height" type="integer" ftType="integer" default="0" />
	<cfproperty ftSeq="610" ftFieldset="Thumbnail" ftLabel="Thumb. URL" ftDisplayOnly="true" name="thumbnail_url" type="nstring" ftType="url" default="" />
	<cfproperty ftSeq="620" ftFieldset="Thumbnail" ftLabel="Thumb. Width" ftDisplayOnly="true" name="thumbnail_width" type="integer" ftType="integer" default="0" />
	
	<cffunction name="onDelete" returntype="void" access="public" output="false" hint="Is called after the object has been removed from the database">
		<cfargument name="typename" type="string" required="true" hint="The type of the object" />
		<cfargument name="stObject" type="struct" required="true" hint="The object" />
		
		<!--- remove all references to this video from playlists and rules --->
		
		<!--- playlists --->
		<cfset application.fapi.getContentType("youtubePlaylist").removeVideoFromAllPlaylists(arguments.stobject.objectid) />
		
		<!--- rules --->
		<cfset application.fapi.getContentType("ruleEmbedVideo").cleanUp() />
		<cfset application.fapi.getContentType("ruleListVideos").cleanUp() />
		
		<cfreturn super.onDelete(argumentCollection = arguments) />
	</cffunction>
	
	<cffunction name="updateFromAPI" access="public" output="false" returntype="struct" hint="Updates a FarCry record with data from the YouTube API">
		<cfargument name="data" type="struct" required="true" />
		<cfset var st = getVideoByLink(arguments.data.link) />
		<cfset var key = "" />
		<cfloop collection="#arguments.data#" item="key">
			<cfset st[key] = arguments.data[key] />
		</cfloop>
		<cfset st.label = st.title />
		<cfset var stResult = setData(st) />
		<cfreturn getData(st.objectid) />
	</cffunction>
	
	<cffunction name="createFromAPI" access="public" output="false" returntype="struct" hint="Creates a new FarCry record from data from the YouTube API">
		<cfargument name="data" type="struct" required="true" />
		<cfset arguments.data.label = arguments.data.title />
		<cfset var stResult = createData(arguments.data) />
		<cfset var stVideo = getData(stResult.objectid) />
		<cfreturn afterSave(stVideo) />
	</cffunction>
	
	<cffunction name="saveFromAPI" access="public" output="false" returntype="struct" hint="Saves a new FarCry record from data from the YouTube API">
		<cfargument name="data" type="struct" required="true" />
		<cfif videoExists(arguments.data.link)>
			<cfreturn updateFromAPI(data = arguments.data) />
		<cfelse>
			<cfreturn createFromAPI(data = arguments.data) />
		</cfif>
	</cffunction>
	
	<cffunction name="videoExists" access="public" output="false" returntype="boolean" hint="Returns true if the video exists">
		<cfargument name="link" type="string" required="true" />
		<cfset var q = application.fapi.getContentObjects(typename = "youtubeVideo",lProperties = "objectid", maxrows = 1, orderby = "datetimelastupdated desc", link_eq = arguments.link) />
		<cfreturn q.recordCount />
	</cffunction>
		
	<cffunction name="getVideoByLink" access="public" output="false" returntype="struct" hint="Returns the video identified by the Link from the API">
		<cfargument name="link" type="string" required="true" />
		<cfset var q = application.fapi.getContentObjects(typename = "youtubeVideo",lProperties = "objectid", maxrows = 1, orderby = "datetimelastupdated desc", link_eq = arguments.link) />
		<cfif q.recordCount>
			<cfreturn getData(q.objectid[1]) />
		<cfelse>
			<cfreturn {} />
		</cfif>
	</cffunction>	
	
	<cffunction name="sync" access="public" output="false" returntype="void" hint="Syncs the FarCry database with the results from the API">
		
		<cfset var q = "" />
		<cfset var stVideo = "" />
		<cfset var playlistId = "" />
		<cfset var oPlaylist = application.fapi.getContentType("youtubePlaylist") />
			
		<!--- load the playlists --->
		<cfset var qPlaylists = application.stPlugins.youtube.oYouTube.getPlaylists(user = application.fapi.getConfig(key = 'youtube', name = 'username'), max = 50) />
		
		<cfset var stPlaylistVideos = {} />
		
		<!--- loop over the playlists, if found, update, if not, create it --->
		<cfloop query="qPlaylists">
				
			<cfset var stPlaylist = oPlaylist.saveFromAPI(application.stPlugins.youtube.oCustomFunctions.queryRowToStruct(qPlaylists,qPlaylists.currentRow)) />
			
			<!--- load the videos for this playlist --->
			<cfset var qVideos = application.stPlugins.youtube.oYouTube.getPlaylist(plurl = qPlaylists.url[qPlaylists.currentRow]) />
			
			<!--- save a copy of the query for use later --->
			<cfset stPlaylistVideos[stPlaylist.objectid] = duplicate(qVideos) />
			
			<!--- loop over the videos, if found, update, if not, create it --->
			<cfloop query="qVideos">
				
				<cfset stVideo = saveFromAPI(application.stPlugins.youtube.oCustomFunctions.queryRowToStruct(qVideos,qVideos.currentRow)) />
				
				<!--- add it to the playlist (if necessary) ---->
				<cfif not oPlaylist.playlistContainsVideo(playlistId = stPlaylist.objectId, videoId = stVideo.objectId)>
					
					<cfset oPlaylist.addVideoToPlaylist(playlistId = stPlaylist.objectId, videoId = stVideo.objectId) />
					
				</cfif>
				
			</cfloop>
			
		</cfloop>
		
		<!--- get the user's videos that aren't on playlists and add/update those --->
		
		<!--- first, get all the user's videos --->
		<cfset var qUserVideos = application.stPlugins.youtube.oYouTube.getVideosByUser(username = application.fapi.getConfig(key = 'youtube', name = 'username')) />	
		
		<!--- filter out the videos that are on playlists (they have already been processed --->
		<cfset var qNonPlaylistVideos = "" />
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
			<cfset stVideo = saveFromAPI(application.stPlugins.youtube.oCustomFunctions.queryRowToStruct(qNonPlaylistVideos,qNonPlaylistVideos.currentRow)) />
		</cfloop>
		
		<!--- now, check for FarCry records that have no matching record from the API.  If found, it was removed, so delete from FarCry --->
		
		<!--- get the playlist records from FarCry --->
		<cfset var qPlaylistRecords = application.fapi.getContentObjects(typename = "youtubePlaylist", lProperties = "objectid, playlistid") />
		
		<!--- grab the ones that aren't in the API data --->
		<cfset var qPlaylistsToDelete = "" />
		<cfquery name="qPlaylistsToDelete" dbtype="query">
			select objectid from qPlaylistRecords where playlistid not in (<cfqueryparam list="true" cfsqltype="cf_sql_varchar" value="#valueList(qPlaylists.playlistid)#" />)
		</cfquery>
		
		<!--- delete 'em --->
		<cfloop query="qPlaylistsToDelete">
			<cfset oPlaylist.deleteData(objectid = qPlaylistsToDelete.objectid[qPlaylistsToDelete.currentRow]) />	
		</cfloop>
		
		<!--- get the video records from FarCry --->
		<cfset var qVideoRecords = application.fapi.getContentObjects(typename = "youtubeVideo", lProperties = "objectid, id") />
		
		<!--- grab the ones that aren't in the API data --->
		<cfset var qVideosToDelete = "" />
		<cfquery name="qVideosToDelete" dbtype="query">
			select objectid from qVideoRecords where
			 
			1 = 1
			
			<cfloop collection="#stPlaylistVideos#" item="playlistId">
				<cfset q = stPlaylistVideos[playlistId] />
				and id not in (<cfqueryparam list="true" cfsqltype="cf_sql_varchar" value="#valueList(q.id)#" />)
			</cfloop>
		</cfquery>

		<cfset var aVideosToDelete = listToArray(valueList(qVideosToDelete.objectid)) />

		<!--- delete 'em --->
		<cfloop query="qVideosToDelete">
			
			<!--- delete the record --->
			<cfset deleteData(objectid = qVideosToDelete.objectid[qVideosToDelete.currentRow]) />
			
		</cfloop>
		
		<!--- clean up any rogue video references on playlists --->
		<cfset oPlaylist.cleanupPlaylists() />

	</cffunction>
	
</cfcomponent>