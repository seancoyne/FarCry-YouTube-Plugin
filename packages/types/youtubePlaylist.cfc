<cfcomponent output="false" extends="farcry.core.packages.types.types" fuAlias="playlist" displayname="YouTube Playlist" hint="Manages playlists imported from YouTube" bFriendly="true" bObjectBroker="true">
	
	<cfproperty ftSeq="100" ftFieldset="Playlist" ftLabel="Playlist ID" ftDisplayOnly="true" name="playlistid" type="nstring" ftType="string" default="" />
	<cfproperty ftSeq="110" ftFieldset="Playlist" ftLabel="Title" ftDisplayOnly="true" name="title" bLabel="true" type="nstring" ftType="string" default="" />
	<cfproperty ftSeq="140" ftFieldset="Playlist" ftLabel="Content" ftDisplayOnly="true" name="content" type="longchar" ftType="longchar" default="" />
	
	<cfproperty ftSeq="200" ftFieldset="Status" ftLabel="Published (YouTube)" ftDisplayOnly="true" name="published" type="date" ftType="datetime" default="" />
	
	<cfproperty ftSeq="400" ftFieldset="Videos" ftLabel="Videos" name="aVideos" type="array" ftType="array" ftJoin="youtubeVideo" ftDisplayOnly="true" />
	
	<cfscript>
	
	public struct function getById(required string id) {
		
		var q = application.fapi.getContentObjects(typename = "youtubePlaylist", lProperties = "objectid", playlistid_eq = arguments.id);
		
		if (!q.recordcount) {
			return {};
		}
		
		return getData(q.objectid[1]);
		
	}	
	
	</cfscript>
	
	<!--- <cffunction name="updateFromAPI" access="public" output="false" returntype="struct" hint="Updates a FarCry record with data from the YouTube API">
		<cfargument name="data" type="struct" required="true" />
		<cfset var stPlaylist = getPlaylistByURL(arguments.data.url) />
		<cfset var key = "" />
		<cfloop collection="#arguments.data#" item="key">
			<cfset stPlaylist[key] = arguments.data[key] />
		</cfloop>
		<cfset stPlaylist.label = arguments.data.title />
		<cfset var stResult = setData(beforeSave(stPlaylist, {})) />
		<cfreturn getData(stPlaylist.objectid) />
	</cffunction>
	
	<cffunction name="createFromAPI" access="public" output="false" returntype="struct" hint="Creates a new FarCry record from data from the YouTube API">
		<cfargument name="data" type="struct" required="true" />
		<cfset arguments.data.label = arguments.data.title />
		<cfset var stResult = createData(beforeSave(arguments.data, {})) />
		<cfset var stPlaylist = getData(stResult.objectid) />
		<cfreturn afterSave(stProperties = stPlaylist) />
	</cffunction>
	
	<cffunction name="saveFromAPI" access="public" output="false" returntype="struct" hint="Saves a new FarCry record from data from the YouTube API">
		<cfargument name="data" type="struct" required="true" />
		<cfif playlistExists(arguments.data.url)>
			<cfreturn updateFromAPI(data = arguments.data) />
		<cfelse>
			<cfreturn createFromAPI(data = arguments.data) />
		</cfif>
	</cffunction>
	
	<cffunction name="playlistContainsVideo" access="public" output="false" returntype="boolean" hint="Returns true if the specified playlist lists the specified video">
		<cfargument name="playlistId" type="uuid" required="true" />
		<cfargument name="videoId" type="uuid" required="true" />
		<cfset var stPlaylist = getData(arguments.playlistId) />
		<cfreturn arrayFindNoCase(stPlaylist.aVideos,arguments.videoId) />
	</cffunction>
	
	<cffunction name="playlistExists" access="public" output="false" returntype="boolean" hint="Returns true if the playlist (identified by the URL from the API) exists">
		<cfargument name="playlistURL" type="string" required="true" />
		<cfset var q = application.fapi.getContentObjects(typename = "youtubePlaylist",lProperties = "objectid", maxrows = 1, orderby = "datetimelastupdated desc", url_eq = arguments.playlistURL) />
		<cfreturn q.recordCount />
	</cffunction>
	
	<cffunction name="getPlaylistByURL" access="public" output="false" returntype="struct" hint="Returns the playlist identified by the URL from the API">
		<cfargument name="playlistURL" type="string" required="true" />
		<cfset var q = application.fapi.getContentObjects(typename = "youtubePlaylist",lProperties = "objectid", maxrows = 1, orderby = "datetimelastupdated desc", url_eq = arguments.playlistURL) />
		<cfif q.recordCount>
			<cfreturn getData(q.objectid[1]) />
		<cfelse>
			<cfreturn {} />
		</cfif>
	</cffunction>
	
	<cffunction name="resetVideos" access="public" output="false" returntype="void" hint="Removes all videos from playlist (useful when sync'ing to be sure all videos which have been removed in YouTube are remove in FarCry)">
		<cfargument name="playlistId" type="uuid" required="true" default="" hint="" />
		<cfset var stPlaylist = getData(arguments.playlistId) />
		<cfset stPlaylist.aVideos = [] />
		<cfset setData(beforeSave(stPlaylist, {})) />
	</cffunction>
	
	<cffunction name="addVideoToPlaylist" access="public" output="false" returntype="void" hint="Adds the specified video to the specified playlist">
		<cfargument name="playlistId" type="uuid" required="true" default="" hint="" />
		<cfargument name="videoId" type="uuid" required="true" default="" hint="" />
		<cfset var stPlaylist = getData(arguments.playlistId) />
		<cfset arrayAppend(stPlaylist.aVideos,arguments.videoId) />
		<cfset setData(beforeSave(stPlaylist, {})) />
	</cffunction>
	
	<cffunction name="removeVideoFromAllPlaylists" access="public" output="false" returntype="void" hint="Removes the specified video from any playlist is appears on">
		<cfargument name="objectId" type="uuid" required="true" hint="The ObjectID of the video" />
		<cfset var q = "" />
		<cfquery name="q" datasource="#application.dsn#">
			select parentid from #application.dbowner#youtubeplaylist_avideos where data = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.objectid#" />;
		</cfquery>
		<cfloop query="q">
			<cfset var stPlaylist = getData(q.parentid[q.currentRow]) />
			<cfset arrayDeleteAt(stPlaylist.aVideos,arrayFindNoCase(stPlaylist.aVideos,arguments.objectid)) />
			<cfset setData(beforeSave(stPlaylist, {})) />
		</cfloop>
	</cffunction>

	<cffunction name="cleanupPlaylists" access="public" output="false" returntype="void">
		<cfset var q = "" />
		<cfquery name="q" datasource="#application.dsn#">
			delete from #application.dbowner#youtubeplaylist_avideos where data not in (
				select objectid from youtubevideo
			)
		</cfquery>
		<cfset application.fapi.flushCache("youtubePlaylist") />
		<!--- FarCry 7.1 bug fix --->
		<cfparam name="application.objectBroker.youtubeplaylist.timeout" default="86400" />
	</cffunction> --->
	
</cfcomponent>