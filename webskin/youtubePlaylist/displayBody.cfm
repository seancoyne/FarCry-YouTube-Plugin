<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Body --->
<!--- @@author: Sean Coyne (http://www.n42designs.com/) --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />

<cfoutput>
	<h2>#stobj.title#</h2>
	<cfif len(trim(stobj.content))>
		<p>#application.stPlugins.youtube.oCustomFunctions.xhtmlParagraphFormat(stobj.content)#</p>
	</cfif>
</cfoutput>

<skin:pagination array="#stobj.aVideos#" typename="youtubeVideo" paginationId="">	
	<skin:view typename="youtubeVideo" objectid="#stObject.objectId#" webskin="displayTeaserStandard" />
</skin:pagination>

<cfsetting enablecfoutputonly="false" />