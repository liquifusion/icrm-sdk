<cfcomponent displayname="Sdk" extends="Connection" output="false" hint="I am the low level object with all of the methods to talk with the infusionsoft API.">
	
	<!--- for more information on any of the methods below
		please consult the API documentation at
		http://www.infusionsoft.com/fusebox/api/
			and
		http://www.infusionsoft.com/fusebox/api/field_access.php
	--->

	<cffunction name="init" output="false" access="public" hint="Pass in your infusionsoft subDomain and apiKey to access your infusionsoft data.">
		<cfargument name="subDomain" type="string" required="true" />
		<cfargument name="apiKey" type="string" required="false" default="" />
		<cfargument name="timeout" type="numeric" required="false" default="5" hint="The number of seconds before a request should timeout." />
	
		<cfset super.init(arguments.subDomain, arguments.apiKey) />
		<cfreturn this />
	</cffunction>
	
	
	<!----------------------------------------------------------------------------------------------------------------------------
		CONTACT SERVICE
	----------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="addContact" output="false" access="public" returntype="numeric" 
		hint="http://developers.infusionsoft.com/classes/contact/##add"
		description="Make sure to use the function JavaCast() on all values for the nameValuePairs (struct) argument. Otherwise, the XMLRPC translation will not be correct.">
		<cfargument name="data" required="true" type="struct" />
		<cfargument name="optInReason" required="false" default="" hint="The SDK automatically opts in your new contact for you. You may add a reason here." />
		<cfset var loc = StructNew() />
		
		<!--- setup the array to be sent in --->
		<cfset loc.array = ArrayNew(1) />
		<cfset ArrayAppend(loc.array, arguments.data) />
		
		<cfset loc.returnValue = this.call("ContactService.add", loc.array) />
		
		<cfif StructKeyExists(arguments.data, "Email")>
			<cfif arguments.optInReason eq "">
				<cfset this.optIn(arguments.data.Email) />
			<cfelse>
				<cfset this.optIn(arguments.data.Email, arguments.optInReason) />
			</cfif>
		</cfif>
		<cfreturn loc.returnValue />
	</cffunction>
	
	<cffunction name="updateContact" output="false" access="public" returntype="numeric" 
		hint="http://developers.infusionsoft.com/classes/contact/##update"
		description="Make sure to use the function JavaCast() on all values for the nameValuePairs (struct) argument. Otherwise, the XMLRPC translation will not be correct.">
		<cfargument name="contactId" required="true" type="numeric" />
		<cfargument name="data" required="true" type="struct" />
		<cfset var loc = StructNew() />
		<cfset loc.array = ArrayNew(1) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.contactId)) />
		<cfset ArrayAppend(loc.array, arguments.data) />
		<cfreturn this.call("ContactService.update", loc.array) />
	</cffunction>
	
	<cffunction name="findContactByEmail" output="false" access="public" returntype="any" hint="http://developers.infusionsoft.com/classes/contact/##findByEmail">
		<cfargument name="email" required="true" type="string" />
		<cfargument name="selectedFields" required="true" type="array" />
		<cfargument name="returnAs" type="string" required="false" default="Query" />
		<cfset var loc = StructNew() />
		<cfset loc.array = ArrayNew(1) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.email)) />
		<cfset ArrayAppend(loc.array, $javaCastArray(arguments.selectedFields, "string")) />
		<cfreturn $normalizeFields(fieldArray=arguments.selectedFields, data=this.call("ContactService.findByEmail", loc.array, arguments.returnAs)) />
	</cffunction>	

	<cffunction name="loadContact" output="false" access="public" returntype="struct" hint="http://developers.infusionsoft.com/classes/contact/##load">
		<cfargument name="id" required="true" type="numeric" />
		<cfargument name="selectedFields" required="true" type="array" />
		<cfset var loc = StructNew() />
		<cfset loc.array = ArrayNew(1) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.id)) />
		<cfset ArrayAppend(loc.array, $javaCastArray(arguments.selectedFields, "string")) />
		<cfreturn $normalizeStruct($normalizeFields(fieldArray=arguments.selectedFields, data=this.call("ContactService.load", loc.array))) />
	</cffunction>
	
	<cffunction name="addToCampaign" output="false" access="public" returntype="boolean" hint="http://developers.infusionsoft.com/classes/contact/##addToCampaign">
		<cfargument name="contactId" required="true" type="numeric" />
		<cfargument name="campaignId" required="true" type="numeric" />
		<cfset var loc = StructNew() />
		<cfset loc.array = ArrayNew(1) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.contactId)) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.campaignId)) />
		<cfreturn this.call("ContactService.addToCampaign", loc.array) />
	</cffunction>
	
	<cffunction name="getNextCampaignStep" output="false" access="public" returntype="numeric" hint="http://developers.infusionsoft.com/classes/contact/##getNextCampaignStep">
		<cfargument name="contactId" required="true" type="numeric" />
		<cfargument name="campaignId" required="true" type="numeric" />
		<cfset var loc = StructNew() />
		<cfset loc.array = ArrayNew(1) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.contactId)) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.campaignId)) />
		<cfreturn this.call("ContactService.getNextCampaignStep", loc.array) />
	</cffunction>
	
	<cffunction name="pauseCampaign" output="false" access="public" returntype="boolean" hint="http://developers.infusionsoft.com/classes/contact/##pauseCampaign">
		<cfargument name="contactId" required="true" type="numeric" />
		<cfargument name="campaignId" required="true" type="numeric" />
		<cfset var loc = StructNew() />
		<cfset loc.array = ArrayNew(1) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.contactId)) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.campaignId)) />
		<cfreturn this.call("ContactService.pauseCampaign", loc.array) />
	</cffunction>
	
	<cffunction name="removeFromCampaign" output="false" access="public" returntype="boolean" hint="http://developers.infusionsoft.com/classes/contact/##removeFromCampaign">
		<cfargument name="contactId" required="true" type="numeric" />
		<cfargument name="campaignId" required="true" type="numeric" />
		<cfset var loc = StructNew() />
		<cfset loc.array = ArrayNew(1) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.contactId)) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.campaignId)) />
		<cfreturn this.call("ContactService.removeFromCampaign", loc.array) />
	</cffunction>
	
	<cffunction name="resumeCampaignForContact" output="false" access="public" returntype="boolean" hint="http://developers.infusionsoft.com/classes/contact/##resumeCampaign">
		<cfargument name="contactId" required="true" type="numeric" />
		<cfargument name="campaignId" required="true" type="numeric" />
		<cfset var loc = StructNew() />
		<cfset loc.array = ArrayNew(1) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.contactId)) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.campaignId)) />
		<cfreturn this.call("ContactService.resumeCampaignForContact", loc.array) />
	</cffunction>
	
	<cffunction name="rescheduleCampaignStep" output="false" access="public" returntype="boolean" hint="http://developers.infusionsoft.com/classes/contact/##rescheduleCampaignStep">
		<cfargument name="contactIds" required="true" type="array" />
		<cfargument name="campaignStepId" required="true" type="numeric" />
		<cfset var loc = StructNew() />
		<cfset loc.array = ArrayNew(1) />
		<cfset ArrayAppend(loc.array, $javaCastArray(arguments.contactIds, "int")) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.campaignStepId)) />
		<cfreturn this.call("ContactService.rescheduleCampaignStep", loc.array) />
	</cffunction>
	
	<cffunction name="addToGroup" output="false" access="public" returntype="boolean" hint="http://developers.infusionsoft.com/classes/contact/##addToGroup">
		<cfargument name="contactId" required="true" type="numeric" />
		<cfargument name="groupId" required="true" type="numeric" />
		<cfset var loc = StructNew() />
		<cfset loc.array = ArrayNew(1) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.contactId)) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.groupId)) />
		<cfreturn this.call("ContactService.addToGroup", loc.array) />
	</cffunction>
	
	<cffunction name="removeFromGroup" output="false" access="public" returntype="boolean" hint="http://developers.infusionsoft.com/classes/contact/##removeFromGroup">
		<cfargument name="contactId" required="true" type="numeric" />
		<cfargument name="groupId" required="true" type="numeric" />
		<cfset var loc = StructNew() />
		<cfset loc.array = ArrayNew(1) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.contactId)) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.groupId)) />
		<cfreturn this.call("ContactService.removeFromGroup", loc.array) />
	</cffunction>
	
	<cffunction name="runActionSequence" output="false" access="public" returntype="array" hint="http://developers.infusionsoft.com/classes/contact/##runActionSequence">
		<cfargument name="contactId" required="true" type="numeric" />
		<cfargument name="actionSetId" required="true" type="numeric" />
		<cfset var loc = StructNew() />
		<cfset loc.array = ArrayNew(1) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.contactId)) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.actionSetId)) />
		<cfreturn this.call("ContactService.runActionSequence", loc.array) />
	</cffunction>
	
	
	<!----------------------------------------------------------------------------------------------------------------------------
		DATA SERVICE
	----------------------------------------------------------------------------------------------------------------------------->
	<cffunction name="add" output="false" access="public" returntype="numeric" 
		hint="http://developers.infusionsoft.com/classes/data/##add"
		description="Make sure to use the function JavaCast() on all values for the values (struct) argument. Otherwise, the XMLRPC translation will not be correct.">
		<cfargument name="table" required="true" type="string" />
		<cfargument name="values" required="true" type="struct" />
		<cfset var loc = StructNew() />

		<cfset loc.array = ArrayNew(1) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.table)) />
		<cfset ArrayAppend(loc.array, arguments.values) />

		<cfreturn Int(this.call("DataService.add", loc.array)) />
	</cffunction>
	
	<cffunction name="load" output="false" access="public" returntype="struct" hint="http://developers.infusionsoft.com/classes/data/##load">
		<cfargument name="table" required="true" type="string" />
		<cfargument name="id" required="true" type="numeric" />
		<cfargument name="wantedFields" required="true" type="array" />
		<cfset var loc = StructNew() />
		
		<cfset loc.array = ArrayNew(1) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.table)) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.id)) />
		<cfset ArrayAppend(loc.array, $javaCastArray(arguments.wantedFields, "string")) />
	
		<cfreturn $normalizeStruct($normalizeFields(fieldArray=arguments.wantedFields, data=this.call("DataService.load", loc.array))) />
	</cffunction>
	
	<cffunction name="update" output="false" access="public" returntype="numeric" 
		hint="http://developers.infusionsoft.com/classes/data/##update"
		description="Make sure to use the function JavaCast() on all values for the values (struct) argument. Otherwise, the XMLRPC translation will not be correct.">
		<cfargument name="table" required="true" type="string" />
		<cfargument name="id" required="true" type="numeric" />
		<cfargument name="values" required="true" type="struct" />
		<cfset var loc = StructNew() />
		
		<cfset loc.array = ArrayNew(1) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.table)) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.id)) />
		<cfset ArrayAppend(loc.array, arguments.values) />
	
		<cfreturn this.call("DataService.update", loc.array) />
	</cffunction>
	
	<!--- thanks to BUD for keeping us on our toes and finding this method that was not in the SDK --->
	<cffunction name="delete" output="false" access="public" returntype="boolean" hint="http://developers.infusionsoft.com/classes/data/##delete">
		<cfargument name="table" required="true" type="string" />
		<cfargument name="id" required="true" type="numeric" />
		<cfset var loc = StructNew() />
		<cfset loc.array = ArrayNew(1) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.table)) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.id)) />
		<cfreturn this.call("DataService.delete", loc.array) />
	</cffunction>
	
	<cffunction name="findByField" output="false" access="public" returntype="any" 
		hint="http://developers.infusionsoft.com/classes/data/##findByField"
		description="Make sure to use the function JavaCast() on all values for the fieldValue argument. Otherwise, the XMLRPC translation will not be correct.">
		<cfargument name="table" required="true" type="string" />
		<cfargument name="fieldName" required="true" type="string" />
		<cfargument name="fieldValue" required="true" type="any" />
		<cfargument name="selectedFields" required="true" type="array" />
		<cfargument name="limit" required="false" type="numeric" default="100" />
		<cfargument name="page" required="false" type="numeric" default="0" />
		<cfargument name="returnAs" required="false" type="string" default="Query" />
		<cfset var loc = StructNew() />
		
		<cfset loc.array = ArrayNew(1) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.table)) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.limit)) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.page)) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.fieldName)) />
		<cfset ArrayAppend(loc.array, arguments.fieldValue) />
		<cfset ArrayAppend(loc.array, $javaCastArray(arguments.selectedFields, "string")) />
	
		<cfreturn $normalizeFields(fieldArray=arguments.selectedFields, data=this.call("DataService.findByField", loc.array, arguments.returnAs)) />
	</cffunction>
	
	<cffunction name="query" output="false" access="public" returntype="any" 
		hint="http://developers.infusionsoft.com/classes/data/##query"
		description="Make sure to use the function JavaCast() on all values for the queryData (struct) argument. Otherwise, the XMLRPC translation will not be correct.">
		<cfargument name="table" required="true" type="string" />
		<cfargument name="selectedFields" required="true" type="array" />
		<cfargument name="queryData" required="false" type="struct" default="#StructNew()#" />
		<cfargument name="limit" required="false" type="numeric" default="100" />
		<cfargument name="page" required="false" type="numeric" default="0" />
		<cfargument name="returnAs" required="false" type="string" default="Query" />
		<cfset var loc = StructNew() />
		
		<cfset loc.array = ArrayNew(1) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.table)) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.limit)) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.page)) />
		<cfset ArrayAppend(loc.array, arguments.queryData) />
		<cfset ArrayAppend(loc.array, $javaCastArray(arguments.selectedFields, "string")) />
	
		<cfreturn $normalizeFields(fieldArray=arguments.selectedFields, data=this.call("DataService.query", loc.array, arguments.returnAs)) />
	</cffunction>
	
	<cffunction name="addCustomField" output="false" access="public" returntype="numeric" hint="http://developers.infusionsoft.com/classes/data/##addCustomField">
		<cfargument name="context" required="true" type="string" hint="Choices include: Person, Company, Affiliate, Task/Appt/Note, Order, Subscription, or Opportunity" />
		<cfargument name="displayName" required="true" type="string" />
		<cfargument name="dataType" required="true" type="string" hint="Choices include: Currency, Date, Date/Time, Day of Week, Drilldown, Email, Month, List Box, Name, Whole Number, Decimal Number, Percent, Phone Number, Radio, Dropdown, Social Security Number, State, Text, Text Area, User, User List Box, Website, Year, Yes/No" />
		<cfargument name="groupId" required="true" type="numeric" />
		<cfset var loc = StructNew() />
		
		<cfset loc.array = ArrayNew(1) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.context)) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.displayName)) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.dataType)) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.groupId)) />
	
		<cfreturn this.call("DataService.addCustomField", loc.array) />
	</cffunction>
	
	<cffunction name="authenticateUser" output="false" access="public" returntype="numeric" hint="http://developers.infusionsoft.com/classes/data/##authenticateUser">
		<cfargument name="userName" required="true" type="string" />
		<cfargument name="password" required="true" type="string" hint="Pass in the plain text password and we will hash it for you." />
		<cfset var loc = StructNew() />
		
		<!--- hash the password before we send it off --->
		<cfset arguments.password = LCase(Hash(arguments.password, "MD5")) />
		
		<cfset loc.array = ArrayNew(1) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.userName)) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.password)) />
		
		<cfreturn Int(this.call("DataService.authenticateUser", loc.array)) />
	</cffunction>

	<cffunction name="getApplicationSetting" output="false" access="public" returntype="string" hint="http://developers.infusionsoft.com/classes/data/##getAppSetting">
		<cfargument name="module" required="true" type="string" />
		<cfargument name="setting" required="true" type="string" />
		<cfset var loc = StructNew() />
		
		<cfset loc.array = ArrayNew(1) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.module)) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.setting)) />
	
		<cfreturn this.call("DataService.getAppSetting", loc.array) />
	</cffunction>
	
	<cffunction name="getTemporaryKey" output="false" access="public" returntype="string" hint="http://developers.infusionsoft.com/classes/data/##getTemporaryKey">
		<cfargument name="vendorKey" required="true" type="string" />
		<cfargument name="username" required="true" type="string" />
		<cfargument name="password" required="true" type="string" hint="Pass in the plain text password and we will hash it for you." />
		<cfset var loc = StructNew() />
		
		<!--- hash the password before we send it off --->
		<cfset arguments.password = LCase(Hash(arguments.password, "MD5")) />
	
		<cfset loc.array = ArrayNew(1) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.vendorKey)) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.username)) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.password)) />
		
		<cfreturn this.call("DataService.getTemporaryKey", loc.array, "", false) />
	</cffunction>

	<cffunction name="updateCustomField" output="false" access="public" returntype="boolean" 
		hint="http://developers.infusionsoft.com/classes/data/##updateCustomField"
		description="Make sure to use the function JavaCast() on all values for the values (struct) argument. Otherwise, the XMLRPC translation will not be correct.">
		<cfargument name="customFieldId" required="true" type="string" />
		<cfargument name="values" required="true" type="struct" />
		<cfset var loc = StructNew() />
		
		<cfset loc.array = ArrayNew(1) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.customFieldId)) />
		<cfset ArrayAppend(loc.array, arguments.values) />
	
		<cfreturn this.call("DataService.updateCustomField", loc.array) />
	</cffunction>
	
	<!----------------------------------------------------------------------------------------------------------------------------
		API AFFILIATE SERVICE
	----------------------------------------------------------------------------------------------------------------------------->

	<cffunction name="affClawbacks" output="false" access="public" returntype="query" hint="http://developers.infusionsoft.com/classes/affiliate/##affClawbacks">
		<cfargument name="affiliateId" required="true" type="date" />
		<cfargument name="filterStartDate" required="true" type="date" />
		<cfargument name="filterEndDate" required="true" type="date" />
		<cfset var loc = StructNew() />
		<cfset loc.array = ArrayNew(1) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.affiliateId)) />
		<cfset ArrayAppend(loc.array, arguments.filterStartDate) />
		<cfset ArrayAppend(loc.array, arguments.filterEndDate) />
		<cfreturn this.call("APIAffiliateService.affClawbacks", loc.array, "Query") />
	</cffunction>

	<cffunction name="affCommissions" output="false" access="public" returntype="query" hint="http://developers.infusionsoft.com/classes/affiliate/##affCommissions">
		<cfargument name="affiliateId" required="true" type="date" />
		<cfargument name="filterStartDate" required="true" type="date" />
		<cfargument name="filterEndDate" required="true" type="date" />
		<cfset var loc = StructNew() />
		<cfset loc.array = ArrayNew(1) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.affiliateId)) />
		<cfset ArrayAppend(loc.array, arguments.filterStartDate) />
		<cfset ArrayAppend(loc.array, arguments.filterEndDate) />
		<cfreturn this.call("APIAffiliateService.affCommissions", loc.array, "Query") />
	</cffunction>

	<cffunction name="affPayouts" output="false" access="public" returntype="query" hint="http://developers.infusionsoft.com/classes/affiliate/##affPayouts">
		<cfargument name="affiliateId" required="true" type="numeric" />
		<cfargument name="filterStartDate" required="true" type="date" />
		<cfargument name="filterEndDate" required="true" type="date" />
		<cfset var loc = StructNew() />
		<cfset loc.array = ArrayNew(1) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.affiliateId)) />
		<cfset ArrayAppend(loc.array, arguments.filterStartDate) />
		<cfset ArrayAppend(loc.array, arguments.filterEndDate) />
		<cfreturn this.call("APIAffiliateService.affPayouts", loc.array, "Query") />
	</cffunction>

	<cffunction name="affRunningTotals" output="false" access="public" returntype="query" hint="http://developers.infusionsoft.com/classes/affiliate/##affRunningTotals">
		<cfargument name="affiliateIds" required="true" type="array" />
		<cfset var loc = StructNew() />
		<cfset loc.array = ArrayNew(1) />
		<cfset ArrayAppend(loc.array, $javaCastArray(arguments.affiliateIds, "int")) />
		<cfreturn this.call("APIAffiliateService.affRunningTotals", loc.array, "Query") />
	</cffunction>

	<cffunction name="affSummary" output="false" access="public" returntype="query" hint="http://developers.infusionsoft.com/classes/affiliate/##affSummary">
		<cfargument name="affiliateIds" required="true" type="array" />
		<cfargument name="filterStartDate" required="true" type="date" />
		<cfargument name="filterEndDate" required="true" type="date" />
		<cfset var loc = StructNew() />
		<cfset loc.array = ArrayNew(1) />
		<cfset ArrayAppend(loc.array, $javaCastArray(arguments.affiliateIds, "int")) />
		<cfset ArrayAppend(loc.array, arguments.filterStartDate) />
		<cfset ArrayAppend(loc.array, arguments.filterEndDate) />
		<cfreturn this.call("APIAffiliateService.affSummary", loc.array, "Query") />
	</cffunction>
	
	<!----------------------------------------------------------------------------------------------------------------------------
		INVOICE SERVICE
	----------------------------------------------------------------------------------------------------------------------------->
	
	<cffunction name="createBlankOrder" output="false" access="public" returntype="numeric" hint="http://developers.infusionsoft.com/classes/invoice/##createBlankOrder">
		<cfargument name="contactId" required="true" type="numeric" />
		<cfargument name="description" required="true" type="string" />
		<cfargument name="orderDate" required="true" type="date" />
		<cfargument name="leadAffiliateId" required="true" type="numeric" />
		<cfargument name="saleAffiliateId" required="true" type="numeric" />
		<cfset var loc = StructNew() />
		
		<cfset loc.array = ArrayNew(1) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.contactId)) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.description)) />
		<cfset ArrayAppend(loc.array, arguments.orderDate) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.leadAffiliateId)) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.saleAffiliateId)) />
	
		<cfreturn Int(this.call("InvoiceService.createBlankOrder", loc.array)) />
	</cffunction>
	
	<cffunction name="addOrderItem" output="false" access="public" returntype="boolean" hint="http://developers.infusionsoft.com/classes/invoice/##addOrderItem">
		<cfargument name="invoiceId" required="true" type="numeric" />
		<cfargument name="productId" required="true" type="numeric" />
		<cfargument name="type" required="true" type="numeric" />
		<cfargument name="price" required="true" type="numeric" />
		<cfargument name="quantity" required="true" type="numeric" />
		<cfargument name="description" required="true" type="string" />
		<cfargument name="notes" required="true" type="string" />
		<cfset var loc = StructNew() />
		
		<cfset loc.array = ArrayNew(1) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.invoiceId)) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.productId)) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.type)) />
		<cfset ArrayAppend(loc.array, JavaCast("double", arguments.price)) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.quantity)) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.description)) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.notes)) />
	
		<cfreturn this.call("InvoiceService.addOrderItem", loc.array) />
	</cffunction>
	
	<cffunction name="chargeInvoice" output="false" access="public" returntype="struct" hint="http://developers.infusionsoft.com/classes/invoice/##chargeInvoice">
		<cfargument name="invoiceId" required="true" type="numeric" />
		<cfargument name="notes" required="true" type="string" />
		<cfargument name="creditCardId" required="true" type="numeric" />
		<cfargument name="merchantAccountId" required="true" type="numeric" />
		<cfargument name="bypassCommissions" required="true" type="boolean" />
		<cfset var loc = StructNew() />
		
		<cfset loc.array = ArrayNew(1) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.invoiceId)) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.notes)) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.creditCardId)) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.merchantAccountId)) />
		<cfset ArrayAppend(loc.array, JavaCast("boolean", arguments.bypassCommissions)) />
		
		<cfreturn $normalizeStruct(this.call("InvoiceService.chargeInvoice", loc.array)) />
	</cffunction>
	
	<cffunction name="deleteInvoice" output="false" access="public" returntype="boolean" hint="http://developers.infusionsoft.com/classes/invoice/##deleteInvoice">
		<cfargument name="invoiceId" required="true" type="numeric" />
		<cfset var loc = StructNew() />
		<cfset loc.array = ArrayNew(1) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.invoiceId)) />
		<cfreturn this.call("InvoiceService.deleteInvoice", loc.array) />
	</cffunction>
	
	<cffunction name="deleteSubscription" output="false" access="public" returntype="boolean" hint="http://developers.infusionsoft.com/classes/invoice/##deleteSubscription">
		<cfargument name="id" required="true" type="numeric" />
		<cfset var loc = StructNew() />
		<cfset loc.array = ArrayNew(1) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.id)) />
		<cfreturn this.call("InvoiceService.deleteSubscription", loc.array) />
	</cffunction>
	
	<cffunction name="addRecurringOrder" output="false" access="public" returntype="numeric" hint="http://developers.infusionsoft.com/classes/invoice/##addRecurringOrder">
		<cfargument name="contactId" required="true" type="numeric" />
		<cfargument name="allowDuplicate" required="true" type="boolean" />
		<cfargument name="cProgramId" required="true" type="numeric" />
		<cfargument name="price" required="true" type="numeric" />
		<cfargument name="merchantAccountId" required="true" type="numeric" />
		<cfargument name="creditCardId" required="true" type="numeric" />
		<cfargument name="affiliateId" required="true" type="numeric" />
		<cfargument name="daysTillCharge" required="true" type="numeric" />
		<cfargument name="qty" required="false" type="numeric" default="1" />
		<cfargument name="allowTax" required="false" type="boolean" default="false" />
		<cfset var loc = StructNew() />
		<cfset loc.array = ArrayNew(1) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.contactId)) />
		<cfset ArrayAppend(loc.array, JavaCast("boolean", arguments.allowDuplicate)) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.cProgramId)) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.qty)) />
		<cfset ArrayAppend(loc.array, JavaCast("double", arguments.price)) />
		<cfset ArrayAppend(loc.array, JavaCast("boolean", arguments.allowTax)) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.merchantAccountId)) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.creditCardId)) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.affiliateId)) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.daysTillCharge)) />
		<cfreturn this.call("InvoiceService.addRecurringOrder", loc.array) />
	</cffunction>
	
	<cffunction name="addRecurringCommissionOverride" output="false" access="public" returntype="boolean" hint="http://developers.infusionsoft.com/classes/invoice/##addRecurringCommissionOverride">
		<cfargument name="recurringOrderId" required="true" type="numeric" />
		<cfargument name="affiliateId" required="true" type="numeric" />
		<cfargument name="amount" required="true" type="numeric" />
		<cfargument name="payoutType" required="true" type="numeric" />
		<cfargument name="description" required="true" type="string" />
		<cfset var loc = StructNew() />
		<cfset loc.array = ArrayNew(1) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.recurringOrderId)) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.affiliateId)) />
		<cfset ArrayAppend(loc.array, JavaCast("double", arguments.amount)) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.payoutType)) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.description)) />
		<cfreturn this.call("InvoiceService.addRecurringCommissionOverride", loc.array) />
	</cffunction>
	
	<cffunction name="createInvoiceForRecurring" output="false" access="public" returntype="numeric" hint="http://developers.infusionsoft.com/classes/invoice/##createInvoiceForRecurring">
		<cfargument name="recurringOrderId" required="true" type="numeric" />
		<cfset var loc = StructNew() />
		<cfset loc.array = ArrayNew(1) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.recurringOrderId)) />
		<cfreturn this.call("InvoiceService.createInvoiceForRecurring", loc.array) />
	</cffunction>
	
	<cffunction name="updateJobRecurringNextBillDate" output="false" access="public" returntype="boolean" hint="http://developers.infusionsoft.com/classes/invoice/##updateJobRecurringNextBillDate">
		<cfargument name="jobRecurringId" required="true" type="numeric" />
		<cfargument name="newNextBillDate" required="true" type="date" />
		<cfset var loc = StructNew() />
		<cfset loc.array = ArrayNew(1) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.jobRecurringId)) />
		<cfset ArrayAppend(loc.array, arguments.newNextBillDate) />
		<cfreturn this.call("InvoiceService.updateJobRecurringNextBillDate", loc.array) />
	</cffunction>
	
	<cffunction name="addManualPayment" output="false" access="public" returntype="boolean" hint="http://developers.infusionsoft.com/classes/invoice/##addManualPayment">
		<cfargument name="invoiceId" required="true" type="numeric" />
		<cfargument name="amt" required="true" type="numeric" />
		<cfargument name="paymentDate" required="true" type="date" />
		<cfargument name="paymentType" required="true" type="string" />
		<cfargument name="paymentDescription" required="true" type="string" />
		<cfargument name="bypassCommissions" required="true" type="boolean" />
		<cfset var loc = StructNew() />
		
		<cfset loc.array = ArrayNew(1) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.invoiceId)) />
		<cfset ArrayAppend(loc.array, JavaCast("double", arguments.amt)) />
		<cfset ArrayAppend(loc.array, arguments.paymentDate) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.paymentType)) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.paymentDescription)) />
		<cfset ArrayAppend(loc.array, JavaCast("boolean", arguments.bypassCommissions)) />
	
		<cfreturn this.call("InvoiceService.addManualPayment", loc.array) />
	</cffunction>
	
	<cffunction name="addPaymentPlan" output="false" access="public" returntype="boolean" hint="http://developers.infusionsoft.com/classes/invoice/##addPaymentPlan">
		<cfargument name="invoiceId" required="true" type="numeric" />
		<cfargument name="autoCharge" required="true" type="boolean" />
		<cfargument name="creditCardId" required="true" type="numeric" />
		<cfargument name="merchantAccountId" required="true" type="numeric" />
		<cfargument name="daysBetweenRetry" required="true" type="numeric" />
		<cfargument name="maxRetry" required="true" type="numeric" />
		<cfargument name="initialPmtAmt" required="true" type="numeric" />
		<cfargument name="initialPmtDate" required="true" type="date" />
		<cfargument name="planStartDate" required="true" type="date" />
		<cfargument name="numPmts" required="true" type="numeric" />
		<cfargument name="daysBetweenPmts" required="true" type="numeric" />
		<cfset var loc = StructNew() />
		
		<cfset loc.array = ArrayNew(1) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.invoiceId)) />
		<cfset ArrayAppend(loc.array, JavaCast("boolean", arguments.autoCharge)) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.creditCardId)) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.merchantAccountId)) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.daysBetweenRetry)) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.maxRetry)) />
		<cfset ArrayAppend(loc.array, JavaCast("double", arguments.initialPmtAmt)) />
		<cfset ArrayAppend(loc.array, arguments.initialPmtDate) />
		<cfset ArrayAppend(loc.array, arguments.planStartDate) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.numPmts)) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.daysBetweenPmts)) />
	
		<cfreturn this.call("InvoiceService.addPaymentPlan", loc.array) />
	</cffunction>
	
	<cffunction name="calculateAmountOwed" output="false" access="public" returntype="numeric" hint="http://developers.infusionsoft.com/classes/invoice/##calculateAmountOwed">
		<cfargument name="invoiceId" required="true" type="numeric" />
		<cfset var loc = StructNew() />
		<cfset loc.array = ArrayNew(1) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.invoiceId)) />
		<cfreturn this.call("InvoiceService.calculateAmountOwed", loc.array) />
	</cffunction>
	
	<cffunction name="getAllPaymentOptions" output="false" access="public" returntype="struct" hint="http://www.infusionsoft.com/fusebox/api/InvoiceService.html##getAllPaymentOptions(java.lang.String)">
		<cfset var loc = StructNew() />
		<cfset loc.array = ArrayNew(1) />
		<cfreturn $normalizeStruct(this.call("InvoiceService.getAllPaymentOptions", loc.array)) />
	</cffunction>
	
	<cffunction name="getPayments" output="false" access="public" returntype="query" hint="http://developers.infusionsoft.com/classes/invoice/##getPayments">
		<cfargument name="invoiceId" required="true" type="numeric" />
		<cfset var loc = StructNew() />
		<cfset loc.array = ArrayNew(1) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.invoiceId)) />
		<cfreturn this.call("InvoiceService.getPayments", loc.array, "Query") />
	</cffunction>
	
	<cffunction name="locateExistingCard" output="false" access="public" returntype="numeric" hint="http://developers.infusionsoft.com/classes/invoice/##locateExistingCard">
		<cfargument name="contactId" required="true" type="numeric" />
		<cfargument name="last4" required="true" type="numeric" />
		<cfset var loc = StructNew() />
		<cfset loc.array = ArrayNew(1) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.contactId)) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.last4)) />
		<cfreturn this.call("InvoiceService.locateExistingCard", loc.array) />
	</cffunction>
	
	<cffunction name="recalculateTax" output="false" access="public" returntype="boolean" hint="http://developers.infusionsoft.com/classes/invoice/##recalculateTax">
		<cfargument name="invoiceId" required="true" type="numeric" />
		<cfset var loc = StructNew() />
		<cfset loc.array = ArrayNew(1) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.invoiceId)) />
		<cfreturn this.call("InvoiceService.recalculateTax", loc.array) />
	</cffunction>

	<cffunction name="validateCreditCard" output="false" access="public" returntype="struct" hint="http://developers.infusionsoft.com/classes/invoice/##validateCreditCard">
		<cfargument name="creditCardId" required="true" type="numeric" />
		<cfset var loc = StructNew() />
		<cfset loc.array = ArrayNew(1) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.creditCardId)) />
		<cfreturn $normalizeStruct(this.call("InvoiceService.validateCreditCard", loc.array)) />
	</cffunction>
	
	<cffunction name="validateCreditCardDetails" output="false" access="public" returntype="struct" hint="http://www.infusionsoft.com/fusebox/api/InvoiceService.html##validateCreditCard(java.lang.String, java.util.Map)">
		<cfargument name="creditCardDetails" required="true" type="struct" />
		<cfset var loc = StructNew() />
		<!---
			need to cast all of the items in the struct, 
			per http://developers.infusionsoft.com/table-creditcard/
			all items are string except for ContactId
		--->
		<cfset loc.structItem = "" />
		<cfset loc.structItemInts = "ContactId" />
		<cfloop collection="#arguments.creditCardDetails#" item="loc.structItem">
			<cfif ListFind(loc.structItemInts, loc.structItem)>
				<cfset arguments.creditCardDetails[loc.structItem] = JavaCast("int", arguments.creditCardDetails[loc.structItem]) />
			<cfelse>
				<cfset arguments.creditCardDetails[loc.structItem] = JavaCast("string", arguments.creditCardDetails[loc.structItem]) />
			</cfif>
		</cfloop>
		<cfset loc.array = ArrayNew(1) />
		<cfset ArrayAppend(loc.array, arguments.creditCardDetails) />
		<cfreturn $normalizeStruct(this.call("InvoiceService.validateCreditCard", loc.array)) />
	</cffunction>
	
	<cffunction name="getAllShippingOptions" output="false" access="public" returntype="struct" hint="http://developers.infusionsoft.com/classes/invoice/##getAllShippingOptions">
		<cfset var loc = StructNew() />
		<cfset loc.array = ArrayNew(1) />
		<cfreturn $normalizeStruct(this.call("InvoiceService.getAllShippingOptions", loc.array)) />
	</cffunction>
	
	<cffunction name="getPluginStatus" output="false" access="public" returntype="boolean" hint="http://developers.infusionsoft.com/classes/invoice/##getPluginStatus">
		<cfargument name="fullyQualifiedClassName" required="true" type="string" />
		<cfset var loc = StructNew() />
		<cfset loc.array = ArrayNew(1) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.fullyQualifiedClassName)) />
		<cfreturn this.call("InvoiceService.getPluginStatus", loc.array) />
	</cffunction>
	
	<!----------------------------------------------------------------------------------------------------------------------------
		API EMAIL SERVICE
	----------------------------------------------------------------------------------------------------------------------------->

	<!--- thanks to BUD for keeping us on our toes and finding this method that was not in the SDK --->
	<cffunction name="addEmailTemplate" output="false" access="public" returntype="numeric" hint="http://developers.infusionsoft.com/classes/email/##addEmailTemplate">
		<cfargument name="pieceTitle" required="false" type="string" />
		<cfargument name="categories" required="false" type="string" />
		<cfargument name="fromAddress" required="false" type="string" />
		<cfargument name="toAddress" required="false" type="string" />
		<cfargument name="ccAddresses" required="false" type="string" />
		<cfargument name="bccAddresses" required="false" type="string" />
		<cfargument name="subject" required="false" type="string" />
		<cfargument name="textBody" required="false" type="string" />
		<cfargument name="htmlBody" required="false" type="string" />
		<cfargument name="contentType" required="false" type="string" hint="HTML, text or multipart" />
		<cfargument name="mergeContext" required="false" type="string" hint="mergeContact Choices: Contact, ServiceCall, Opportunity or CreditCard" />
		<cfset var loc = StructNew() />
		<cfset loc.array = ArrayNew(1) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.pieceTitle)) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.categories)) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.fromAddress)) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.toAddress)) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.ccAddresses)) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.bccAddresses)) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.subject)) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.textBody)) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.htmlBody)) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.contentType)) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.mergeContext)) />
		<cfreturn this.call("APIEmailService.addEmailTemplate", loc.array) />
	</cffunction>

	<cffunction name="attachEmail" output="false" access="public" returntype="boolean" hint="http://developers.infusionsoft.com/classes/email/##attachEmail">
		<cfargument name="contactId" required="true" type="numeric" />
		<cfargument name="fromName" required="true" type="string" />
		<cfargument name="fromAddress" required="true" type="string" />
		<cfargument name="toAddress" required="true" type="string" />
		<cfargument name="ccAddresses" required="true" type="string" />
		<cfargument name="bccAddresses" required="true" type="string" />
		<cfargument name="contentType" required="true" type="string" hint="HTML, text, or multipart" />
		<cfargument name="subject" required="true" type="string" />
		<cfargument name="htmlBody" required="true" type="string" />
		<cfargument name="textBody" required="true" type="string" />
		<cfargument name="header" required="true" type="string" />
		<cfargument name="receivedDate" required="true" type="date" />
		<cfargument name="sentDate" required="true" type="date" />
		<cfargument name="emailSentType" required="true" type="numeric" hint="1 = sent, 0 = received" />
		<cfset var loc = StructNew() />
		<cfset loc.array = ArrayNew(1) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.contactId)) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.fromName)) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.fromAddress)) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.toAddress)) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.ccAddresses)) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.bccAddresses)) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.contentType)) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.subject)) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.htmlBody)) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.textBody)) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.header)) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.receivedDate)) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.sentDate)) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.emailSentType)) />
		<cfreturn this.call("APIEmailService.attachEmail", loc.array) />
	</cffunction>
	
	<cffunction name="getAvailableMergeFields" output="false" access="public" returntype="array" hint="http://developers.infusionsoft.com/classes/email/##getAvailableMergeFields">
		<cfargument name="mergeContext" required="true" type="string" hint="Contact, Opportunity, Invoice, or CreditCard" />
		<cfset var loc = StructNew() />
		<cfset loc.array = ArrayNew(1) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.mergeContext)) />
		<cfreturn this.call("InvoiceService.getAvailableMergeFields", loc.array) />
	</cffunction>

	<!--- thanks to BUD for keeping us on our toes and finding this method that was not in the SDK --->
	<cffunction name="getEmailTemplate" output="false" access="public" returntype="struct" hint="http://developers.infusionsoft.com/classes/email/##getEmailTemplate">
		<cfargument name="templateId" required="true" type="numeric" />
		<cfset loc.array = ArrayNew(1) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.templateId)) />
		<cfreturn $normalizeStruct(this.call("APIEmailService.getEmailTemplate", loc.array)) />
	</cffunction>

	<cffunction name="getOptStatus" output="false" access="public" returntype="numeric" hint="http://developers.infusionsoft.com/classes/email/##getOptStatus">
		<cfargument name="email" required="true" type="string" />
		<cfset var loc = StructNew() />
		<cfset loc.array = ArrayNew(1) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.email)) />
		<cfreturn this.call("APIEmailService.getOptStatus", loc.array) />
	</cffunction>

	<cffunction name="optIn" output="false" access="public" returntype="boolean" hint="http://developers.infusionsoft.com/classes/email/##optIn">
		<cfargument name="email" required="true" type="string" />
		<cfargument name="permissionReason" required="false" type="string" default="" />
		<cfset var loc = StructNew() />
		<cfset loc.array = ArrayNew(1) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.email)) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.permissionReason)) />
		<cfreturn this.call("APIEmailService.optIn", loc.array) />
	</cffunction>

	<cffunction name="optOut" output="false" access="public" returntype="boolean" hint="http://developers.infusionsoft.com/classes/email/##optOut">
		<cfargument name="email" required="true" type="string" />
		<cfargument name="optOutReason" required="false" type="string" default="" />
		<cfset var loc = StructNew() />
		<cfset loc.array = ArrayNew(1) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.email)) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.optOutReason)) />
		<cfreturn this.call("APIEmailService.optOut", loc.array) />
	</cffunction>

	<!--- thanks to BUD for keeping us on our toes and finding this method that was not in the SDK --->
	<cffunction name="sendEmail" output="false" access="public" returntype="boolean" hint="http://developers.infusionsoft.com/classes/email/##sendEmail">
		<cfargument name="contactList" required="true" type="array" />
		<cfargument name="fromAddress" required="true" type="string" />
		<cfargument name="toAddress" required="true" type="string" />
		<cfargument name="ccAddresses" required="true" type="string" />
		<cfargument name="bccAddresses" required="true" type="string" />
		<cfargument name="contentType" required="true" type="string" hint="HTML, text, or multipart" />
		<cfargument name="subject" required="true" type="string" />
		<cfargument name="htmlBody" required="true" type="string" />
		<cfargument name="textBody" required="true" type="string" />
		<cfset var loc = StructNew() />
		<cfset loc.array = ArrayNew(1) />
		<cfset ArrayAppend(loc.array, $javaCastArray(arguments.contactList, "int")) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.fromAddress)) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.toAddress)) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.ccAddresses)) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.bccAddresses)) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.contentType)) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.subject)) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.htmlBody)) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.textBody)) />
		<cfreturn this.call("APIEmailService.sendEmail", loc.array) />
	</cffunction>
	
	<!--- thanks to BUD for keeping us on our toes and finding this method that was not in the SDK --->
	<cffunction name="sendEmailTemplate" output="false" access="public" returntype="boolean" hint="http://www.infusionsoft.com/fusebox/api/APIEmailService.html##sendEmail(java.lang.String, java.util.List, int)">
		<cfargument name="contactList" required="true" type="array" />
		<cfargument name="templateId" required="true" type="numeric" />
		<cfset var loc = StructNew() />
		<cfset loc.array = ArrayNew(1) />
		<cfset ArrayAppend(loc.array, $javaCastArray(arguments.contactList, "int")) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.templateId)) />
		<cfreturn this.call("APIEmailService.sendEmail", loc.array) />
	</cffunction>
	
	<!--- thanks to BUD for keeping us on our toes and finding this method that was not in the SDK --->
	<cffunction name="updateEmailTemplate" output="false" access="public" returntype="boolean" hint="http://developers.infusionsoft.com/classes/email/##updateEmailTemplate">
		<cfargument name="templateId" required="true" type="numeric" />
		<cfargument name="pieceTitle" required="false" type="string" />
		<cfargument name="categories" required="false" type="string" />
		<cfargument name="fromAddress" required="false" type="string" />
		<cfargument name="toAddress" required="false" type="string" />
		<cfargument name="ccAddresses" required="false" type="string" />
		<cfargument name="bccAddresses" required="false" type="string" />
		<cfargument name="subject" required="false" type="string" />
		<cfargument name="textBody" required="false" type="string" />
		<cfargument name="htmlBody" required="false" type="string" />
		<cfargument name="contentType" required="false" type="string" />
		<cfargument name="mergeContext" required="false" type="string" />
		<cfset var loc = StructNew() />
		<cfset loc.array = ArrayNew(1) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.templateId)) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.pieceTitle)) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.categories)) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.fromAddress)) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.toAddress)) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.ccAddresses)) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.bccAddresses)) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.subject)) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.textBody)) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.htmlBody)) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.contentType)) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.mergeContext)) />
		<cfreturn this.call("APIEmailService.updateEmailTemplate", loc.array) />
	</cffunction>
	
	<!----------------------------------------------------------------------------------------------------------------------------
		TICKET SERVICE
	----------------------------------------------------------------------------------------------------------------------------->

	<cffunction name="addMoveNotes" output="false" access="public" returntype="boolean" hint="http://www.infusionsoft.com/fusebox/api/ServiceCallService.html##addMoveNotes(java.lang.String, java.lang.String[], java.lang.String, int, java.lang.String[])">
		<cfargument name="ticketIds" required="true" type="array" />
		<cfargument name="moveNotes" required="true" type="string" />
		<cfargument name="moveToStageId" required="true" type="numeric" />
		<cfargument name="notifyIds" required="true" type="array" />
		<cfset var loc = StructNew() />
		
		<cfset loc.array = ArrayNew(1) />
		<cfset ArrayAppend(loc.array, $javaCastArray(arguments.ticketIds, "string")) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.moveNotes)) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.moveToStageId)) />
		<cfset ArrayAppend(loc.array, $javaCastArray(arguments.notifyIds, "string")) />
	
		<cfreturn this.call("ServiceCallService.addMoveNotes", loc.array) />
	</cffunction>

	<cffunction name="moveTicketStage" output="false" access="public" returntype="boolean" hint="http://www.infusionsoft.com/fusebox/api/ServiceCallService.html##moveTicketStage(java.lang.String, int, int, java.lang.String, java.lang.String[])">
		<cfargument name="ticketId" required="true" type="numeric" />
		<cfargument name="ticketStage" required="true" type="numeric" />
		<cfargument name="moveNotes" required="true" type="string" />
		<cfargument name="notifyIds" required="true" type="array" />
		<cfset var loc = StructNew() />
		
		<cfset loc.array = ArrayNew(1) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.ticketId)) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.ticketStage)) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.moveNotes)) />
		<cfset ArrayAppend(loc.array, $javaCastArray(arguments.notifyIds, "string")) />
	
		<cfreturn this.call("ServiceCallService.moveTicketStage", loc.array) />
	</cffunction>

	<cffunction name="reportIssue" output="false" access="public" returntype="numeric" hint="http://www.infusionsoft.com/fusebox/api/ServiceCallService.html##reportIssue(java.lang.String, java.lang.String, int, java.lang.String, java.lang.String, java.lang.String, java.lang.String, java.lang.String, java.lang.String)">
		<cfargument name="type" required="true" type="string" />
		<cfargument name="userId" required="true" type="numeric" />
		<cfargument name="title" required="true" type="string" />
		<cfargument name="activity" required="true" type="string" />
		<cfargument name="desiredOutcome" required="true" type="string" />
		<cfargument name="actualOutcome" required="true" type="string" />
		<cfargument name="stackTrace" required="true" type="string" />
		<cfargument name="clickSteps" required="true" type="string" />
		<cfset var loc = StructNew() />
		
		<cfset loc.array = ArrayNew(1) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.type)) />
		<cfset ArrayAppend(loc.array, JavaCast("int", arguments.userId)) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.title)) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.activity)) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.desiredOutcome)) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.actualOutcome)) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.stackTrace)) />
		<cfset ArrayAppend(loc.array, JavaCast("string", arguments.clickSteps)) />
	
		<cfreturn this.call("ServiceCallService.reportIssue", loc.array) />
	</cffunction>
	
	<!----------------------------------------------------------------------------------------------------------------------------
		API SEARCH SERVICE - http://help.infusionsoft.com/api-docs/searchservice
	----------------------------------------------------------------------------------------------------------------------------->

	<cffunction name="getAllReportColumns" output="false" access="public" returntype="query" hint="http://www.infusionsoft.com/fusebox/api/SearchService.html##getAllReportColumns(java.lang.String, int, int)">
		<cfargument name="savedSearchId" required="true" type="numeric" />
		<cfargument name="userId" required="true" type="numeric" />
		<cfset var loc = StructNew() />
		
		<cfset loc.array = ArrayNew(1) />
		<cfset ArrayAppend(loc.array, JavaCast('int', arguments.savedSearchId)) />
		<cfset ArrayAppend(loc.array, JavaCast('int', arguments.UserId)) />
	
		<cfreturn this.call("SearchService.getAllReportColumns", loc.array, "Query") />
	</cffunction>

	<cffunction name="getSavedSearchResultsAllFields" output="false" access="public" returntype="query" hint="http://www.infusionsoft.com/fusebox/api/SearchService.html##getSavedSearchResultsAllFields(java.lang.String, int, int, int)">
		<cfargument name="savedSearchId" required="true" type="numeric" />
		<cfargument name="userId" required="true" type="numeric" />
		<cfargument name="pageNumber" required="true" type="numeric" />
		<cfset var loc = StructNew() />
		
		<cfset loc.array = ArrayNew(1) />
		<cfset ArrayAppend(loc.array, JavaCast('int', arguments.savedSearchId)) />
		<cfset ArrayAppend(loc.array, JavaCast('int', arguments.UserId)) />
		<cfset ArrayAppend(loc.array, JavaCast('int', arguments.pageNumber)) />
	
		<cfreturn this.call("SearchService.getSavedSearchResultsAllFields", loc.array, "Query") />
	</cffunction>
	
	<cffunction name="getAvailableQuickSearches" output="false" access="public" returntype="query" hint="http://www.infusionsoft.com/fusebox/api/SearchService.html##getAvailableQuickSearches(java.lang.String, int)">
		<cfargument name="userId" required="true" type="numeric" />
		<cfset var loc = StructNew() />
		
		<cfset loc.array = ArrayNew(1) />
		<cfset ArrayAppend(loc.array, JavaCast('int', arguments.UserId)) />
	
		<cfreturn this.call("SearchService.getAvailableQuickSearches", loc.array, "Query") />
	</cffunction>
	
	<cffunction name="quickSearch" output="false" access="public" returntype="query" hint="http://www.infusionsoft.com/fusebox/api/SearchService.html##quickSearch(java.lang.String, java.lang.String, int, java.lang.String, int, int)">
		<cfargument name="quickSearchType" required="true" type="string">
		<cfargument name="userId" required="true" type="numeric" />
		<cfargument name="searchData" required="true" type="string">
		<cfargument name="page" required="true" type="numeric" />
		<cfargument name="returnLimit" required="true" type="numeric" />
		<cfset var loc = StructNew() />
		
		<cfset loc.array = ArrayNew(1) />
		<cfset ArrayAppend(loc.array, JavaCast('string', arguments.quickSearchType)) />
		<cfset ArrayAppend(loc.array, JavaCast('int', arguments.UserId)) />
		<cfset ArrayAppend(loc.array, JavaCast('string', arguments.searchData)) />
		<cfset ArrayAppend(loc.array, JavaCast('int', arguments.page)) />
		<cfset ArrayAppend(loc.array, JavaCast('int', arguments.returnLimit)) />
		
		<cfreturn this.call("SearchService.quickSearch", loc.array, "Query") />
	</cffunction>
	
	<cffunction name="getDefaultQuickSearch" output="false" access="public" returntype="query" hint="http://www.infusionsoft.com/fusebox/api/SearchService.html##getDefaultQuickSearch(java.lang.String, int)">
		<cfargument name="userId" required="true" type="numeric" />
		<cfset var loc = StructNew() />
		
		<cfset loc.array = ArrayNew(1) />
		<cfset ArrayAppend(loc.array, JavaCast('int', arguments.UserId)) />
	
		<cfreturn this.call("SearchService.getDefaultQuickSearch", loc.array, "Query") />
	</cffunction>
	
	<!----------------------------------------------------------------------------------------------------------------------------
		PRIVATE METHODS
	----------------------------------------------------------------------------------------------------------------------------->
	
	<cffunction name="$javaCastArray" access="private" output="false" returntype="array" hint="Private method of the SDK object.">
		<cfargument name="array" required="true" type="array" />
		<cfargument name="type" required="true" type="string" />
		<cfscript>
			var loc = StructNew();
			loc.returnArray = ArrayNew(1);
			
			// loop through array and cast each element to the type specified
			loc.end = ArrayLen(arguments.array);
			loc.i = 1;
			
			for (loc.i; loc.i lte loc.end; loc.i = loc.i + 1)
				loc.returnArray[loc.i] = JavaCast(arguments.type, arguments.array[loc.i]);
		</cfscript>
		<cfreturn loc.returnArray />
	</cffunction>
	
	<cffunction name="$normalizeStruct" access="private" returntype="struct" output="false">
		<cfargument name="struct" type="struct" required="true" />
		<cfscript>
			var loc = StructNew();
			loc.returnValue = StructNew();
			loc.keyList = StructKeyList(arguments.struct);
			
			for (loc.i = 1; loc.i lte ListLen(loc.keyList); loc.i = loc.i + 1)
				loc.returnValue[ListGetAt(loc.keyList, loc.i)] = arguments.struct[ListGetAt(loc.keyList, loc.i)];
		</cfscript>
		<cfreturn loc.returnValue />
	</cffunction>

	<cffunction name="$normalizeFields" access="private" returntype="any" output="false" hint="Private method of the SDK object.">
		<cfargument name="fieldArray" type="array" required="true" />
		<cfargument name="data" type="any" required="true" />
		<cfscript>
			var loc = { returnStruct = false, fLen = ArrayLen(arguments.fieldArray) };
			
			if (IsStruct(arguments.data))
			{
				loc.returnStruct = true;
				arguments.array = [ arguments.data ];
				arguments.data = arguments.array;
				StructDelete(arguments, "array");
			}
			
			if (IsArray(arguments.data))
			{
				// loop through the array
				loc.iEnd = ArrayLen(arguments.data);
				for (loc.i = 1; loc.i lte loc.iEnd; loc.i++)
					if (IsStruct(arguments.data[loc.i]))
						for (loc.f = 1; loc.f lte loc.fLen; loc.f++)
							if (!StructKeyExists(arguments.data[loc.i], arguments.fieldArray[loc.f]))
								arguments.data[loc.i][arguments.fieldArray[loc.f]] = ""; // set it to an empty string
			}
			else if (IsQuery(arguments.data))
			{
				arguments.fieldArray = ListToArray(Replace(ArrayToList(arguments.fieldArray), "_", "Custom_", "all"));
				// loop through the fields and add the columns if they are not there
				for (loc.f = 1; loc.f lte loc.fLen; loc.f++)
					if (!StructKeyExists(arguments.data, arguments.fieldArray[loc.f]))
						QueryAddColumn(arguments.data, arguments.fieldArray[loc.f], ArrayNew(1));
			}
			
			if (loc.returnStruct)
				return arguments.data[1];
		</cfscript>
		<cfreturn arguments.data />
	</cffunction>
	
</cfcomponent>
