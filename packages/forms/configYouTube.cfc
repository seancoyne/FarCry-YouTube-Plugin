<cfcomponent output="false" hint="Configures settings for the YouTube API" extends="farcry.core.packages.forms.forms" displayname="YouTube API" key="youtube">
	<cfproperty ftSeq="10" ftFieldset="YouTube API" name="devkey" type="nstring" ftType="string" ftLabel="Dev. Key" ftDefault="" default="" ftValidation="required" />
	<cfproperty ftSeq="30" ftFieldset="YouTube API" name="channelid" type="nstring" ftType="string" ftLabel="Channel ID" ftDefault="" default="" ftValidation="required" ftHint="The channel ID of the YouTube account to use." />
</cfcomponent>