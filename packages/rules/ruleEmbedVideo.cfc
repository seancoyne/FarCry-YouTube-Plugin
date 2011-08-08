<cfcomponent output="false" extends="farcry.core.packages.rules.rules" displayname="YouTube: Embed Video" hint="Embeds a single video on the page">
	
	<cfproperty ftSeq="10" ftFieldset="Embedded Video" ftLabel="Video" ftType="uuid" type="uuid" ftJoin="youtubeVideo" name="video" ftHint="The video to embed" />
	
</cfcomponent>