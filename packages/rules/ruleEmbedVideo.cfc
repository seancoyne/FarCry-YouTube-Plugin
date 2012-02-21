<cfcomponent output="false" extends="farcry.core.packages.rules.rules" displayname="YouTube: Embed Video" hint="Embeds a single video on the page">
	
	<cfproperty ftSeq="10" ftFieldset="Embedded Video" ftLabel="Video" ftType="uuid" type="uuid" ftJoin="youtubeVideo" name="video" ftHint="The video to embed" />
	
	<cffunction name="cleanUp" access="public" output="false" returntype="void" hint="Removes instances of this rule that reference non-existant videos">
		
		<!--- get a list of rules that have bad references to videos --->
		<cfset var q = "" />
		<cfquery name="q" datasource="#application.dsn#">
		select objectid from ruleEmbedVideo where video not in (
			select objectid from youtubeVideo
		);
		</cfquery>
		
		<cfloop query="q">
			
			<!--- find containers holding this rule and remove the rule from the container --->
			<cfset var qContainers = "" />
			<cfquery name="qContainers" datasource="#application.dsn#">
			select container.objectid from container join container_aRules on container.objectid = container_aRules.parentid where container_aRules.data = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q.objectid[q.currentRow]#" />
			</cfquery>
			<cfloop query="qContainers">
				
				<!--- load the container --->
				<cfset var stContainer = application.fapi.getContentObject(typename = "container", objectid = qContainers.objectid[qContainers.currentRow]) />
				
				<!--- remove the rule from the rules list --->
				<cfset arrayDeleteAt(stContainer.aRules,arrayFindNoCase(stContainer.aRules,q.objectid[q.currentRow])) />
				
				<!--- save the container --->
				<cfset application.fapi.setData(typename = "container", stProperties = stContainer) />
				
			</cfloop>
			
			<!--- delete the rule instance --->
			<cfset deleteData(q.objectid[q.currentRow]) />
			
		</cfloop>
		
	</cffunction>
	
</cfcomponent>