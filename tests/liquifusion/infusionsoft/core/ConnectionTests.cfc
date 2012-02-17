<cfcomponent displayname="ConnectionTests" extends="net.sourceforge.cfunit.framework.TestCase">
	<cfproperty name="tempCFC" type="Connection" />
	
	<cffunction name="setUp" returntype="void" access="public">
		<cfset variables.tempCFC = CreateObject("component", "com.liquifusion.infusionsoft.core.Connection").init("reservoir", "a3980bffe1c6958ac24bb9b9060ff441") />
	</cffunction>
	
	<cffunction name="testGetApiKey" returntype="void" access="public">
		<cfset var loc = StructNew() />
		<cfset loc.result = variables.tempCFC.getApiKey() />
		<cfinvoke method="assertEquals">
			<cfinvokeargument name="expected" value="a3980bffe1c6958ac24bb9b9060ff441" />
			<cfinvokeargument name="actual" value="#loc.result#" />
		</cfinvoke>
	</cffunction>
	
	<cffunction name="testSetApiKey" returntype="void" access="public">
		<cfset var loc = StructNew() />
		<cfset variables.tempCFC.setApiKey("anyoldapikey") />
		<cfset loc.result = variables.tempCFC.getApiKey() />
		<cfinvoke method="assertEquals">
			<cfinvokeargument name="expected" value="anyoldapikey" />
			<cfinvokeargument name="actual" value="#loc.result#" />
		</cfinvoke>
	</cffunction>
	
	<!--- this is a manual test since it is connecting to live data
		  We will leave it commented out unless we need to test the an api
	--->
	<cffunction name="testCall" returntype="void" access="public">
		<cfset var loc = StructNew() />
		<cfset loc.array = ArrayNew(1) />
		<cfset loc.array[1] = JavaCast("string", "Contact") />
		<cfset loc.array[2] = JavaCast("int", 100) />
		<cfset loc.array[3] = JavaCast("int", 0) />
		<cfset loc.array[4] = StructNew() />
		<cfset loc.array[4]["FirstName"] = JavaCast("string", "%a%") />
		<cfset loc.array[5] = ArrayNew(1) />
		<cfset loc.array[5][1] = JavaCast("string", "FirstName") />
		<cfset loc.array[5][2] = JavaCast("string", "LastName") />
		<cfset loc.array[5][3] = JavaCast("string", "Id") />

		<cfset loc.result = variables.tempCFC.call("DataService.query", loc.array, "Query") />
		<cfinvoke method="assertEquals">
			<cfinvokeargument name="expected" value="#YesNoFormat(true)#" />
			<cfinvokeargument name="actual" value="#YesNoFormat(IsQuery(loc.result))#" />
		</cfinvoke>
	</cffunction>
	
</cfcomponent>
