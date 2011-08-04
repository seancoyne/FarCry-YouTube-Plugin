<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: YouTube Video Administration --->
<!--- @@author: Sean Coyne (http://www.n42designs.com/) --->

<cfimport taglib="/farcry/core/tags/admin/" prefix="admin" />
<cfimport taglib="/farcry/core/tags/formtools" prefix="ft" />

<admin:header title="Videos" />


<cfset stFilterMetadata = {} />
<cfset stFilterMetadata.title = { ftDisplayOnly = false } />
<cfset stFilterMetadata.author = { ftDisplayOnly = false } />

<cfscript>
aCustomColumns = [
	{ webskin = "cellThumbnail.cfm", title = "Thumbnail", sortable = false, property = "thumbnail_url" }
];
</cfscript>

<ft:objectadmin 
	lButtons="unlock"
	typename="youtubeVideo"
	columnList="title,author,updated,datetimecreated,datetimelastupdated"
	aCustomColumns="#aCustomColumns#" 
	sortableColumns="title,author,updated,datetimecreated,datetimelastupdated"
	lFilterFields="title,author"
	stFilterMetadata="#stFilterMetadata#"
	sqlorderby="title"
	plugin="youtube" />

<admin:footer />

<cfsetting enablecfoutputonly="false" />