FarCry YouTube Plugin
=====================

Sean Coyne - http://www.n42designs.com/

This FarCry plugin provides integration with YouTube.  It will sync both videos and playlists from a specified account.

License
-------

This project is released under the Apache License, Version 2.0 http://www.apache.org/licenses/LICENSE-2.0.html

Acknowledgements
----------------

This plugin makes use of the great YouTube CFC project (http://youtubecfc.riaforge.org/) by Raymond Camden (http://www.coldfusionjedi.com/) as well as the Fancybox (http://fancybox.net/) jQuery plugin

Requirements
------------

* ColdFusion 9.0.1
* FarCry 6.0.14

This plugin has been tested on ColdFusion 9.0.1 and FarCry 6.0.14.  It should work in FarCry 6.1.x and older FarCry 6.0.x versions as well.

Installation
------------

* Place the plugin files in a folder called "youtube" in your /farcry/plugins directory.
* Add "youtube" to the this.plugins list in your project's farcryConstructor.cfm
* Copy the contents of the "www" folder to a "youtube" folder under your project's webroot, or create a [farcry root]/youtube web server alias (virtual directory) pointing to the plugin's www folder.  If you are running a subdirectory installation of FarCry, this would be /[subdir]/youtube/, a standalone or advanced installation, this would be simply /youtube/.
* Perform an "?updateapp=" or reinitialize the application in the webtop.

Configuration
-------------

You will need a Developer Key from YouTube.  You can obtain one here: http://code.google.com/apis/youtube/dashboard/

You will also need a YouTube account with videos and/or playlists.  You can include other users' videos in your playlists.  The plugin will sync those videos with FarCry as well.

Once you have your dev key and username you should login into the FarCry webtop, navigate to "Admin", "General Admin", "Edit Config", "YouTube API" and enter these into the configuration form.

Lastly, you will need to start the scheduled task.  This is done in the webtop under "Admin", "General Admin", "Scheduled Tasks":

* Add a new scheduled task
* Give it a title, and choose the "YouTube Video Sync (youtube plugin)" selection from the "Template" drop down
* Choose the frequency that you want to sync the videos.  My suggestion is once a day so that the view counts and other statistics are updated.
* Set a start date and time
* Set the timeout to a reasonable value.  My suggestion is "600" which is 10 minutes. It should not take this long, however if you have a lot of videos, you don't want it to timeout during the sync process.

Use
---

When the scheduled task runs, it will grab all the videos and playlists associated with the specified YouTube account.  If new videos or playlists are found, it will create FarCry records, if they are already present in FarCry, it will update the records.  Records found in FarCry that are not returned by the YouTube API will be removed and considered deleted.

You cannot edit the video or playlist metadata, or create and upload new videos from FarCry.  You should do this via the YouTube interface.  FarCry will pick up the new video (or changes you make) when the scheduled task runs.  You can always manually run the scheduled task if you want it to be picked up faster.

The plugin will add a new "YouTube" section to the webtop's "Content" tab.  You can select this from the drop down menu in the left hand side bar.

You will be able to view the playlists and videos imported from YouTube.  If you edit a playlist, you will be able to resort the videos so you have control over the order.

The plugin provides two rules, "YouTube: List Videos" which will list video teasers in the container you add it to, and "YouTube: Embed Video" which embeds a video directly on the page.  For the listing rule, you can choose either one or more playlists or one or more videos to list.  If you choose playlists, it will grab all the videos from those playlists and list them in order.  If you choose to select specific videos, only those videos will be displayed.  In either case, the video teaser will display the thumbnail returned via the API, and the title.  Optionally you can display the description of each video.  If the user clicks the thumbnail, a lightbox window will open allowing them to play the video.  If they click the video's title, it will take them to the video's detail page where they can see more information as well as play the video.

Also included in the plugin are two displayTypeBody.cfm webskins.  These are listing pages.  One is for playlists and the other is for videos.  You can create a FarCry Include object and choose one of these display methods to list all of the playlists or videos.  If you click on a playlist title from the playlist listing page, it will take you to the playlist detail page which will list the videos found on that playlist.