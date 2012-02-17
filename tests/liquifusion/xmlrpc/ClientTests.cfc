<cfcomponent displayname="ConnectionTests" extends="net.sourceforge.cfunit.framework.TestCase">
	<cfproperty name="tempCFC" type="com.liquifusion.xmlrpc.Client" />
	
	<cffunction name="setUp" returntype="void" access="public">
		<cfset variables.tempCFC = CreateObject("component", "com.liquifusion.xmlrpc.Client").init(ssl = true, host = "reservoir.infusionsoft.com", path = "/api/xmlrpc") />
	</cffunction>

	<cffunction name="testGetUrl" returntype="void" access="public">
		<cfset var loc = StructNew() />
		<cfset loc.result = variables.tempCFC.getUrl() />
		<cfinvoke method="assertEquals">
			<cfinvokeargument name="expected" value="https://reservoir.infusionsoft.com/api/xmlrpc" />
			<cfinvokeargument name="actual" value="#loc.result#" />
		</cfinvoke>
	</cffunction>
	
	<!--- this is a manual test since it is connecting to live data
		  We will leave it commented out unless we need to test the an api 
	<cffunction name="testCall" returntype="void" access="public">
		<cfset var loc = StructNew() />
		<cfset loc.array = ArrayNew(1) />
		<cfset loc.array[1] = JavaCast("string", "a3980bffe1c6958ac24bb9b9060ff441") />
		<cfset loc.array[2] = JavaCast("string", "Contact") />
		<cfset loc.array[3] = JavaCast("int"   , 100) />
		<cfset loc.array[4] = JavaCast("int"   , 0) />
		<cfset loc.array[5] = StructNew() />
		<cfset loc.array[5]["FirstName"] = JavaCast("string", "%a%") />
		<cfset loc.array[6] = ArrayNew(1) />
		<cfset loc.array[6][1] = JavaCast("string", "FirstName") />
		<cfset loc.array[6][2] = JavaCast("string", "LastName") />
		<cfset loc.array[6][3] = JavaCast("string", "Id") />
		<cfset loc.transform = CreateObject("component", "com.liquifusion.xmlrpc.Transform").init() />
		<cfset loc.xml = loc.transform.cfmlToXmlRpcRequest("DataService.query", loc.array) />

		<cfset loc.result = variables.tempCFC.call(loc.xml) />
		
		<cfset loc.result = loc.transform.xmlRpcToCfmlQuery(loc.result) />
		
		<cfdump var="#loc.result#" />
		<cfabort />
	
	</cffunction>
	--->
	
</cfcomponent>