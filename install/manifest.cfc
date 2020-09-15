<cfcomponent extends="farcry.core.webtop.install.manifest" name="manifest">

	<cfset this.name = "YouTube" />
	<cfset this.description = "Provides integration with YouTube" />
	<cfset this.lRequiredPlugins = "" />
	<cfset addSupportedCore(majorVersion="7", minorVersion="4", patchVersion="0") />
		
</cfcomponent>