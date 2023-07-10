<cfcomponent output="false" extends="youtube">

	<cffunction name="getPlaylist" access="public" returnType="query" output="false"
			hint="Gets a playlist.">
		<cfargument name="plurl" type="string" required="true">
		<cfargument name="start" type="numeric" required="false" default="1">
		<cfargument name="max" type="numeric" required="false" default="50">
		
		<cfscript>
		
		// determine the playlistid
		var id = listLast(plurl, "/");
		
		var videos = getVideosForPlaylist(id);
		
		var totNum = arrayLen(videos);
		
		var q = queryNew("videostatus,total,id,published,updated,categories,keywords,title,content,author,authorurl,link,description,duration,thumbnail_url,thumbnail_width,thumbnail_height,viewcount,favoritecount,averagerating,numratings,commentsurl,numcomments","varchar,integer,varchar,date,date,varchar,varchar,varchar,varchar,varchar,varchar,varchar,varchar,integer,varchar,integer,integer,integer,integer,integer,integer,varchar,integer");
		
		for (var video in videos) {

			if (structKeyExists(video, "status") and video.status.privacystatus neq "privacyStatusUnspecified") {

				queryAddRow(q);
				
				querySetCell(q, "videostatus", video.status.privacystatus);
				querySetCell(q, "total", totNum);
				querySetCell(q, "id", video.snippet.resourceId.videoId);
				querySetCell(q, "published", handleDate(video.snippet.publishedAt));
				querySetCell(q, "updated", "");
				querySetCell(q, "categories", "");
				querySetCell(q, "keywords", "");
				querySetCell(q, "title", video.snippet.title);
				querySetCell(q, "content", "");
				querySetCell(q, "author", "");
				querySetCell(q, "authorurl", "");
				querySetCell(q, "link", "http://www.youtube.com/watch?v=" & video.snippet.resourceId.videoId & "&feature=youtube_gdata");
				querySetCell(q, "description", video.snippet.description);
				querySetCell(q, "duration", 0);
				
				if (structKeyExists(video.snippet.thumbnails, "high")) {
					querySetCell(q, "thumbnail_url", video.snippet.thumbnails.high.url);
					querySetCell(q, "thumbnail_width", video.snippet.thumbnails.high.width);
					querySetCell(q, "thumbnail_height", video.snippet.thumbnails.high.height);
				} else if (structKeyExists(video.snippet.thumbnails, "medium")) {
					querySetCell(q, "thumbnail_url", video.snippet.thumbnails.medium.url);
					querySetCell(q, "thumbnail_width", video.snippet.thumbnails.medium.width);
					querySetCell(q, "thumbnail_height", video.snippet.thumbnails.medium.height);
				} else {
					querySetCell(q, "thumbnail_url", video.snippet.thumbnails.default.url);
					querySetCell(q, "thumbnail_width", video.snippet.thumbnails.default.width);
					querySetCell(q, "thumbnail_height", video.snippet.thumbnails.default.height);
				}
				querySetCell(q, "viewcount", 0);
				querySetCell(q, "favoritecount", 0);
				querySetCell(q, "averagerating", 0);
				querySetCell(q, "numratings", 0);
				querySetCell(q, "commentsurl", "");
				querySetCell(q, "numcomments", 0);

			}

		}
		
		return q;
		
		</cfscript>
		
	</cffunction>
	
	<cfscript>

	private array function getVideosForPlaylist(required string playlistid, numeric max = 50, string pagetoken = "", array videos = []) {
		
		var httpService = new http();
		httpService.setURL("https://www.googleapis.com/youtube/v3/playlistItems?part=snippet%2Cstatus&pageToken=" & arguments.pagetoken & "&maxResults=" & arguments.max & "&playlistId=" & arguments.playlistid & "&key=" & variables.devkey);
		httpService.setMethod("GET");
		var videoResult = deserializeJson(httpService.send().getPrefix().filecontent);

		for (var item in videoResult.items) {
			
			arrayAppend(arguments.videos, item);
			
		}
		
		if (structKeyExists(videoResult, "nextPageToken") && len(trim(videoResult.nextPageToken))) {
			
			return getVideosForPlaylist(playlistid = arguments.playlistid, max = arguments.max, pagetoken = videoResult.nextPageToken, videos = arguments.videos);
			
		}
		
		return arguments.videos;
		
	}	
	
	
	
	</cfscript>
	
	<cffunction name="getVideosByUser" access="public" returnType="query" output="false"
				hint="Gets videos for a user.">
		<cfargument name="username" type="string" required="true">
		<cfargument name="playlistid" type="string" default="" />
		
		<cfscript>
		
		// first get the channel which will give you the "uploads" playlist ID
		if (!len(trim(arguments.playlistid))) {
			var httpService = new http();
			httpService.setURL("https://www.googleapis.com/youtube/v3/channels?part=contentDetails&maxresults=1&forUsername=" & arguments.username & "&key=" & variables.devKey);
			httpService.setMethod("GET");
			var channelResult = httpService.send().getPrefix();
			var channelData = deserializeJson(channelResult.filecontent);
			arguments.playlistid = channelData.items[1].contentDetails.relatedPlaylists.uploads;
		}
		
		// then load the playlist items for the "uploads" playlist
		var videos = getVideosForPlaylist(arguments.playlistid);
		
		var totNum = arrayLen(videos);
		
		var q = queryNew("videostatus,total,id,published,updated,categories,keywords,title,content,author,authorurl,link,description,duration,thumbnail_url,thumbnail_width,thumbnail_height,viewcount,favoritecount,averagerating,numratings,commentsurl,numcomments","varchar,integer,varchar,date,date,varchar,varchar,varchar,varchar,varchar,varchar,varchar,varchar,integer,varchar,integer,integer,integer,integer,integer,integer,varchar,integer");
		
		for (var video in videos) {
			
			queryAddRow(q);
			
			querySetCell(q, "videostatus", video.status.privacystatus);
			querySetCell(q, "total", totNum);
			querySetCell(q, "id", video.snippet.resourceId.videoId);
			querySetCell(q, "published", handleDate(video.snippet.publishedAt));
			querySetCell(q, "updated", "");
			querySetCell(q, "categories", "");
			querySetCell(q, "keywords", "");
			querySetCell(q, "title", video.snippet.title);
			querySetCell(q, "content", "");
			querySetCell(q, "author", arguments.username);
			querySetCell(q, "authorurl", "");
			querySetCell(q, "link", "http://www.youtube.com/watch?v=" & video.snippet.resourceId.videoId & "&feature=youtube_gdata");
			querySetCell(q, "description", video.snippet.description);
			querySetCell(q, "duration", 0);
			
			if (structKeyExists(video.snippet.thumbnails, "high")) {
				querySetCell(q, "thumbnail_url", video.snippet.thumbnails.high.url);
				querySetCell(q, "thumbnail_width", video.snippet.thumbnails.high.width);
				querySetCell(q, "thumbnail_height", video.snippet.thumbnails.high.height);
			} else if (structKeyExists(video.snippet.thumbnails, "medium")) {
				querySetCell(q, "thumbnail_url", video.snippet.thumbnails.medium.url);
				querySetCell(q, "thumbnail_width", video.snippet.thumbnails.medium.width);
				querySetCell(q, "thumbnail_height", video.snippet.thumbnails.medium.height);
			} else {
				querySetCell(q, "thumbnail_url", video.snippet.thumbnails.default.url);
				querySetCell(q, "thumbnail_width", video.snippet.thumbnails.default.width);
				querySetCell(q, "thumbnail_height", video.snippet.thumbnails.default.height);
			}
			
			querySetCell(q, "viewcount", 0);
			querySetCell(q, "favoritecount", 0);
			querySetCell(q, "averagerating", 0);
			querySetCell(q, "numratings", 0);
			querySetCell(q, "commentsurl", "");
			querySetCell(q, "numcomments", 0);
			
		}
		
		return q;
		
		</cfscript>
		
	</cffunction>
	<cffunction name="getEmbedCode" access="public" returnType="string" output="false" hint="Utility function to return embed html">
		<cfargument name="videoid" type="string" required="true">
		<cfargument name="width" type="string" required="false" default="425" />
		<cfargument name="height" type="string" required="false" default="355" />
		<cfargument name="autoplay" type="boolean" required="false" default="false" />
		<cfargument name="related" type="boolean" required="false" default="true" />
		<!--- Video ID may include the URL, strip it --->
		<cfset arguments.videoid = replace(arguments.videoid, "http://gdata.youtube.com/feeds/api/videos/","")>
		<cfset arguments.videoid = listFirst(arguments.videoid, "&")>
		<cfscript>
		var html = "<iframe ";
		if (isNumeric(arguments.width)) {
			html = html & 'width="' & arguments.width & '" ';
		}
		if (isNumeric(arguments.height)) {
			html = html & 'height="' & arguments.height & '" ';
		}
		html = html & 'src="https://www.youtube.com/embed/' & arguments.videoId & "?rel=" & ((arguments.related) ? '1' : '0') & ((arguments.autoplay) ? '&autoplay=1' : '') & '" frameborder="0" allowfullscreen></iframe>';
		return html;
		</cfscript>
	</cffunction>
	
	<cfscript>
	
	private array function getPlaylistData(required string user, numeric max = 50, string channelid = "", string pagetoken = "", array playlists = []) {
		
		if (arguments.max gt 50) {
			arguments.max = 50;
		}
		
		if (arguments.max lt 1) {
			arguments.max = 1;
		}
		
		// first get channels, assume first channel
		if (!len(trim(arguments.channelid))) {
			var httpService = new http();
			httpService.setURL("https://www.googleapis.com/youtube/v3/channels?part=id&maxresults=1&forUsername=" & arguments.user & "&key=" & variables.devKey);
			httpService.setMethod("GET");
			var channelIdResult = httpService.send().getPrefix();
			var channelData = deserializeJson(channelIdResult.filecontent);
			arguments.channelid = channelData.items[1].id;
		}
		
		// load playlists for channel
		
		httpService = new http();
		httpService.setURL("https://www.googleapis.com/youtube/v3/playlists?part=contentDetails%2Csnippet&channelId=" & arguments.channelid & "&maxResults=" & arguments.max & "&key=" & variables.devkey & "&pageToken=" & arguments.pageToken);
		httpService.setMethod("GET");
		
		var playlistData = deserializeJson(httpService.send().getPrefix().filecontent);
		
		for (var item in playlistData.items) {
			
			arrayappend(arguments.playlists, item);
			
		}
		
		// if there is another page, get that page and return the results
		if (structKeyExists(playlistData, "nextPageToken") && len(trim(playlistData.nextPageToken))) {
		
			return getPlaylistData(user = arguments.user, max = arguments.max, channelid = arguments.channelid, pagetoken = playlistData.nextPageToken, playlists = arguments.playlists);	
			
		}
		
		return arguments.playlists;
		
	}
	</cfscript>
	
	<cffunction name="getPlaylists" access="public" returnType="query" output="false"
			hint="Gets playlists for a user.">
		<cfargument name="user" type="string" required="true">
		<cfargument name="startindex" type="numeric" required="true" default="1">
		<cfargument name="max" type="numeric" required="false" default="50">
		
		<cfscript>
		
		var playlists = getPlaylistData(user = arguments.user, max = arguments.max);
		
		var total = arraylen(playlists);
		
		var results = queryNew("total,url,published,updated,title,content,author,authorurl,videocount,playlistid,thumbnail_url,thumbnail_width,thumbnail_height");
		
		for (var playlist in playlists) {
			
			queryAddRow(results);
			querySetCell(results, "total", total);
			querySetCell(results, "url", "http://gdata.youtube.com/feeds/api/playlists/" & playlist.id);
			querySetCell(results, "published", handleDate(playlist.snippet.publishedAt));
			querySetCell(results, "updated", handleDate(playlist.snippet.publishedAt));
			querySetCell(results, "title", playlist.snippet.title);
			querySetCell(results, "content", playlist.snippet.description);
			querySetCell(results, "author", "");
			querySetCell(results, "authorurl", "");
			
			querySetCell(results, "videocount", playlist.contentDetails.itemCount);
			querySetCell(results, "playlistID", playlist.id);
			
			if (structKeyExists(playlist.snippet.thumbnails, "high")) {
				querySetCell(results, "thumbnail_url", playlist.snippet.thumbnails.high.url);
				querySetCell(results, "thumbnail_width", playlist.snippet.thumbnails.high.height);
				querySetCell(results, "thumbnail_height", playlist.snippet.thumbnails.high.width);
			} else if (structKeyExists(playlist.snippet.thumbnails, "medium")) {
				querySetCell(results, "thumbnail_url", playlist.snippet.thumbnails.medium.url);
				querySetCell(results, "thumbnail_width", playlist.snippet.thumbnails.medium.height);
				querySetCell(results, "thumbnail_height", playlist.snippet.thumbnails.medium.width);
			} else if (structKeyExists(playlist.snippet.thumbnails, "default")) {
				querySetCell(results, "thumbnail_url", playlist.snippet.thumbnails.default.url);
				querySetCell(results, "thumbnail_width", playlist.snippet.thumbnails.default.height);
				querySetCell(results, "thumbnail_height", playlist.snippet.thumbnails.default.width);
			}
			
		}
		
		return results;
			
		</cfscript>
		
	</cffunction>
</cfcomponent>