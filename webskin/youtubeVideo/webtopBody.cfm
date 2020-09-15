<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: YouTube Video Administration --->
<!--- @@author: Sean Coyne (http://www.n42designs.com/) --->

<cfimport taglib="/farcry/core/tags/formtools" prefix="ft" />

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
	columnList="title,id,datetimecreated,datetimelastupdated"
	aCustomColumns="#aCustomColumns#" 
	sortableColumns="title,id,datetimecreated,datetimelastupdated"
	lFilterFields="title,id"
	stFilterMetadata="#stFilterMetadata#"
	sqlorderby="title"
	plugin="youtube" />

<cfsetting enablecfoutputonly="false" />