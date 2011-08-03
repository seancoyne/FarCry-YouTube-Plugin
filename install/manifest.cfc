<cfcomponent extends="farcry.core.webtop.install.manifest" name="manifest">

	<cfset this.name = "YouTube" />
	<cfset this.description = "Provides integration with YouTube" />
	<cfset this.lRequiredPlugins = "" />
	<cfset addSupportedCore(majorVersion="6", minorVersion="0", patchVersion="14") />
		
</cfcomponent>