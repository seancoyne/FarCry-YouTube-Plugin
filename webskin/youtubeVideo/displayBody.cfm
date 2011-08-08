<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Body --->
<!--- @@author: Sean Coyne (http://www.n42designs.com/) --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />

<cfoutput>
<h2>#stobj.title#</h2>
</cfoutput>
	
<cfif len(trim(stobj.description))>
	<cfoutput>
	<p>#application.stPlugins.youtube.oCustomFunctions.xhtmlParagraphFormat(stobj.description)#</p>
	</cfoutput>
</cfif>

<skin:view objectid="#stobj.objectid#" typename="youtubeVideo" webskin="displayTeaserEmbeddedVideo" />

<cfsetting enablecfoutputonly="false" />