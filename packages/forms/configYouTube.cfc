<cfcomponent output="false" hint="Configures settings for the YouTube API" extends="farcry.core.packages.forms.forms" displayname="YouTube API" key="youtube">
	
	<cfproperty ftSeq="10" ftFieldset="YouTube API" name="devkey" type="nstring" ftType="string" ftLabel="Dev. Key" ftDefault="" default="" ftValidation="required" />
	<cfproperty ftSeq="20" ftFieldset="YouTube API" name="username" type="nstring" ftType="string" ftLabel="Username" ftDefault="" default="" ftValidation="required" ftHint="The username of the YouTube account to use." />
	
	<cffunction name="process" access="public" output="false" returntype="struct">
		<cfargument name="fields" type="struct" required="true" />
		<!--- reconfigure the YouTube wrapper --->
		<cfset application.stPlugins.youtube.oYouTube = createObject("component","farcry.plugins.youtube.packages.custom.youtube").init(devkey = arguments.fields.devkey) />
		<cfreturn super.process(argumentCollection = arguments) />
	</cffunction>
	
</cfcomponent>