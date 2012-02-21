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

<!--- ensure all the videos listed actually exist --->
<cfloop from="#arrayLen(stobj.aVideos)#" to="1" index="i" step="-1">
	<cfif application.fapi.findType(stobj.aVideos[i]) neq "youtubeVideo">
		<cfset arrayDeleteAt(stobj.aVideos,i) />
	</cfif>	
</cfloop>

<skin:pagination array="#stobj.aVideos#" typename="youtubeVideo" paginationId="">	
	<skin:view typename="youtubeVideo" objectid="#stObject.objectId#" webskin="displayTeaserStandard" />
</skin:pagination>

<cfsetting enablecfoutputonly="false" />