<cfcomponent output="false" extends="farcry.core.packages.types.types" fuAlias="video" displayname="YouTube Video" hint="Manages videos imported from YouTube" bFriendly="true" bObjectBroker="true">
	
	<cfproperty ftSeq="100" ftFieldset="Video" ftLabel="ID" ftDisplayOnly="true" name="id" type="nstring" ftType="string" default="" />
	<cfproperty ftSeq="110" ftFieldset="Video" ftLabel="Title" ftDisplayOnly="true" name="title" bLabel="true" type="nstring" ftType="string" default="" />
	<cfproperty ftSeq="120" ftFieldset="Video" ftLabel="Author" ftDisplayOnly="true" name="author" type="nstring" ftType="string" default="" />
	<cfproperty ftSeq="130" ftFieldset="Video" ftLabel="Author URL" ftDisplayOnly="true" name="authorurl" type="nstring" ftType="url" default="" />
	<cfproperty ftSeq="140" ftFieldset="Video" ftLabel="Description" ftDisplayOnly="true" name="description" type="longchar" ftType="longchar" default="" />
	<cfproperty ftSeq="150" ftFieldset="Video" ftLabel="Content" ftDisplayOnly="true" name="content" type="longchar" ftType="longchar" default="" />
	<cfproperty ftSeq="160" ftFieldset="Video" ftLabel="Categories" ftDisplayOnly="true" name="categories" type="longchar" ftType="longchar" default="" />
	<cfproperty ftSeq="170" ftFieldset="Video" ftLabel="Keywords" ftDisplayOnly="true" name="keywords" type="longchar" ftType="longchar" default="" />
	<cfproperty ftSeq="180" ftFieldset="Video" ftLabel="Link" ftDisplayOnly="true" name="link" type="nstring" ftType="url" default="" />
	<cfproperty ftSeq="190" ftFieldset="Video" ftLabel="Duration" ftDisplayOnly="true" name="duration" type="nstring" ftType="string" default="" />
	
	<cfproperty ftSeq="200" ftFieldset="Status" ftLabel="Video Status" ftDisplayOnly="true" name="videostatus" type="nstring" ftType="string" default="public" />
	<cfproperty ftSeq="210" ftFieldset="Status" ftLabel="Published (YouTube)" ftDisplayOnly="true" name="published" type="date" ftType="datetime" default="" />
	<cfproperty ftSeq="225" ftFieldset="Status" ftLabel="Updated (YouTube)" ftDisplayOnly="true" name="updated" type="date" ftType="datetime" default="" />
	
	<cfproperty ftSeq="300" ftFieldset="Statistics" ftLabel="Favorite Count" ftDisplayOnly="true" name="favoritecount" type="integer" ftType="integer" default="0" />
	<cfproperty ftSeq="310" ftFieldset="Statistics" ftLabel="View Count" ftDisplayOnly="true" name="viewcount" type="integer" ftType="integer" default="0" />
	<cfproperty ftSeq="320" ftFieldset="Statistics" ftLabel="Total" ftDisplayOnly="true" name="total" type="integer" ftType="integer" default="0" />

	<cfproperty ftSeq="400" ftFieldset="Comments" ftLabel="Num. Comments" ftDisplayOnly="true" name="numcomments" type="integer" ftType="integer" default="0" />
	<cfproperty ftSeq="410" ftFieldset="Comments" ftLabel="Comments URL" ftDisplayOnly="true" name="commentsurl" type="nstring" ftType="url" default="" />
	
	<cfproperty ftSeq="500" ftFieldset="Ratings" ftLabel="Num. Ratings" ftDisplayOnly="true" name="numratings" type="integer" ftType="integer" default="0" />
	<cfproperty ftSeq="510" ftFieldset="Ratings" ftLabel="Avg. Rating" ftDisplayOnly="true" name="averagerating" type="numeric" ftType="numeric" default="0" />
	
	<cfproperty ftSeq="600" ftFieldset="Thumbnail" ftLabel="Thumb. Height" ftDisplayOnly="true" name="thumbnail_height" type="integer" ftType="integer" default="0" />
	<cfproperty ftSeq="610" ftFieldset="Thumbnail" ftLabel="Thumb. URL" ftDisplayOnly="true" name="thumbnail_url" type="nstring" ftType="url" default="" />
	<cfproperty ftSeq="620" ftFieldset="Thumbnail" ftLabel="Thumb. Width" ftDisplayOnly="true" name="thumbnail_width" type="integer" ftType="integer" default="0" />
	
	<cffunction name="updateFromAPI" access="public" output="false" returntype="struct" hint="Updates a FarCry record with data from the YouTube API">
		<cfargument name="data" type="struct" required="true" />
		<cfset var st = getVideoByLink(arguments.data.link) />
		<cfset var key = "" />
		<cfloop collection="#arguments.data#" item="key">
			<cfset st[key] = arguments.data[key] />
		</cfloop>
		<cfset st.label = st.title />
		<cfset var stResult = setData(st) />
		<cfreturn getData(st.objectid) />
	</cffunction>
	
	<cffunction name="createFromAPI" access="public" output="false" returntype="struct" hint="Creates a new FarCry record from data from the YouTube API">
		<cfargument name="data" type="struct" required="true" />
		<cfset arguments.data.label = arguments.data.title />
		<cfset var stResult = createData(arguments.data) />
		<cfset var stVideo = getData(stResult.objectid) />
		<cfreturn afterSave(stVideo) />
	</cffunction>
	
	<cffunction name="saveFromAPI" access="public" output="false" returntype="struct" hint="Saves a new FarCry record from data from the YouTube API">
		<cfargument name="data" type="struct" required="true" />
		<cfif videoExists(arguments.data.link)>
			<cfreturn updateFromAPI(data = arguments.data) />
		<cfelse>
			<cfreturn createFromAPI(data = arguments.data) />
		</cfif>
	</cffunction>
	
	<cffunction name="videoExists" access="public" output="false" returntype="boolean" hint="Returns true if the video exists">
		<cfargument name="link" type="string" required="true" />
		<cfset var q = application.fapi.getContentObjects(typename = "youtubeVideo",lProperties = "objectid", maxrows = 1, orderby = "datetimelastupdated desc", link_eq = arguments.link) />
		<cfreturn q.recordCount />
	</cffunction>
		
	<cffunction name="getVideoByLink" access="public" output="false" returntype="struct" hint="Returns the video identified by the Link from the API">
		<cfargument name="link" type="string" required="true" />
		<cfset var q = application.fapi.getContentObjects(typename = "youtubeVideo",lProperties = "objectid", maxrows = 1, orderby = "datetimelastupdated desc", link_eq = arguments.link) />
		<cfif q.recordCount>
			<cfreturn getData(q.objectid[1]) />
		<cfelse>
			<cfreturn {} />
		</cfif>
	</cffunction>	
	
</cfcomponent>