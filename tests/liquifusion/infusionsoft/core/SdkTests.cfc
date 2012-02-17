<cfcomponent displayname="SdkTests" extends="net.sourceforge.cfunit.framework.TestCase">
	

	
	
	
	<cffunction name="TestSendEmail" returntype="void" access="public">
		<cfset var loc = StructNew() />
		<cfset loc.contactIds = ArrayNew(1) />
		<cfset loc.contactIds[1] = 33 />
		<cfset loc.contactIds[2] = 200 />
		<cfset loc.fromAddr = "me@iamjamesgibson.com" />
		<cfset loc.ccAddr = "" />
		<cfset loc.bccAddr = "" />
		<cfset loc.type = "TEXT" />
		<cfset loc.subject = "Test email" />
		<cfset loc.textBody = "Hey ya'll!" />
		<cfset loc.results = variables.tempCFC.sendEmail(loc.contactIds, loc.fromAddr, "~Contact.Email~", loc.ccAddr, loc.bccAddr, loc.type, loc.subject, "", loc.textBody) />	
		<cfinvoke method="assertEquals">
			<cfinvokeargument name="expected" value="#YesNoFormat(true)#" />
			<cfinvokeargument name="actual" value="#YesNoFormat(IsBoolean(loc.results))#" />
		</cfinvoke>
	</cffunction>
			
	<cffunction name="TestOptOut" returntype="void" access="public">
		<cfset var loc = StructNew() />
		<cfset loc.email = "james.gibson@liquifusion.com" />
		<cfset loc.results = variables.tempCFC.optOut(loc.email) />
		<cfinvoke method="assertEquals">
			<cfinvokeargument name="expected" value="#YesNoFormat(true)#" />
			<cfinvokeargument name="actual" value="#YesNoFormat(IsBoolean(loc.results))#" />
		</cfinvoke>
	</cffunction>
		
	<cffunction name="TestOptIn" returntype="void" access="public">
		<cfset var loc = StructNew() />
		<cfset loc.email = "james.gibson@liquifusion.com" />
		<cfset loc.results = variables.tempCFC.optIn(loc.email) />
		<cfinvoke method="assertEquals">
			<cfinvokeargument name="expected" value="#YesNoFormat(true)#" />
			<cfinvokeargument name="actual" value="#YesNoFormat(IsBoolean(loc.results))#" />
		</cfinvoke>
	</cffunction>
	
	<cffunction name="TestGetOptStatus" returntype="void" access="public">
		<cfset var loc = StructNew() />
		<cfset loc.email = "james.gibson@liquifusion.com" />
		<cfset loc.results = variables.tempCFC.getOptStatus(loc.email) />
		<cfinvoke method="assertEquals">
			<cfinvokeargument name="expected" value="#YesNoFormat(true)#" />
			<cfinvokeargument name="actual" value="#YesNoFormat(IsNumeric(loc.results))#" />
		</cfinvoke>
		<cfinvoke method="assertEquals">
			<cfinvokeargument name="expected" value="0" />
			<cfinvokeargument name="actual" value="#loc.results#" />
		</cfinvoke>
	</cffunction>
	
	
</cfcomponent>
