<cfcomponent output="false">

	<cfset variables.instance = StructNew() />
	<cfset variables.instance.string = JavaCast("string", "a string") />
	<cfset variables.instance.double = JavaCast("double", 1.25) />
	<cfset variables.instance.integer = JavaCast("int", 10) />
	<cfset variables.instance.boolean = JavaCast("boolean", false) />
	
	<cffunction name="init" access="public">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="xmlRpcToCfml" access="public" returntype="struct" output="true" hint="Accepts an XML-RPC packet and return a struct containing the method name (returnvar.method) and an array of params (returnvar.params)">
		<cfargument name="data" type="string" required="true" hint="A string containing an XML-ROC package" />
		
		<!--- properly scope our variables so that we are thread safe --->
		<cfset var loc = StructNew() />
		<cfset loc.results = StructNew() />
		<cfset loc.data = arguments.data />
		<cfset loc.loopCounter = 0 />
		<cfset loc.params = "" />
		
		<cfset variables.checkData(loc.data) />

		<cfset loc.data  = XmlParse(loc.data) />
		<cfset loc.results.method = variables.xmlObjectToMethodName(loc.data) />
		<cfset loc.results.fault  = variables.xmlObjectToFaultStruct(loc.data) />

		<!--- create our params object to be returned --->
		<cfset loc.params = XmlSearch(loc.data, "//params/param") />
		<cfset loc.results.params = ArrayNew(1) />
		<cfif ArrayLen(loc.params)>
			<cfloop index="loopCounter" from="1" to="#ArrayLen(loc.params)#">
				<cfset loc.results.params[loopCounter] = this.deserialize(loc.params[loopCounter].value[1]) />
			</cfloop>
		</cfif>
		
		<cfreturn loc.results />
	</cffunction>
	
	<cffunction name="xmlRpcToCfmlQuery" access="public" returntype="struct" output="false" hint="I create a query object to be return instead of an array. For use when we want to pull data from a service.">
		<cfargument name="data" type="string" required="true" hint="A string containing an XML-ROC package" />
		<cfset var loc = StructNew() />
		<cfset loc.results = StructNew() />
		<cfset loc.data = arguments.data />
		<cfset loc.dump = "" />
		<cfset loc.x = 0 />
		<cfset loc.y = "" />
		<cfset loc.params = "" />
		<cfset loc.members = "" />
		<cfset loc.length = 0 />
		
		<cfset variables.checkData(loc.data) />

		<cfset loc.data  = XmlParse(loc.data) />
		<cfset loc.results.method = variables.xmlObjectToMethodName(loc.data) />
		<cfset loc.results.fault  = variables.xmlObjectToFaultStruct(loc.data) />

		<cfset loc.params = XmlSearch(loc.data, "//params/param/value/array/data/value/struct") />
		<cfset loc.length = ArrayLen(loc.params) />
		
		<!--- create our params object to be returned --->
		<cfset loc.results.params = ArrayNew(1) />
		
		<cfif IsArray(loc.params) and ArrayLen(loc.params) gt 0>
		
			<cfset loc.results.params[1] = QueryNew(variables.getQueryColumnNames(loc.params)) />
			
			<!--- add all of the row ahead of the loop --->
			<cfset loc.dump = QueryAddRow(loc.results.params[1], loc.length)>
			
			<cfloop index="loc.x" from="1" to="#loc.length#">
				<cfloop index="loc.y" from="1" to="#ArrayLen(loc.params[loc.x].xmlChildren)#">
					<cfset loc.dump = QuerySetCell(loc.results.params[1], 
												   Replace(this.deserialize(loc.params[loc.x].xmlChildren[loc.y].name), "_", "custom_", "all"), 
												   this.deserialize(loc.params[loc.x].xmlChildren[loc.y].value),
												   loc.x) /> 
				</cfloop>
			</cfloop>
		<cfelse>
			<cfset loc.results.params[1] = QueryNew("empty") />
		</cfif>
		
		<cfreturn loc.results />
	</cffunction>
	
	<cffunction name="cfmlToXmlRpcRequest" access="public" returntype="string" output="false" hint="I create the XML necessary to make an XML-RPC call.">
		<cfargument name="method" required="true" type="string" />
		<cfargument name="parameters" required="true" type="array" />
		<cfset var loc = StructNew() />
		<cfset loc.loopCounter = 0 />
		<cfset loc.method = arguments.method />
		<cfset loc.parameters = arguments.parameters />
		<cfset loc.parameterXml = "<param>{value}</param>" />
		<cfset loc.parameterString = "" />
		<cfsavecontent variable="loc.xml">
			<methodCall>
				<methodName>{method}</methodName>
			  	<params>
					{parameters}
				</params>
			</methodCall>
		</cfsavecontent>
		
		<cfset loc.xml = Replace(loc.xml, "{method}", loc.method) />
		<cfloop index="loc.loopCounter" from="1" to="#ArrayLen(loc.parameters)#">
			<cfset loc.parameterString = loc.parameterString & Replace(loc.parameterXml, "{value}", this.serialize(loc.parameters[loc.loopCounter])) />
		</cfloop>
		<cfset loc.xml = Replace(loc.xml, "{parameters}", loc.parameterString) />
		 	
		<cfreturn loc.xml />
	</cffunction>
	
	
	<!------------------------------------------------------
		All simple variables passed into serialize must 
		be cast using JavaCast() so that we can properly
		catch the type here and serialize as necessary.
	------------------------------------------------------->
	<cffunction name="serialize" access="public" output="false">
		<cfargument name="branch" required="true" type="any" />
		<cfset var loc = StructNew() />
		<cfset loc.results = "" />
		<cfset loc.temp = "" />
		<cfset loc.arrayWrapper  = "<value><array><data>{items}</data></array></value>" />
		<cfset loc.structWrapper = "<value><struct>{items}</struct></value>" />
		<cfset loc.structMember  = "<member>{name}{value}</member>" />
		<cfset loc.structKey     = "<name>{key}</name>" />
		<cfset loc.branch = arguments.branch />
		<cfset loc.loopCounter = 0 />
		
		<cfif IsStruct(loc.branch)>
			<cfloop item="loc.loopCounter" collection="#loc.branch#">
				<cfset loc.temp = Replace(loc.structKey, "{key}", loc.loopCounter) />
				<cfset loc.temp = Replace(loc.structMember, "{name}", loc.temp) />
				<cfset loc.results = loc.results & Replace(loc.temp, "{value}", this.serialize(loc.branch[loc.loopCounter])) />
			</cfloop>
			<cfset loc.results = Replace(loc.structWrapper, "{items}", loc.results) />
			
		<cfelseif IsBinary(loc.branch)>
			<cfset loc.results = variables.toXml(ToBase64(loc.branch), "base64") />
		
		<cfelseif IsArray(loc.branch)>
			<cfloop index="loc.loopCounter" from="1" to="#ArrayLen(loc.branch)#">
				<cfset loc.results = loc.results & this.serialize(loc.branch[loc.loopCounter]) />
			</cfloop>
			<cfset loc.results = Replace(loc.arrayWrapper, "{items}", loc.results) />
			
		<cfelseif IsDate(loc.branch)>
			<cfset loc.results = variables.toXml(variables.formatDateTime(loc.branch), "dateTime.iso8601") />
		
		<cfelseif loc.branch.getClass().isInstance(variables.instance.integer)>	
		<!--- 
			Note: in order to be CF7 compatible, we cannot use IsInstanceOf() 
			<cfelseif IsInstanceOf(loc.branch, "java.lang.Integer")>
		--->
			<cfset loc.results = variables.toXml(Int(loc.branch), "int") />
		
		<cfelseif loc.branch.getClass().isInstance(variables.instance.double)>	
		<!--- 
			Note: in order to be CF7 compatible, we cannot use IsInstanceOf() 
			<cfelseif IsInstanceOf(loc.branch, "java.lang.Double")>
		--->
			<cfset loc.results = variables.toXml(loc.branch, "double") />
			
		<cfelseif loc.branch.getClass().isInstance(variables.instance.boolean)>	
		<!--- 
			Note: in order to be CF7 compatible, we cannot use IsInstanceOf() 
			<cfelseif IsInstanceOf(loc.branch, "java.lang.Boolean")>
		--->
			<cfset loc.results = variables.toXml(Int(loc.branch), "boolean") />

		<cfelseif loc.branch.getClass().isInstance(variables.instance.string)>	
		<!--- 
			Note: in order to be CF7 compatible, we cannot use IsInstanceOf() 
			<cfelseif IsInstanceOf(loc.branch, "java.lang.String")>
		--->
			<cfset loc.results = variables.toXml(XmlFormat(loc.branch), "string") />
		
		</cfif>

		<cfreturn loc.results />
	</cffunction>	
	
	<!--- 
		TODO: namespaces have not been tested properly!!!! 
	--->
	<cffunction name="deserialize" access="public" output="false" returntype="any">
		<cfargument name="branch" required="true" />
		<cfargument name="namespace" required="false" default="" />
		<cfset var loc = StructNew() />
		<cfset loc.results = "" />
		<cfset loc.array = "" />
		<cfset loc.loopCounter = 0 />
		<cfset loc.branch = arguments.branch />
		<cfset loc.namespace = variables.applyNamespace(arguments.namespace) />
		
		<!--- check to make sure we have something --->
		<cfif not Len(loc.branch)>
			<cfthrow type="xmlrpc.missingXml" 
					 message="XML-RPC message not found for deserialization." />
		</cfif>
		
		<cfif StructKeyExists(loc.branch, "#loc.namespace#string")>
			<cfset loc.results = ToString(loc.branch["#loc.namespace#string"].xmlText) />
			
		<cfelseif StructKeyExists(loc.branch, "#loc.namespace#boolean")>
			<cfset loc.results =  YesNoFormat(loc.branch["#loc.namespace#boolean"].xmlText) />
			
		<cfelseif StructKeyExists(loc.branch, "#loc.namespace#i4")>
			<cfset loc.results = Int(loc.branch["#loc.namespace#i4"].xmlText) />
			
		<cfelseif StructKeyExists(loc.branch, "#loc.namespace#int")>
			<cfset loc.results = Int(loc.branch["#loc.namespace#int"].xmlText) />
			
		<cfelseif StructKeyExists(loc.branch, "#loc.namespace#double")>
			<cfset loc.results = Val(loc.branch["#loc.namespace#double"].xmlText) />
			
		<cfelseif StructKeyExists(loc.branch, "#loc.namespace#base64")>
			<cfset loc.results = loc.branch["#loc.namespace#base64"].xmlText />
			
		<cfelseif StructKeyExists(loc.branch, "#loc.namespace#dateTime.iso8601")>
			<cfset loc.results = variables.xmlObjectToDateTime(loc.branch, loc.namespace) />
			
		<cfelseif StructKeyExists(loc.branch, "#loc.namespace#array")>
			<cfset loc.results = variables.xmlObjectToArray(loc.branch, loc.namespace) />
			
		<cfelseif StructKeyExists(loc.branch, "#loc.namespace#struct")>
			<cfset loc.results = variables.xmlObjectToStruct(loc.branch, loc.namespace) />
			
		<cfelse>
			<!--- if no type is specified, we assume that it is a string so just set the results to what was passed in --->
			<cftry>
				<cfset loc.results = ToString(loc.branch.xmlText) />
				<cfcatch type="any">
					<cfthrow type="xmlrpc.unknownDataType"
							 message="The method transform.deserialize() was unable to retrive data from the branch." />
				</cfcatch>
			</cftry>
		</cfif>

		<cfreturn loc.results />
	</cffunction>
	
	<!--- PRIVATE METHODS --->
	
	<cffunction name="toXml" output="false" access="private" returntype="string">
		<cfargument name="value" required="true" type="any" />
		<cfargument name="tagName" required="true" type="string" />
		<cfset var loc = StructNew() />
		<cfset loc.simpleTag = "<value><{tagName}>{value}</{tagName}></value>" />
		<cfset loc.results = "" />
		
		<cfset loc.results = Replace(loc.simpleTag, "{tagName}", arguments.tagName, "all") />
		<cfset loc.results = Replace(loc.results  , "{value}"  , arguments.value) />
		
		<cfreturn loc.results />
	</cffunction>
	
	<cffunction name="formatDateTime" output="false" access="private" returntype="any">
		<cfargument name="dateTime" required="true" type="date" />
		<cfset var loc = StructNew() />
		<cfset loc.value = ParseDateTime(arguments.dateTime) />
		<cfset loc.value = DateFormat(loc.value, "yyyymmdd") & "T" & TimeFormat(loc.value, "HH:mm:ss") />
		<cfreturn loc.value />
	</cffunction>
	
	<cffunction name="getQueryColumnNames" access="private" output="false" returntype="string">
		<cfargument name="paramArray" required="true" />
		<cfset var loc = StructNew() />
		<cfset loc.paramArray = arguments.paramArray />
		<cfset loc.members = "" />
		<cfset loc.results = "" />
		
		<cfloop index="loc.y" from="1" to="#ArrayLen(loc.paramArray)#">
			<cfset loc.members = loc.paramArray[loc.y].xmlChildren />
			<cfloop index="loc.x" from="1" to="#ArrayLen(loc.members)#">
				<cfif not ListFind(loc.results, Replace(Trim(loc.members[loc.x].name.xmlText), "_", "custom_", "all"))>
					<cfset loc.results = ListAppend(loc.results, Replace(Trim(loc.members[loc.x].name.xmlText), "_", "custom_", "all")) />
				</cfif>
			</cfloop>		
		</cfloop>

		<cfreturn loc.results />
	</cffunction>
	
	<cffunction name="checkData" access="private" output="false" returntype="void">
		<cfargument name="data" required="true" />
		<cfif not Len(arguments.data)>
			<cfthrow type="xmlrpc.missingXml" 
					 message="XML-RPC message not found for deserialization." />
		</cfif>
	</cffunction>
	
	<cffunction name="xmlObjectToMethodName" access="private" output="false" returntype="string">
		<cfargument name="xmlObject" required="true" />
		<cfset var loc = StructNew() />
		<cfset loc.search = "" />
		<cfset loc.result = "" />
		
		<!--- get the method object to be returned --->
		<cfset loc.search = XmlSearch(arguments.xmlObject, "//methodName") />
		<cfif ArrayLen(loc.search) eq 1>
			<cfset loc.result = ToString(loc.search[1].xmlText) />
		</cfif>
		
		<cfreturn loc.result />
	</cffunction>
	
	<cffunction name="xmlObjectToFaultStruct" access="private" output="false" returntype="struct">
		<cfargument name="xmlObject" required="true" />
		<cfset var loc = StructNew() />
		<cfset loc.search = "" />
		<cfset loc.result = "" />
		
		<!--- create our fault object to be returned --->
		<cfset loc.search = XmlSearch(arguments.xmlObject, "//fault") />
		<cfset loc.result = StructNew() />
		<cfif ArrayLen(loc.search)>
			<cfset loc.result = this.deserialize(loc.search[1].value[1]) />
		</cfif>
		
		<cfreturn loc.result />
	</cffunction>
	
	<cffunction name="xmlObjectToDateTime" access="private" output="false" returntype="date">
		<cfargument name="branch" required="true" />
		<cfargument name="namespace" required="false" default="" />
		<cfset var loc = StructNew() />
		<cfset loc.x = 0 />
		<cfset loc.array = ArrayNew(1) />
		<cfset loc.branch = arguments.branch />
		<cfset loc.namespace = arguments.namespace />
		
		<cfset loc.branch = loc.branch["#loc.namespace#dateTime.iso8601"].xmlText />
		<cfset loc.branch = Insert("-", loc.branch, 4) />
		<cfset loc.branch = Insert("-", loc.branch, 7) />
		<cfset loc.branch = Replace(loc.branch, "T", " ", "one") />
		<cfset loc.branch = ParseDateTime(loc.branch) />
		
		<cfreturn loc.branch />
	</cffunction>
	
	<cffunction name="xmlObjectToArray" access="private" output="false" returntype="array">
		<cfargument name="branch" required="true" />
		<cfargument name="namespace" required="false" default="" />
		<cfset var loc = StructNew() />
		<cfset loc.x = 0 />
		<cfset loc.array = ArrayNew(1) />
		<cfset loc.branch = arguments.branch />
		<cfset loc.namespace = arguments.namespace />
		
		<cfset loc.branch = XmlSearch(loc.branch, "#loc.namespace#array/#loc.namespace#data/#loc.namespace#value") />
		<cfloop index="loc.x" from="1" to="#ArrayLen(loc.branch)#">
			<cfset loc.array[loc.x] = this.deserialize(branch=loc.branch[loc.x], namespace=loc.namespace) />
		</cfloop>

		<cfreturn loc.array />
	</cffunction>
	
	<cffunction name="xmlObjectToStruct" access="private" output="false" returntype="struct">
		<cfargument name="branch" required="true" />
		<cfargument name="namespace" required="false" default="" />
		<cfset var loc = StructNew() />
		<cfset loc.x = 0 />
		<cfset loc.key = "" />
		<cfset loc.branch = arguments.branch />
		<cfset loc.structure = StructNew() />
		<cfset loc.namespace = arguments.namespace />
		
		<cfset loc.branch = XmlSearch(loc.branch, "#loc.namespace#struct/#loc.namespace#member") />
		<cfloop index="loc.x" from="1" to="#ArrayLen(loc.branch)#">
			<cfset loc.key = loc.branch[loc.x]["#loc.namespace#name"].xmlText />
			<cfset loc.structure[loc.key] = this.deserialize(branch=loc.branch[loc.x]["#loc.namespace#value"][1], namespace=loc.namespace) />
		</cfloop>
		
		<cfreturn loc.structure />
	</cffunction>
	
	<cffunction name="applyNamespace" access="private" output="false" returntype="string">
		<cfargument name="namespace" required="true" type="string" />
		<cfset var loc = StructNew() />
		<cfset loc.namespace = "" />
		
		<cfif Len(arguments.namespace)>
			<cfset loc.namespace = arguments.namespace & ":" />
		</cfif>
		
		<cfreturn loc.namespace />
	</cffunction>

</cfcomponent>