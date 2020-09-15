<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: YouTube Playlist Administration --->
<!--- @@author: Sean Coyne (http://www.n42designs.com/) --->

<cfimport taglib="/farcry/core/tags/formtools" prefix="ft" />

<cfset stFilterMetadata = {} />
<cfset stFilterMetadata.title = { ftDisplayOnly = false } />

<ft:objectadmin 
	lButtons="unlock"
	typename="youtubePlaylist"
	columnList="title,published,datetimecreated,datetimelastupdated" 
	sortableColumns="title,published,datetimecreated,datetimelastupdated"
	lFilterFields="title"
	stFilterMetadata="#stFilterMetadata#"
	sqlorderby="title"
	plugin="youtube" />

<cfsetting enablecfoutputonly="false" />