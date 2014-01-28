<cfcomponent output="false" extends="youtube">
	<cffunction name="countVideosForUser" access="public" returntype="numeric" output="false">
		<cfargument name="username" type="string" required="true">
		<cfset var baseurl = "http://gdata.youtube.com/feeds/api/users/#arguments.username#/uploads?start-index=1&max-results=1">
		<cfset var result = "" />
		<cfhttp url="#baseurl#" result="result">	
		<cfset result = result.filecontent>
		<cfset var packet = xmlParse(result)>
		<cfreturn packet.feed["openSearch:totalResults"].xmlText>
	</cffunction>
	<cffunction name="getVideosByUser" access="public" returnType="query" output="false"
				hint="Gets videos for a user.">
		<cfargument name="username" type="string" required="true">
		<cfset var totNum = countVideosForUser(arguments.username) />
		<cfset var start = 1 />
		<cfset var q = "" />
		<cfset var qThisBatch = "" />
		<cfloop from="1" to="#totNum#" step="50" index="start">
			<cfif start gt totNum>
				<cfbreak />
			</cfif>
			<cfset var baseurl = "http://gdata.youtube.com/feeds/api/users/#arguments.username#/uploads?start-index=" & start & "&max-results=50">	
			<cfset qThisBatch = getVideos(baseurl) />
			<cfif not isQuery(q)>
				<cfquery name="q" dbtype="query">
				select #qThisBatch.columnlist# from qThisBatch where 1 = 0;
				</cfquery>
			</cfif>
			<cfquery name="q" dbtype="query">
			select #qThisBatch.columnlist# from q
			union all
			select #qThisBatch.columnlist# from qThisBatch
			</cfquery>
		</cfloop>

		<cfreturn q>
	</cffunction>
	<cffunction name="getEmbedCode" access="public" returnType="string" output="false" hint="Utility function to return embed html">
		<cfargument name="videoid" type="string" required="true">
		<cfargument name="width" type="string" required="false" default="425" />
		<cfargument name="height" type="string" required="false" default="355" />
		<!--- Video ID may include the URL, strip it --->
		<cfset arguments.videoid = replace(arguments.videoid, "http://gdata.youtube.com/feeds/api/videos/","")>
		<cfset arguments.videoid = listFirst(arguments.videoid, "&")>
		<cfscript>
		var html = "<iframe ";
		if (isNumeric(arguments.width)) {
			html = html & 'width="' & arguments.width & '" ';
		}
		if (isNumeric(arguments.height)) {
			html = html & 'height="' & arguments.height & '" ';
		}
		html = html & 'src="http://www.youtube.com/embed/' & arguments.videoId & '" frameborder="0" allowfullscreen></iframe>';
		return html;
		</cfscript>
	</cffunction>
	<cffunction name="getPlaylists" access="public" returnType="query" output="false"
			hint="Gets playlists for a user.">
		<cfargument name="user" type="string" required="true">
		<cfargument name="startindex" type="numeric" required="true" default="1">
		<cfargument name="max" type="numeric" required="true" default="25">

		<cfset var baseurl = "http://gdata.youtube.com/feeds/api/users/#arguments.user#/playlists">
		<cfset var result = "">
		<cfset var results = queryNew("total,url,published,updated,title,content,author,authorurl,videocount,playlistid,thumbnail_url,thumbnail_width,thumbnail_height")>
		<cfset var x = "">
		<cfset var total = "">
		<cfset var entry = "">
		<cfset var thumbMatches = [] />

		<cfset baseurl &= "?start-index=#arguments.startindex#&max-results=#arguments.max#">
		
		<cfhttp url="#baseurl#" result="result">
		<cfset result = xmlParse(result.filecontent)>
		<cfif not structKeyExists(result.feed, "entry")>
			<cfreturn results>
		</cfif>

		<cfset total = result.feed["openSearch:totalResults"].xmlText>
			
		<cfloop index="x" from="1" to="#arrayLen(result.feed.entry)#">
			<cfset entry = result.feed.entry[x]>
			<cfset queryAddRow(results)>
			<cfset querySetCell(results, "total", total)>
			<cfset querySetCell(results, "url", entry["gd:feedLink"].xmlAttributes.href)>
			<cfset querySetCell(results, "published", handleDate(entry.published.xmlText))>
			<cfset querySetCell(results, "updated", handleDate(entry.updated.xmlText))>
			<cfset querySetCell(results, "title", entry.title.xmlText)>
			<cfset querySetCell(results, "content", entry.content.xmlText)>
			<cfset querySetCell(results, "author", entry.author.name.xmlText)>
			<cfset querySetCell(results, "authorurl", entry.author.uri.xmlText)>
			<cfset querySetCell(results, "videocount", entry["gd:feedLink"].xmlAttributes.countHint)>
			<cfset querySetCell(results, "playlistID", entry["yt:playlistId"].xmlText)>

			<cfset thumbMatches = xmlSearch(entry, "media:group/media:thumbnail[@yt:name='default']") />
			<cfif arrayLen(thumbMatches)>
				<cfset querySetCell(results, "thumbnail_url", thumbMatches[1].xmlAttributes['url']) />
				<cfset querySetCell(results, "thumbnail_width", thumbMatches[1].xmlAttributes['width']) />
				<cfset querySetCell(results, "thumbnail_height", thumbMatches[1].xmlAttributes['height']) />
			</cfif>
			
		</cfloop>
		<cfreturn results>
	</cffunction>
</cfcomponent>