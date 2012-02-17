<!-------------------------------------------------------------------------------------------
----	By: James Gibson - Liquifusion Studios, Inc.
----	Date: 5/28/2009
----	
----	I connect to the Infusionsoft API and handle the responses.
--->

<cfcomponent displayname="Connection" output="false" hint="I connect to the Infusionsoft API and handle the responses.">

	<cfset variables.javaLib = true />
	<cfset variables.apiKey = JavaCast("string", "") />
	<cfset variables.queryHelper = CreateObject("component", "com.liquifusion.utility.QueryHelper").init() />
	<cfset variables.client = false />
	
	<cffunction name="init" output="false" access="public" returntype="Connection">
		<cfargument name="subDomain" type="string" required="true" />
		<cfargument name="apiKey" type="string" required="false" default="" />
		<cfargument name="timeout" type="numeric" required="false" default="5" hint="The number of seconds before a request should timeout." />
		<cfscript>
			this.setApiKey(arguments.apiKey);
			
			try 
			{
				variables.url = CreateObject("java", "java.net.URL").init("https://#arguments.subdomain#.infusionsoft.com/api/xmlrpc");
				
				variables.configImpl = CreateObject("java", "org.apache.xmlrpc.client.XmlRpcClientConfigImpl");
				variables.configImpl.setServerURL(variables.url);
				variables.configImpl.setConnectionTimeout(arguments.timeout * 1000);
				
				// create the client object
				variables.client = CreateObject("java", "org.apache.xmlrpc.client.XmlRpcClient");
				variables.client.setConfig(variables.configImpl);
				variables.client.setTransportFactory(CreateObject("java", "org.apache.xmlrpc.client.XmlRpcCommonsTransportFactory").init(variables.client));
			} 
			catch (any e)
			{
				variables.javaLib = false;
				variables.client = CreateObject("component", "com.liquifusion.xmlrpc.Client").init(ssl=true, host=arguments.subdomain & ".infusionsoft.com", path="/api/xmlrpc", timeout=arguments.timeout);
				variables.transform = CreateObject("component", "com.liquifusion.xmlrpc.Transform").init();
			}
		
			return this;
		</cfscript>
	</cffunction>

	<cffunction name="getApiKey" output="false" access="public" returntype="string">
		<cfreturn variables.apiKey />
	</cffunction>

	<cffunction name="setApiKey" output="false" access="public" returntype="void">
		<cfargument name="apiKey" type="string" required="true" />
		
		<cfset variables.apiKey = arguments.apiKey />
	</cffunction>
	
	<cffunction name="call" output="false" access="public" returntype="any">
		<cfargument name="method" type="string" required="true" />
		<cfargument name="parameters" type="array" required="true" />
		<cfargument name="returnType" type="string" required="false" default="" />
		<cfargument name="insertApiKey" type="boolean" required="false" default="true" />
		<cfset var loc = StructNew() />
		<cfset loc.requestXml = "" />
		<cfset loc.parameters = arguments.parameters />
		
		<!--- check to make sure the return type is blank or "Query", these are the only two possibilities --->
		<cfif arguments.returnType neq "" and arguments.returnType neq "Query">
			<cfthrow type="infusionsoft.InvalidReturnType"
					 message="The only valid return types are '' or 'Query'." />
		</cfif>
		
		<!--- insert the key into the first position in the array since the key always goes first --->
		<cfif Len(variables.apiKey) and arguments.insertApiKey>
			<cfset loc.temp = ArrayPrepend(loc.parameters, variables.apiKey) />
		</cfif>
		
		<!--- check to make sure the object has been initialized --->
		<cfif IsBoolean(variables.client)>
			<cfthrow type="SDK.objectNotInitialized"
					 message="You must first call the init() method of the SDK."
					 detail="Please review the SDK documentation.cfm file for how to instantiate the Sdk.cfc component." />
		</cfif>
			
		<!--- call client execute method to send off the request --->
		<cfif variables.javaLib>
			<cfset loc.response = variables.client.execute(arguments.method, loc.parameters) />
			
			<!--- turn response into a query if needed ---> 
			<cfif arguments.returnType eq "Query">
				<cfset loc.response = variables.queryHelper.toQuery(loc.response) />
			</cfif>
		<cfelse>
			<cfset loc.requestXml = variables.transform.cfmlToXmlRpcRequest(arguments.method, loc.parameters) />		
			<cfset loc.responseXml = variables.client.call(loc.requestXml) />
			
			<cfif arguments.returnType eq "Query">
				<cfset loc.responseObj = variables.transform.xmlRpcToCfmlQuery(loc.responseXml) />
			<cfelse>
				<cfset loc.responseObj = variables.transform.xmlRpcToCfml(loc.responseXml) />
			</cfif>
			
			<cfif StructKeyExists(loc.responseObj.fault, "faultCode") and StructKeyExists(loc.responseObj.fault, "faultString")>
				<cfthrow type="infusionsoft.errorResponse"
						 message="There was an error sent back from the infusionosft API"
						 detail="Error code (#loc.responseObj.fault.faultCode#) and message (#loc.responseObj.fault.faultString#)." />
			</cfif>
			
			<cfset loc.response = loc.responseObj.params[1] />
		</cfif>
		<cfreturn loc.response />
	</cffunction>
	
</cfcomponent>
