<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Library Selected --->
<!--- @@author: Sean Coyne (http://www.n42designs.com/) --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />

<cfoutput>
	<div><img src="#stobj.thumbnail_url#" width="100" style="vertical-align: middle;" alt="#stobj.title#" /> #stobj.title#</div>
</cfoutput>

<cfsetting enablecfoutputonly="false" />