<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: YouTube Playlist Administration --->
<!--- @@author: Sean Coyne (http://www.n42designs.com/) --->

<cfimport taglib="/farcry/core/tags/admin/" prefix="admin" />
<cfimport taglib="/farcry/core/tags/formtools" prefix="ft" />

<admin:header title="Playlists" />

<ft:objectadmin 
	lButtons="unlock"
	typename="youtubePlaylist"
	columnList="title,author,published,updated,datetimecreated,datetimelastupdated" 
	sortableColumns="title,author,published,updated,datetimecreated,datetimelastupdated"
	lFilterFields="title,author"
	sqlorderby="title"
	plugin="youtube" />

<admin:footer />

<cfsetting enablecfoutputonly="false" />