<cfcomponent displayname="MyCFCTest" extends="net.sourceforge.cfunit.framework.TestCase">
	<cfproperty name="tempCFC" type="com.liquifusion.xmlrpc.Transform">
	
	<cffunction name="setUp" returntype="void" access="public">
		<cfset variables.tempCFC = CreateObject("component", "com.liquifusion.xmlrpc.Transform").init() />
	</cffunction>
	
	<!------------------------------------------------------
		Tests for .xmlRpcToCfmlQuery() method
		TODO: create tests
	------------------------------------------------------->
	

	<!------------------------------------------------------
		Tests the XmlRpc.xmlRpcToCfml() method for proper
		arguments and proper errors thrown	
	------------------------------------------------------->
	<cffunction name="testDataArgumentRequired" returntype="void" access="public">
		<cfset var loc = StructNew() />
		<cfset loc.errorThrown = false />
		<cftry>
			<cfset loc.result = variables.tempCFC.xmlRpcToCfml() />
			<cfcatch type="Application">
				<cfset loc.errorThrown = true />
			</cfcatch>
		</cftry>
		<cfset assertTrue("Expected error was thrown", loc.errorThrown) />
	</cffunction>	

	<cffunction name="testDataArgumentLengthRequired" returntype="void" access="public">
		<cfset var loc = StructNew() />
		<cfset loc.errorThrown = false />
		<cftry>
			<cfset loc.result = variables.tempCFC.xmlRpcToCfml("") />
			<cfcatch type="xmlrpc.missingXml">
				<cfset loc.errorThrown = true />
			</cfcatch>
		</cftry>
		<cfset assertTrue("Expected error was thrown", loc.errorThrown) />
	</cffunction>

	<!------------------------------------------------------
		Tests the XmlRpc.cfmlToXmlRpcRequest() method for proper
		arguments and proper errors thrown	
	------------------------------------------------------->
	<cffunction name="testCfmlToXmlRpcRequestAllArgumentsRequired" returntype="void" access="public">
		<cfset var loc = StructNew() />
		<cfset loc.errorThrown = false />
		<cftry>
			<cfset loc.result = variables.tempCFC.cfmlToXmlRpcRequest() />
			<cfcatch type="Application">
				<cfset loc.errorThrown = true />
			</cfcatch>
		</cftry>
		<cfset assertTrue("Expected error was thrown", loc.errorThrown) />
	</cffunction>	
	
	<cffunction name="testCfmlToXmlRpcRequest" returntype="void" access="public">
		<cfset var loc = StructNew() />
		<cfset loc.errorThrown = false />
		<cfsavecontent variable="loc.expected">
			<methodCall>
				<methodName>myObject.methodName</methodName>
			  	<params>
					<param><value><string>Hello world!</string></value></param>
					<param><value><boolean>1</boolean></value></param>
					<param><value><array><data><value><boolean>0</boolean></value></data></array></value></param>
				</params>
			</methodCall>
		</cfsavecontent>
		<cfset loc.method = "myObject.methodName" />
		<cfset loc.array = ArrayNew(1) />
		<cfset loc.array[1] = JavaCast("string", "Hello world!") />
		<cfset loc.array[2] = JavaCast("boolean", true) />
		<cfset loc.array[3] = ArrayNew(1) />
		<cfset loc.array[3][1] = JavaCast("boolean", false) />
		<cfset loc.result = variables.tempCFC.cfmlToXmlRpcRequest(loc.method, loc.array) />			
		<cfset loc.result = XmlParse(loc.result) />
		<cfset loc.expected = XmlParse(loc.expected) />
			
		<cfinvoke method="assertEquals">
			<cfinvokeargument name="expected" value="#loc.expected.methodCall.methodName.xmlText#" />
			<cfinvokeargument name="actual" value="#loc.result.methodCall.methodName.xmlText#" />
		</cfinvoke>
		<cfinvoke method="assertEquals">
			<cfinvokeargument name="expected" value="#loc.expected.methodCall.params.param[1].value.string.xmlText#" />
			<cfinvokeargument name="actual" value="#loc.result.methodCall.params.param[1].value.string.xmlText#" />
		</cfinvoke>
		<cfinvoke method="assertEquals">
			<cfinvokeargument name="expected" value="#loc.expected.methodCall.params.param[2].value.boolean.xmlText#" />
			<cfinvokeargument name="actual" value="#loc.result.methodCall.params.param[2].value.boolean.xmlText#" />
		</cfinvoke>
		<cfinvoke method="assertEquals">
			<cfinvokeargument name="expected" value="#loc.expected.methodCall.params.param[2].value.boolean.xmlText#" />
			<cfinvokeargument name="actual" value="#loc.result.methodCall.params.param[2].value.boolean.xmlText#" />
		</cfinvoke>
		<cfinvoke method="assertEquals">
			<cfinvokeargument name="expected" value="#loc.expected.methodCall.params.param[3].value.array.data.value[1].boolean.xmlText#" />
			<cfinvokeargument name="actual" value="#loc.result.methodCall.params.param[3].value.array.data.value[1].boolean.xmlText#" />
		</cfinvoke>
	</cffunction>	

	<!------------------------------------------------------
		Tests the XmlRpc.xmlRpcToCfml() method with
		proper xml representation of a response to
		be deserialized	
	------------------------------------------------------->
	<cffunction name="testXmlRpcToCfmlFaultResponse" returntype="void" access="public">
		<cfset var loc = StructNew() />
		<cfset loc.xml = "" />
		<cfsavecontent variable="loc.xml">
			<methodResponse>
			  <fault>
				<value>
				  <struct>
					<member>
					  <name>faultCode</name>
					  <value><int>23</int></value>
					</member>
					<member>
					  <name>faultString</name>
					  <value><string>Unknown stock symbol ABCD</string></value>
					</member>
				  </struct>
				</value>
			  </fault>
			</methodResponse>		
		</cfsavecontent>
		<cfset loc.expected = StructNew() />
		<cfset loc.expected["fault"] = StructNew() />
		<cfset loc.expected.fault.faultCode = 23 />
		<cfset loc.expected.fault.faultString = "Unknown stock symbol ABCD" />
		<cfset loc.errorThrown = false />
		<cfset loc.result = variables.tempCFC.xmlRpcToCfml(loc.xml) />		
		<cfinvoke method="assertEquals">
			<cfinvokeargument name="expected" value="#IsStruct(loc.expected)#" />
			<cfinvokeargument name="actual" value="#IsStruct(loc.result)#" />
		</cfinvoke>
		<cfinvoke method="assertEquals">
			<cfinvokeargument name="expected" value="#IsStruct(loc.expected.fault)#" />
			<cfinvokeargument name="actual" value="#IsStruct(loc.result.fault)#" />
		</cfinvoke>
		<cfinvoke method="assertEquals">
			<cfinvokeargument name="expected" value="#StructCount(loc.expected.fault)#" />
			<cfinvokeargument name="actual" value="#StructCount(loc.result.fault)#" />
		</cfinvoke>
		<cfinvoke method="assertEquals">
			<cfinvokeargument name="expected" value="#loc.expected.fault.faultCode#" />
			<cfinvokeargument name="actual" value="#loc.result.fault.faultCode#" />
		</cfinvoke>
		<cfinvoke method="assertEquals">
			<cfinvokeargument name="expected" value="#loc.expected.fault.faultString#" />
			<cfinvokeargument name="actual" value="#loc.result.fault.faultString#" />
		</cfinvoke>
	</cffunction>
	
	<cffunction name="testXmlRpcToCfmlParamsResponse" returntype="void" access="public">
		<cfset var loc = StructNew() />
		<cfset loc.xml = "" />
		<cfsavecontent variable="loc.xml">
			<methodResponse>
			  <params>
				<param>
					<value><string>South Dakota</string></value>
				</param>
			  </params>
			</methodResponse>
		</cfsavecontent>
		<cfset loc.expected = StructNew() />
		<cfset loc.expected["params"] = ArrayNew(1) />
		<cfset loc.expected.params[1] = "South Dakota" />
		<cfset loc.result = variables.tempCFC.xmlRpcToCfml(loc.xml) />		
		<cfinvoke method="assertEquals">
			<cfinvokeargument name="expected" value="#IsStruct(loc.expected)#" />
			<cfinvokeargument name="actual" value="#IsStruct(loc.result)#" />
		</cfinvoke>
		<cfinvoke method="assertEquals">
			<cfinvokeargument name="expected" value="#IsArray(loc.expected.params)#" />
			<cfinvokeargument name="actual" value="#IsArray(loc.result.params)#" />
		</cfinvoke>
		<cfinvoke method="assertEquals">
			<cfinvokeargument name="expected" value="#ArrayLen(loc.expected.params)#" />
			<cfinvokeargument name="actual" value="#ArrayLen(loc.result.params)#" />
		</cfinvoke>
		<cfinvoke method="assertEquals">
			<cfinvokeargument name="expected" value="#loc.expected.params[1]#" />
			<cfinvokeargument name="actual" value="#loc.result.params[1]#" />
		</cfinvoke>
	</cffunction>


	<!------------------------------------------------------
		Tests the XmlRpc.deserialize() method for proper
		arguments and proper errors thrown	
	------------------------------------------------------->	
	<cffunction name="testBranchArgumentRequired" returntype="void" access="public">
		<cfset var loc = StructNew() />
		<cfset loc.errorThrown = false />
		<cftry>
			<cfset loc.result = VARIABLES.tempCFC.deserialize() />
			<cfcatch type="Application">
				<cfset loc.errorThrown = true />
			</cfcatch>
		</cftry>
		<cfset assertTrue("Expected error was thrown", loc.errorThrown) />
	</cffunction>
	
	<cffunction name="testBranchArgumentLengthRequired" returntype="void" access="public">
		<cfset var loc = StructNew() />
		<cfset loc.errorThrown = false />
		<cftry>
			<cfset loc.result = VARIABLES.tempCFC.deserialize("") />
			<cfcatch type="xmlrpc.missingXml">
				<cfset loc.errorThrown = true />
			</cfcatch>
		</cftry>
		<cfset assertTrue("Expected error was thrown", loc.errorThrown) />
	</cffunction>	
		
	<cffunction name="testDataTypeNotFound" returntype="void" access="public">
		<cfset var loc = StructNew() />
		<cfset loc.errorThrown = false />
		<cfset loc.xml = XmlParse("<nil/>") />
		<cftry>
		<cfset loc.result = variables.tempCFC.deserialize(loc.xml) />
			<cfcatch type="xmlrpc.unknownDataType">
				<cfset loc.errorThrown = true />
			</cfcatch>
		</cftry>
		<cfset assertTrue("Expected error was thrown", loc.errorThrown) />
	</cffunction>

	<!------------------------------------------------------
		Tests the XmlRpc.deserialize() method for proper
		deserialization of different types	
	------------------------------------------------------->		
	<cffunction name="testDeserializeString" returntype="void" access="public">
		<cfset var loc = StructNew() />
		<cfset loc.xml = XmlParse("<string>South Dakota</string>") />
		<cfset loc.result = variables.tempCFC.deserialize(loc.xml) />
		<cfinvoke method="assertEquals">
			<cfinvokeargument name="expected" value="South Dakota" />
			<cfinvokeargument name="actual" value="#loc.result#" />
		</cfinvoke>
	</cffunction>
	
	<cffunction name="testDeserializeBase64" returntype="void" access="public">
		<cfset var loc = StructNew() />
		<cfset loc.xml = XmlParse("<base64>eW91IGNhbid0IHJlYWQgdGhpcyE=</base64>") />
		<cfset loc.result = variables.tempCFC.deserialize(loc.xml) />
		<cfinvoke method="assertEquals">
			<cfinvokeargument name="expected" value="#YesNoFormat(true)#" />
			<cfinvokeargument name="actual" value="#YesNoFormat(IsBinary(loc.result))#" />
		</cfinvoke>
	</cffunction>
	
	<cffunction name="testDeserializeBoolean" returntype="void" access="public">
		<cfset var loc = StructNew() />
		<cfset loc.xml = XmlParse("<boolean>1</boolean>") />
		<cfset loc.result = variables.tempCFC.deserialize(loc.xml) />
		<cfinvoke method="assertEquals">
			<cfinvokeargument name="expected" value="#IsBoolean(1)#" />
			<cfinvokeargument name="actual" value="#IsBoolean(loc.result)#" />
		</cfinvoke>
		<cfinvoke method="assertEquals">
			<cfinvokeargument name="expected" value="Yes" />
			<cfinvokeargument name="actual" value="#loc.result#" />
		</cfinvoke>
	</cffunction>
	
	<cffunction name="testDeserializeDateTime" returntype="void" access="public">
		<cfset var loc = StructNew() />
		<cfset loc.xml = XmlParse("<dateTime.iso8601>19980717T14:08:55</dateTime.iso8601>") />
		<cfset loc.expected = CreateDateTime(1998, 07, 17, 14, 08, 55) />
		<cfset loc.result = variables.tempCFC.deserialize(loc.xml) />
		<cfinvoke method="assertEquals">
			<cfinvokeargument name="expected" value="#IsDate(loc.expected)#" />
			<cfinvokeargument name="actual" value="#IsDate(loc.result)#" />
		</cfinvoke>
		<cfinvoke method="assertEquals">
			<cfinvokeargument name="expected" value="#loc.expected#" />
			<cfinvokeargument name="actual" value="#loc.result#" />
		</cfinvoke>
	</cffunction>
	
	<cffunction name="testDeserializeDouble" returntype="void" access="public">
		<cfset var loc = StructNew() />
		<cfset loc.xml = XmlParse("<double>-12.53</double>") />
		<cfset loc.result = variables.tempCFC.deserialize(loc.xml) />
		<cfinvoke method="assertEquals">
			<cfinvokeargument name="expected" value="#IsNumeric(-12.53)#" />
			<cfinvokeargument name="actual" value="#IsNumeric(loc.result)#" />
		</cfinvoke>
		<cfinvoke method="assertEquals">
			<cfinvokeargument name="expected" value="-12.53" />
			<cfinvokeargument name="actual" value="#loc.result#" />
		</cfinvoke>
	</cffunction>
	
	<cffunction name="testDeserializeIntegerI4" returntype="void" access="public">
		<cfset var loc = StructNew() />
		<cfset loc.xml = XmlParse("<i4>42</i4>") />
		<cfset loc.result = variables.tempCFC.deserialize(loc.xml) />
		<cfinvoke method="assertEquals">
			<cfinvokeargument name="expected" value="#IsNumeric(42)#" />
			<cfinvokeargument name="actual" value="#IsNumeric(loc.result)#" />
		</cfinvoke>
		<cfinvoke method="assertEquals">
			<cfinvokeargument name="expected" value="42" />
			<cfinvokeargument name="actual" value="#loc.result#" />
		</cfinvoke>
	</cffunction>
	
	<cffunction name="testDeserializeInteger" returntype="void" access="public">
		<cfset var loc = StructNew() />
		<cfset loc.xml = XmlParse("<int>42</int>") />
		<cfset loc.result = variables.tempCFC.deserialize(loc.xml) />
		<cfinvoke method="assertEquals">
			<cfinvokeargument name="expected" value="#IsNumeric(42)#" />
			<cfinvokeargument name="actual" value="#IsNumeric(loc.result)#" />
		</cfinvoke>
		<cfinvoke method="assertEquals">
			<cfinvokeargument name="expected" value="42" />
			<cfinvokeargument name="actual" value="#loc.result#" />
		</cfinvoke>
	</cffunction>
	
	<cffunction name="testDeserializeArray" returntype="void" access="public">
		<cfset var loc = StructNew() />
		<cfset loc.xml = XmlParse("<array><data><value><i4>1404</i4></value><value><string>Something here</string></value><value><i4>1</i4></value></data></array>") />
		<cfset loc.expected = ArrayNew(1) />
		<cfset loc.expected[1] = 1404 />
		<cfset loc.expected[2] = "Something here" />
		<cfset loc.expected[3] = 1 />
		<cfset loc.result = variables.tempCFC.deserialize(loc.xml) />
		<cfinvoke method="assertEquals">
			<cfinvokeargument name="expected" value="#IsArray(loc.expected)#" />
			<cfinvokeargument name="actual" value="#IsArray(loc.result)#" />
		</cfinvoke>
		<cfinvoke method="assertEquals">
			<cfinvokeargument name="expected" value="#ArrayLen(loc.expected)#" />
			<cfinvokeargument name="actual" value="#ArrayLen(loc.result)#" />
		</cfinvoke>
		<cfinvoke method="assertEquals">
			<cfinvokeargument name="expected" value="#loc.expected[1]#" />
			<cfinvokeargument name="actual" value="#loc.result[1]#" />
		</cfinvoke>
		<cfinvoke method="assertEquals">
			<cfinvokeargument name="expected" value="#loc.expected[2]#" />
			<cfinvokeargument name="actual" value="#loc.result[2]#" />
		</cfinvoke>
		<cfinvoke method="assertEquals">
			<cfinvokeargument name="expected" value="#loc.expected[3]#" />
			<cfinvokeargument name="actual" value="#loc.result[3]#" />
		</cfinvoke>
	</cffunction>
	
	<cffunction name="testDeserializeStruct" returntype="void" access="public">
		<cfset var loc = StructNew() />
		<cfset loc.xml = XmlParse("<struct><member><name>foo</name><value><i4>1</i4></value></member><member><name>bar</name><value><i4>2</i4></value></member></struct>") />
		<cfset loc.expected = StructNew() />
		<cfset loc.expected["foo"] = 1 />
		<cfset loc.expected["bar"] = 2 />
		<cfset loc.result = variables.tempCFC.deserialize(loc.xml) />
		<cfinvoke method="assertEquals">
			<cfinvokeargument name="expected" value="#IsStruct(loc.expected)#" />
			<cfinvokeargument name="actual" value="#IsStruct(loc.result)#" />
		</cfinvoke>
		<cfinvoke method="assertEquals">
			<cfinvokeargument name="expected" value="#StructCount(loc.expected)#" />
			<cfinvokeargument name="actual" value="#StructCount(loc.result)#" />
		</cfinvoke>
		<cfinvoke method="assertEquals">
			<cfinvokeargument name="expected" value="#StructKeyList(loc.expected)#" />
			<cfinvokeargument name="actual" value="#StructKeyList(loc.result)#" />
		</cfinvoke>
		<cfinvoke method="assertEquals">
			<cfinvokeargument name="expected" value="#loc.expected.foo#" />
			<cfinvokeargument name="actual" value="#loc.result.foo#" />
		</cfinvoke>
		<cfinvoke method="assertEquals">
			<cfinvokeargument name="expected" value="#loc.expected.bar#" />
			<cfinvokeargument name="actual" value="#loc.result.bar#" />
		</cfinvoke>
	</cffunction>	

	<!------------------------------------------------------
		Tests the XmlRpc.serialize() method for proper
		serialization of different types	
	------------------------------------------------------->
	<cffunction name="testSerializeXmlRpcObject" returntype="void" access="public">
		<cfset var loc = StructNew() />
		<cfset loc.binary = ToBinary("eW91IGNhbid0IHJlYWQgdGhpcyE=") />
		<cfset loc.result = variables.tempCFC.serialize(loc.binary) />
		<cfinvoke method="assertEquals">
			<cfinvokeargument name="expected" value="<value><base64>eW91IGNhbid0IHJlYWQgdGhpcyE=</base64></value>" />
			<cfinvokeargument name="actual" value="#loc.result#" />
		</cfinvoke>
	</cffunction>
	
	<cffunction name="testSerializeArray" returntype="void" access="public">
		<cfset var loc = StructNew() />
		<cfset loc.array = ArrayNew(1) />
		<cfset loc.array[1] = JavaCast("string", "Hello world!") />
		<cfset loc.array[2] = JavaCast("boolean", false) />
		<cfset loc.result = variables.tempCFC.serialize(loc.array) />
		<cfinvoke method="assertEquals">
			<cfinvokeargument name="expected" value="<value><array><data><value><string>Hello world!</string></value><value><boolean>0</boolean></value></data></array></value>" />
			<cfinvokeargument name="actual" value="#loc.result#" />
		</cfinvoke>
	</cffunction>
	
	<cffunction name="testSerializeStruct" returntype="void" access="public">
		<cfset var loc = StructNew() />
		<cfset loc.struct = StructNew() />
		<cfset loc.struct["whatToSay"] = JavaCast("string", "Hello world!") />
		<cfset loc.struct["doIt"] = JavaCast("boolean", false) />
		<cfset loc.result = variables.tempCFC.serialize(loc.struct) />
		<cfinvoke method="assertEquals">
			<cfinvokeargument name="expected" value="<value><struct><member><name>doIt</name><value><boolean>0</boolean></value></member><member><name>whatToSay</name><value><string>Hello world!</string></value></member></struct></value>" />
			<cfinvokeargument name="actual" value="#loc.result#" />
		</cfinvoke>
	</cffunction>
	
</cfcomponent>