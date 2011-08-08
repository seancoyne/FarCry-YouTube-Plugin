<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Embed Video --->
<!--- @@author: Sean Coyne (sean@n42designs.com) --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />

<skin:view objectid="#stobj.video#" typename="youtubeVideo" webskin="displayTeaserEmbeddedVideo" />

<cfsetting enablecfoutputonly="false" />