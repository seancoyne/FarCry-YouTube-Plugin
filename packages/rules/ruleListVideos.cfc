<cfcomponent output="false" extends="farcry.core.packages.rules.rules" displayname="YouTube: List Videos" hint="Displays a list of video teasers">
	
	<cfproperty ftSeq="110" ftFieldset="Title" ftLabel="Display Title?" name="bShowTitle" type="boolean" ftType="boolean" required="true" default="1" ftDefault="1" ftHint="Display the title above the list?" />
	<cfproperty ftSeq="120" ftFieldset="Title" ftLabel="Title" bLabel="true" name="title" type="nstring" ftType="string" required="true" ftValidation="required" ftDefault="Videos" />
	
	<cfproperty ftSeq="210" ftFieldset="Description" ftLabel="Display video descriptions?" name="bShowDescriptions" type="boolean" ftType="boolean" required="true" default="1" ftDefault="1" ftHint="Display the description for each video in the list?" />
	
	<cfproperty ftSeq="410" ftFieldset="OPTION 1" ftLabel="Playlists" name="aPlaylists" type="array" ftType="array" ftJoin="youtubePlaylist" ftHint="Select one or more playlists to display.  All videos from the playlists will be shown in the list." />
	<cfproperty ftSeq="420" ftFieldset="OPTION 2" ftLabel="Videos" name="aVideos" type="array" ftType="array" ftJoin="youtubeVideo" ftHint="Select one or more vidoes to display." />
	
</cfcomponent>