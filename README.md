FarCry YouTube Plugin
=====================

Sean Coyne - http://www.n42designs.com/

This FarCry plugin provides integration with YouTube.  It will sync both videos and playlists from a specified account.

License
-------

This project is released under the Apache License, Version 2.0 http://www.apache.org/licenses/LICENSE-2.0.html

Requirements
------------

* ColdFusion 2018
* FarCry 7.4.0

This plugin has been tested on ColdFusion 2018 and FarCry 7.4.0.

Installation
------------

* Place the plugin files in a folder called "youtube" in your /farcry/plugins directory.
* Add "youtube" to the this.plugins list in your project's farcryConstructor.cfm
* Perform an "?updateapp=" or reinitialize the application in the webtop.
* Deploy the content types via the COAPI manager

Configuration
-------------

You will need a Developer Key from YouTube.  You can find out how to obtain one here: https://developers.google.com/youtube/v3/docs

You will also need a YouTube account with videos and playlists. Only public videos from teh same channel will sync.  You will need the channel ID which you can get here: https://www.youtube.com/account_advanced

Once you have your dev key and channel ID you should login into the FarCry webtop, navigate to "Admin", "General Admin", "Edit Config", "YouTube API" and enter these into the configuration form.

Lastly, you will need to create the scheduled task.  This is done in the webtop under "Admin", "General Admin", "Scheduled Tasks":

* Add a new scheduled task
* Give it a title, and choose the "YouTube Video Sync (youtube plugin)" selection from the "Template" drop down
* Choose the frequency that you want to sync the videos.  My suggestion is once a day.
* Set a start date and time
* Set the timeout to a reasonable value.  My suggestion is "600" which is 10 minutes. It should not take this long, however if you have a lot of videos, you don't want it to timeout during the sync process.

Use
---

When the scheduled task runs, it will grab all the videos and playlists associated with the specified YouTube account.  If new videos or playlists are found, it will create FarCry records, if they are already present in FarCry, it will update the records.  Records found in FarCry that are not returned by the YouTube API will be removed and considered deleted.

You cannot edit the video or playlist metadata, or create and upload new videos from FarCry.  You should do this via the YouTube interface.  FarCry will pick up the new video (or changes you make) when the scheduled task runs.  You can always manually run the scheduled task if you want it to be picked up faster.

The plugin will add a new "YouTube" section to the webtop's "Content" tab.

You will be able to view the playlists and videos imported from YouTube.

This plugin no longer provides any front end code. There is an example webskin that shows the embed code but you should write your own front end code.