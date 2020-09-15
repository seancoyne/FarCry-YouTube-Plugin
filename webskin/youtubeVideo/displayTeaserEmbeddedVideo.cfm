<cfsetting enablecfoutputonly="true" />
<!--- @@displayname: Embedded Video --->
<!--- @@author: Sean Coyne (sean@n42designs.com) --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />

<cfoutput>
<div class="embed-responsive embed-respsonsive-16by9">
	<iframe src="https://www.youtube.com/embed/#stObj.id#" allowfullscreen></iframe>
</div>
</cfoutput>

<cfsetting enablecfoutputonly="false" />