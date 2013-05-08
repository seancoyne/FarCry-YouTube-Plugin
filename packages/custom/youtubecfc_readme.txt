LICENSE 
Copyright 2010-2012 Raymond Camden

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
   
   
If you like this code, please consider visiting my wish list: http://www.amazon.com/o/registry/2TCL1D08EZEYE


INSTRUCTIONS

This CFC acts as an API to YouTube. Some operations, like uploading, require you to have
a valid YouTube username, password, as well as a developer API key. In general though each
CFC has a hint value which tells what it does.

HISTORY
December 6, 2012:
Mods to keyword support. NOTE - keywords only work in authenticated calls now.

July 5, 2012:
Fixed duration support. Fix written by user "Roberto" on RIAForge. (Issue 3)

October 18, 2011:
addVideoToPlaylist added

April 12, 2011:
getChannels now correctly handles cases where summary and countHit do not exist.

March 9, 2011:
Seth Krostich (sethk@shoesforcrews.com) added the getUploadToken function.
I fixed one missing var statement in getVideo.
 

July 19, 2010:
With suggestions by Jason Long:
getVideo will notice a 403 status code
Updated support for processing result in state.

November 24, 2009:
This update includes work by Riyaz Ahamed. Thanks to him for work on favorites.
Support for:
	addFavoriteVideoForUser (adds a favorite video to the currently logged in user)
	getFavoriteVideosForUser (gets current user's fav videos)
	deleteFavoriteVideoForUser (duh)
	getVideos - video status returned as a column
	getComments - API changed to ONLY require the video id, not the full url
	getMostLinked has been removed as it was removed from the YT API
	
October 18, 2009:
Corrected delete behavior, thanks go to Eric Wilkinson

October 1, 2009:
Better error handling in getPlaylists.
getMobileVideos,getMostDiscussedVideos,getMostLinkedVideos,getMostRecentVideos,getMostResponsedVideos,getMostViewedVideos,getRecentlyViewedVideos,getTopFavoritesVideos,getTopRatedVideos updated to support START/MAX
Better error handling in parseEntry.

November 12, 2008:
YouTube's API for uploads and keywords is insane stupid. To help users I've built a fixKeywords method that will attempt to 'massage' keywords into a format
Google won't crap on.

Search has had a few mods. 

First off, I had an odd query param (vq) instead of q.
Second, I needed to specify an API version otherwise Google defaulted to 1.
Third: YouTube (I know I keep saying Google and YouTube interchangeably - read what I mean, not what I say) supports returning a spelling suggestion for searches. It doesn't always
do this though. When you search, I now return a new column called suggestion that will contain a spelling suggestion. You can also pass a new arg, autosearch. If true, and if results
were null, and a suggestion was returned, the method will automatically re-search with the suggestion. I'm a bit wary of this feature, so please test.

November 3, 2008:
As of November 3rd, all uploads require that you have hot fix installed. See this URL for more information:
http://kb.adobe.com/selfservice/viewContent.do?externalId=kb406660

If you do not have this hot fix installed, the CFC will not work at all.

April 29, 2008:
Added getVideo, getEmbedCode, and some other small cleanups.

April 19, 2008:
First formal release of the CFC using API version 2.