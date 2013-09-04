<cfcomponent output="false" hint="I connect to the Infusionsoft API and handle the responses.">
	
	<cfset variables.ssl      = true />
	<cfset variables.protocol = "https://" />
	<cfset variables.host     = "localhost" />
	<cfset variables.port     = "" />
	<cfset variables.path     = "/" />
	<cfset variables.user     = "" />
	<cfset variables.password = "" />
	<cfset variables.timeout  = 30 />
	
	
	<cffunction name="init" output="false" access="public">
		<cfargument name="ssl" type="boolean" required="true" />
		<cfargument name="host" type="string" required="true" />
		<cfargument name="path" type="string" required="false" />
		<cfargument name="port" type="numeric" required="false" />
		<cfargument name="user" type="string" required="false" />
		<cfargument name="password" type="string" required="false" />
		<cfargument name="timeout" type="numeric" required="false" />
		
		<cfset variables.ssl = arguments.ssl />
		
		<cfif not variables.ssl>
			<cfset variables.protocol = "http://" />
		</cfif>
		
		<cfset variables.host = arguments.host />
		
		<cfif StructKeyExists(arguments, "path")>
			<cfset variables.path = arguments.path />
		</cfif>
		
		<cfif StructKeyExists(arguments, "port")>
			<cfset variables.port = ":" & arguments.port />
		</cfif>
		
		<cfif StructKeyExists(arguments, "user")>
			<cfset variables.user = arguments.user />
		</cfif>
		
		<cfif StructKeyExists(arguments, "password")>
			<cfset variables.password = arguments.password />
		</cfif>
		
		<cfif StructKeyExists(arguments, "timeout")>
			<cfset variables.timeout = arguments.timeout />
		</cfif>
		
		<cfreturn this />
	</cffunction>

	<cffunction name="getUrl" output="false" access="public" returntype="string">
		<cfset var loc = StructNew() />
		<cfset loc.url = variables.protocol & variables.host & variables.port & variables.path />
		<cfreturn loc.url />
	</cffunction>

	<cffunction name="call" output="false" access="public" returntype="string" hint="I take a well formed xml rpc request and send it off to a server for processing.">
		<cfargument name="xmlToSend" type="string" required="true" />
		<cfset var cfhttp = {} />
		<cfset var cfhttpAttrs = {}>
		
		<!--- Only provide username and password if they are provided --->
		<cfif Len(variables.user)>
			<cfset cfhttpAttrs.username = variables.user />
		</cfif>
		<cfif Len(variables.password)>
			<cfset cfhttpAttrs.password = variables.password />
		</cfif>

		<!--- send it off --->
		<cfhttp method="POST" url="#this.getUrl()#" throwonerror="false" timeout="#variables.timeout#" attributecollection="#cfhttpAttrs#">
			<cfhttpparam name="param1" value="#arguments.xmlToSend#" type="xml" />
		</cfhttp>
		
		<!--- check for http errors --->
		<cfif LCase(cfhttp.statusCode) neq "200 ok">
		
			<!--- if you don't succeed at first, try again --->
			<cfhttp method="POST" url="#this.getUrl()#" throwonerror="false" timeout="#variables.timeout#" username="#variables.user#" password="#variables.password#">
				<cfhttpparam name="param1" value="#arguments.xmlToSend#" type="xml" />
			</cfhttp>		
		
			<cfif LCase(cfhttp.statusCode) neq "200 ok">
				<!--- if we have some kind of connection error try again --->
				<cfthrow type="xmlrpc.httpError"
						 message="There was an error in connection to Infusionsoft's servers."
						 detail="Original error message (#cfhttp.errorDetail#)" />
			</cfif>
		</cfif> 
		
		<!--- return the raw response so the client can do what they wish --->
		<cfreturn cfhttp.fileContent />
	</cffunction>
	
</cfcomponent>