<cfcomponent output="false" extends="farcry.core.packages.types.types" fuAlias="video" displayname="YouTube Video" hint="Manages videos imported from YouTube" bFriendly="true" bObjectBroker="true">
	
	<cfproperty ftSeq="100" ftFieldset="Video" ftLabel="ID" ftDisplayOnly="true" name="id" type="nstring" ftType="string" default="" />
	<cfproperty ftSeq="110" ftFieldset="Video" ftLabel="Title" ftDisplayOnly="true" name="title" bLabel="true" type="nstring" ftType="string" default="" />
	<cfproperty ftSeq="140" ftFieldset="Video" ftLabel="Description" ftDisplayOnly="true" name="description" type="longchar" ftType="longchar" default="" />
	<cfproperty ftSeq="210" ftFieldset="Status" ftLabel="Published (YouTube)" ftDisplayOnly="true" name="published" type="date" ftType="datetime" default="" />
	<cfproperty ftSeq="600" ftFieldset="Thumbnail" ftLabel="Thumb. Height" ftDisplayOnly="true" name="thumbnail_height" type="integer" ftType="integer" default="0" />
	<cfproperty ftSeq="610" ftFieldset="Thumbnail" ftLabel="Thumb. URL" ftDisplayOnly="true" name="thumbnail_url" type="nstring" ftType="url" default="" />
	<cfproperty ftSeq="620" ftFieldset="Thumbnail" ftLabel="Thumb. Width" ftDisplayOnly="true" name="thumbnail_width" type="integer" ftType="integer" default="0" />
	
	<cfscript>
	
	public struct function getById(required string id) {
		
		var q = application.fapi.getContentObjects(typename = "youtubeVideo", lProperties = "objectid", id_eq = arguments.id);
		
		if (!q.recordcount) {
			return {};
		}
		
		return getData(q.objectid[1]);
		
	}	
	
	</cfscript>
	
</cfcomponent>