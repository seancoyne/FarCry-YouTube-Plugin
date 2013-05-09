<cfsetting enablecfoutputonly="true" />

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />

<skin:registerJs id="youtube" baseHref="#application.fapi.getwebroot()#/youtube/js" lFiles="youtube.js" />

<skin:registerJs id="fancybox" baseHref="#application.fapi.getwebroot()#/youtube/js/fancybox" lFiles="jquery.mousewheel-3.0.4.pack.js,jquery.easing-1.3.pack.js,jquery.fancybox-1.3.4.pack.js" />
<skin:registerCss id="fancybox" baseHref="#application.fapi.getwebroot()#/youtube/js/fancybox" lFiles="jquery.fancybox-1.3.4.css" />

<cfscript>
	application.stPlugins.youtube = {
		oYouTube = createObject("component","farcry.plugins.youtube.packages.custom.custom").init(devkey = application.fapi.getConfig(key = 'youtube', name = 'devkey', default="")),
		oCustomFunctions = createObject("component","farcry.plugins.youtube.packages.custom.customFunctions")
	};
</cfscript>

<cfsetting enablecfoutputonly="false" />