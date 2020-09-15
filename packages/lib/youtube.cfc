component {
	
	public void function sync() {
		
		var channelId = application.fapi.getConfig(key = 'youtube', name = 'channelId');
		var apiKey = application.fapi.getConfig(key = 'youtube', name = 'devkey');
		
		var playlists = getPlaylists(
			channelId = channelid,
			apiKey = apiKey
		);
		
		var oPlaylist = application.fapi.getContentType("youtubePlaylist");
		var oVideo = application.fapi.getContentType("youtubeVideo");
		
		var playlistIdsFound = [];
		var videoIdsFound = [];
		
		for (var playlist in playlists) {
			
			var stPlaylist = oPlaylist.getById(playlist.id);
			
			stPlaylist["playlistid"] = playlist.id;
			stPlaylist["title"] = playlist.snippet.title;
			stPlaylist["content"] = playlist.snippet.description;
			stPlaylist["published"] = playlist.snippet.publishedAt;
			stPlaylist["aVideos"] = [];
			
			// get the videos on the playlist
			var playlistVideos = getVideosForPlaylist(playlistId = playlist.id, channelId = channelId, apiKey = apiKey);
			
			// save each video
			
			for (var video in playlistVideos) {
				
				var stVideo = oVideo.getById(video.snippet.resourceId.videoId);

				stVideo["id"] = video.snippet.resourceId.videoId;
				stVideo["title"] = video.snippet.title;
				stVideo["description"] = video.snippet.description;
				stVideo["published"] = video.snippet.publishedAt;
				
				if (structKeyExists(video.snippet.thumbnails, "maxres")) {
					stVideo["thumbnail_height"] = video.snippet.thumbnails.maxres.height;
					stVideo["thumbnail_url"] = video.snippet.thumbnails.maxres.url;
					stVideo["thumbnail_width"] = video.snippet.thumbnails.maxres.width;	
				} else if (structKeyExists(video.snippet.thumbnails, "standard")) {
					stVideo["thumbnail_height"] = video.snippet.thumbnails.standard.height;
					stVideo["thumbnail_url"] = video.snippet.thumbnails.standard.url;
					stVideo["thumbnail_width"] = video.snippet.thumbnails.standard.width;	
				} else if (structKeyExists(video.snippet.thumbnails, "high")) {
					stVideo["thumbnail_height"] = video.snippet.thumbnails.high.height;
					stVideo["thumbnail_url"] = video.snippet.thumbnails.high.url;
					stVideo["thumbnail_width"] = video.snippet.thumbnails.high.width;	
				} else if (structKeyExists(video.snippet.thumbnails, "medium")) {
					stVideo["thumbnail_height"] = video.snippet.thumbnails.medium.height;
					stVideo["thumbnail_url"] = video.snippet.thumbnails.medium.url;
					stVideo["thumbnail_width"] = video.snippet.thumbnails.medium.width;	
				} else if (structKeyExists(video.snippet.thumbnails, "default")) {
					stVideo["thumbnail_height"] = video.snippet.thumbnails.default.height;
					stVideo["thumbnail_url"] = video.snippet.thumbnails.default.url;
					stVideo["thumbnail_width"] = video.snippet.thumbnails.default.width;	
				}
				
				stVideo = oVideo.beforeSave(stVideo, {});
				
				if (structKeyExists(stVideo, "objectid")) {
					oVideo.setData(stVideo);
				} else {
					var stVideoSaveResult = oVideo.createData(stVideo);
					oVideo.afterSave(oVideo.getData(stVideoSaveResult.objectid));
					stVideo = oVideo.getData(stVideoSaveResult.objectid);
				}
				
				arrayAppend(stPlaylist.aVideos, stVideo.objectid);
				
				arrayAppend(videoIdsFound, stVideo.id);
				
			}
			
			// save the playlist
			
			stPlaylist = oPlaylist.beforeSave(stPlaylist, {});
			
			if (structKeyExists(stPlaylist, "objectid")) {
				oPlaylist.setData(stPlaylist);
			} else {
				var stPlaylistSaveResult = oPlaylist.createData(stPlaylist);
				oPlaylist.afterSave(oPlaylist.getData(stPlaylistSaveResult.objectid));
			}
			
			arrayAppend(playlistIdsFound, stPlaylist.playlistid);
			
		}
		
		// delete any playlists that did not come from YouTube
		cleanUpPlaylists(idsToKeep = playlistIdsFound);
		
		// delete any videos that did not come from YouTube
		cleanUpVideos(idsToKeep = videoIdsFound);
		
	}
	
	public void function cleanUpPlaylists(required array idsToKeep) {
		
		var oPlaylist = application.fapi.getContentType("youtubePlaylist");
		
		var q = queryExecute('select objectid from youtubePlaylist where playlistid not in (:ids);', {
			'ids' = { cfsqltype = "cf_sql_varchar", list = true, value = arrayToList(idsToKeep) }
		}, { datasource = application.dsn });
		
		for (var row in q) {
			oPlaylist.deleteData(objectid = row.objectid);
		}
		
	}
	
	public void function cleanUpVideos(required array idsToKeep) {
		
		var oVideo = application.fapi.getContentType("youtubeVideo");
		
		var q = queryExecute('select objectid from youtubeVideo where id not in (:ids);', {
			'ids' = { cfsqltype = "cf_sql_varchar", list = true, value = arrayToList(idsToKeep) }
		}, { datasource = application.dsn });
		
		for (var row in q) {
			oVideo.deleteData(objectid = row.objectid);
		}
		
	}
	
	public array function getVideosForPlaylist(required string playlistId, required string channelId, required string apiKey) {
		
		var uri = "https://www.googleapis.com/youtube/v3/playlistItems";
		
		var params = [
			{ name = "playlistId", value = arguments.playlistId, type = "url" },
			{ name = "key", value = arguments.apiKey, type = "url" },
			{ name = "part", value = "snippet", type = "url" },
			{ name = "part", value = "status", type = "url" }
		];
		
		var httpService = new http();
		
		httpService.setURL(uri);
		httpService.setMethod("GET");
		
		for (var param in params) {
			httpService.addParam(argumentCollection = param);
		}
		
		var httpResult = httpService.send().getPrefix();
		
		var result = deserializeJSON(httpResult.filecontent);
		
		return arrayFilter(result.items, function(item){
			return item.status.privacyStatus eq "public" && item.snippet.resourceId.kind eq "youtube##video";
		});
		
	}
	
	public array function getPlaylists(required string channelId, required string apiKey) {
		
		var uri = "https://www.googleapis.com/youtube/v3/playlists";
		
		var params = [
			{ name = "channelId", value = arguments.channelId, type = "url" },
			{ name = "key", value = arguments.apiKey, type = "url" },
			{ name = "part", value = "snippet", type = "url" }
		];
		
		var httpService = new http();
		
		httpService.setURL(uri);
		httpService.setMethod("GET");
		
		for (var param in params) {
			httpService.addParam(argumentCollection = param);
		}
		
		var httpResult = httpService.send().getPrefix();
		
		var result = deserializeJSON(httpResult.filecontent);
		
		return result.items;
		
	}
	
	
}