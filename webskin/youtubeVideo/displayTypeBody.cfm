<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: List Videos --->
<!--- @@author: Sean Coyne (http://www.n42designs.com/) --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />

<cfset q = application.fapi.getContentObjects(typename = "youtubeVideo", orderby = "title") />

<skin:pagination query="#q#" typename="youtubeVideo" paginationId="">
	<cfset class = "" />
	<cfif stObject.bFirst>
		<cfset class = "first" />
	<cfelseif stObject.bLast>
		<cfset class = "last" />
	</cfif>
	<skin:view objectid="#q.objectid[stObject.recordsetrow]#" typename="youtubeVideo" webskin="displayTeaserStandard" class="#class#" />
</skin:pagination>

<cfsetting enablecfoutputonly="false" />