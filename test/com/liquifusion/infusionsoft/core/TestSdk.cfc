<cfcomponent extends="com.rocketboots.rocketunit.Test">

	<cfset variables.CLASS_NAME = "com.liquifusion.infusionsoft.core.Sdk" />
	<cfset variables.GROUP_ID = 113 />
	<cfset variables.CAMPAIGN_ID = 40 />
	<cfset variables.FORM_GROUP_ID = 10 />
	<cfset variables.ACTION_SET_ID = 63 />
	<cfset variables.CAMPAIGN_STEP_ID = 170 />
	<cfset variables.USERNAME = "jgibson" />
	<cfset variables.PASSWORD = "Nb6hZ@sc" />
	<cfset variables.VENDORKEY = "7cc5c1da37e0d2fffd111a9cebc70505" />
	<cfset variables.PRODUCT_ID = 16 />
	<cfset variables.MERCHANTACCOUNT_ID = 2 />
	<cfset variables.CPROGRAM_ID = 58 />
	<cfset variables.AFFILIATE_ID = 3 />
	
	<cfset variables.loc = StructNew() />

	<cffunction name="setup" access="public" output="false" returntype="void">
		<cfset variables.instance = createObject("component", variables.CLASS_NAME).init("reservoir", "56ce2c432858551fa622e751a8828cc4") />
	</cffunction>

	<cffunction name="teardown" access="public" output="false" returntype="void">
		<cfscript>
			StructDelete(variables, "instance");
			StructClear(variables.loc);
		</cfscript>
	</cffunction>
	
	<!----------------------------------------------------------------------------------------------------------------------------
		BASIC TESTS
	----------------------------------------------------------------------------------------------------------------------------->
<!---	
	<cffunction name="test_000_instance" access="public" output="false" returntype="void">
		<cfscript>
			assert("isDefined('instance')");
			assert("getMetadata(instance).name eq CLASS_NAME");
		</cfscript>
	</cffunction>
	
	<cffunction name="test_001_getApiKey" returntype="void" access="public">
		<cfscript>
			loc.result = variables.instance.getApiKey();
			assert('"56ce2c432858551fa622e751a8828cc4" eq loc.result');
		</cfscript>
	</cffunction>
	
	<cffunction name="test_002_setApiKey" returntype="void" access="public">
		<cfscript>
			variables.instance.setApiKey("anyoldapikey");
			loc.result = variables.instance.getApiKey();
			assert('"anyoldapikey" eq "#loc.result#"');
		</cfscript>
	</cffunction>
	
	<!----------------------------------------------------------------------------------------------------------------------------
		CORE CONTACTSERVICE TESTS
	----------------------------------------------------------------------------------------------------------------------------->
	
	<cffunction name="test_003_addContact_successful" access="public" output="false" returntype="void">
		<cfscript>
			loc.result = $addTestContact();
			assert('IsNumeric(loc.result)');
			loc.result = variables.instance.delete(table="Contact", id=loc.result);
			assert('loc.result eq true');
		</cfscript>
	</cffunction>
	
	<cffunction name="test_004_updateContact_fails" access="public" output="false" returntype="void">
		<cfscript>
			loc.data = {
				"Email" = JavaCast("string", "theonlykid@gmails.com")
			};
			
			loc.exception = raised('variables.instance.updateContact(contactId="948123402", data=loc.data)');
			assert('"infusionsoft.errorResponse" eq loc.exception');
		</cfscript>
	</cffunction>	
	
	<cffunction name="test_005_updateContact_successful" access="public" output="false" returntype="void">
		<cfscript>
			loc.result = $addTestContact();
			
			loc.data = {
				"Email" = JavaCast("string", "theonlykid@gmails.com")
			};
			
			loc.updateResult = variables.instance.updateContact(contactId=loc.result, data=loc.data);
			assert('IsNumeric(loc.updateResult) and loc.result eq loc.updateResult');
			
			// clean up our mess
			variables.instance.delete(table="Contact", id=loc.result);
		</cfscript>
	</cffunction>
	
	<cffunction name="test_006_findByEmail_successful" access="public" output="false" returntype="void">
		<cfscript>
			loc.email = "thekid@gmails.com";
			loc.result = $addTestContact();
			
			loc.query = variables.instance.findContactByEmail(email=loc.email, selectedFields=ListToArray("Id,FirstName,LastName,Email"));
			
			assert('IsQuery(loc.query) and loc.query.recordCount gte 1');
			assert('ListSort(loc.query.columnList, "textnocase") eq "Email,FirstName,Id,LastName"');
			assert('loc.query.email eq loc.email');
			
			// clean up our mess
			variables.instance.delete(table="Contact", id=loc.result);
		</cfscript>
	</cffunction>
	
	<cffunction name="test_007_loadContact_successful" access="public" output="false" returntype="void">
		<cfscript>
			loc.result = $addTestContact();
			
			loc.struct = variables.instance.loadContact(id=loc.result, selectedFields=ListToArray("Id,FirstName,LastName,Email"));
			
			assert('IsStruct(loc.struct)');
			assert('StructKeyExists(loc.struct, "Email")');
			assert('loc.struct.id eq loc.result');
			
			// clean up our mess
			variables.instance.delete(table="Contact", id=loc.result);
		</cfscript>
	</cffunction>
	
	<!----------------------------------------------------------------------------------------------------------------------------
		TAG CONTACTSERVICE TESTS
	----------------------------------------------------------------------------------------------------------------------------->
	
	<cffunction name="test_008_addToGroup_fails" access="public" output="false" returntype="void">
		<cfscript>
			loc.result = $addTestContact();
			
			loc.exception = raised('variables.instance.addToGroup(contactId=loc.result, groupId=948123402)');
			
			// clean up our mess
			// we need to do it here because the assert currently fails as the API is broken
			variables.instance.delete(table="Contact", id=loc.result);
			
			assert('"infusionsoft.errorResponse" eq loc.exception');
		</cfscript>
	</cffunction>
	
	<cffunction name="test_009_addToGroup_successful" access="public" output="false" returntype="void">
		<cfscript>
			loc.result = $addTestContact();
			
			loc.added = variables.instance.addToGroup(contactId=loc.result, groupId=variables.GROUP_ID);
			
			assert('loc.added eq true');
			
			// clean up our mess
			variables.instance.delete(table="Contact", id=loc.result);
		</cfscript>
	</cffunction>
	
	<cffunction name="test_010_removeFromGroup_fails" access="public" output="false" returntype="void">
		<cfscript>
			loc.result = $addTestContact();
			
			loc.exception = raised('variables.instance.removeFromGroup(contactId=loc.result, groupId=948123402)');
			
			// clean up our mess
			// we need to do it here because the assert currently fails as the API is broken
			variables.instance.delete(table="Contact", id=loc.result);
			
			assert('"infusionsoft.errorResponse" eq loc.exception');
		</cfscript>
	</cffunction>
	
	<cffunction name="test_011_removeFromGroup_successful" access="public" output="false" returntype="void">
		<cfscript>
			loc.result = $addTestContact();
			
			loc.added = variables.instance.addToGroup(contactId=loc.result, groupId=variables.GROUP_ID);
			loc.removed = variables.instance.removeFromGroup(contactId=loc.result, groupId=variables.GROUP_ID);
			
			assert('loc.removed eq true');
			
			// clean up our mess
			variables.instance.delete(table="Contact", id=loc.result);
		</cfscript>
	</cffunction>
	
	<!----------------------------------------------------------------------------------------------------------------------------
		FOLLOW UP SEQUENCE CONTACTSERVICE TESTS
	----------------------------------------------------------------------------------------------------------------------------->
	
	<cffunction name="test_012_addToCampaign_successful" access="public" output="false" returntype="void">
		<cfscript>
			loc.result = $addTestContact();
			
			loc.added = variables.instance.addToCampaign(contactId=loc.result, campaignId=variables.CAMPAIGN_ID);
			
			assert('loc.added eq true');
			
			// clean up our mess
			variables.instance.delete(table="Contact", id=loc.result);
		</cfscript>
	</cffunction>
	
	<cffunction name="test_013_getNextCampaignStep_successful" access="public" output="false" returntype="void">
		<cfscript>
			loc.result = $addTestContact();
			
			loc.added = variables.instance.addToCampaign(contactId=loc.result, campaignId=variables.CAMPAIGN_ID);
			loc.nextStep = variables.instance.getNextCampaignStep(contactId=loc.result, campaignId=variables.CAMPAIGN_ID);
			
			assert('IsNumeric(loc.nextStep)');
			
			// clean up our mess
			variables.instance.delete(table="Contact", id=loc.result);
		</cfscript>
	</cffunction>
	
	<cffunction name="test_014_pauseCampaign_successful" access="public" output="false" returntype="void">
		<cfscript>
			loc.result = $addTestContact();
			
			loc.added = variables.instance.addToCampaign(contactId=loc.result, campaignId=variables.CAMPAIGN_ID);
			loc.paused = variables.instance.pauseCampaign(contactId=loc.result, campaignId=variables.CAMPAIGN_ID);
			
			assert('loc.paused eq true');
			
			// clean up our mess
			variables.instance.delete(table="Contact", id=loc.result);
		</cfscript>
	</cffunction>
	
	<cffunction name="test_015_removeFromCampaign_successful" access="public" output="false" returntype="void">
		<cfscript>
			loc.result = $addTestContact();
			
			loc.added = variables.instance.addToCampaign(contactId=loc.result, campaignId=variables.CAMPAIGN_ID);
			loc.removed = variables.instance.removeFromCampaign(contactId=loc.result, campaignId=variables.CAMPAIGN_ID);
			
			assert('loc.removed eq true');
			
			// clean up our mess
			variables.instance.delete(table="Contact", id=loc.result);
		</cfscript>
	</cffunction>
	
	<cffunction name="test_016_resumeCampaignForContact_successful" access="public" output="false" returntype="void">
		<cfscript>
			loc.result = $addTestContact();
			
			loc.added = variables.instance.addToCampaign(contactId=loc.result, campaignId=variables.CAMPAIGN_ID);
			loc.paused = variables.instance.pauseCampaign(contactId=loc.result, campaignId=variables.CAMPAIGN_ID);
			loc.resumed = variables.instance.resumeCampaignForContact(contactId=loc.result, campaignId=variables.CAMPAIGN_ID);
			
			assert('loc.resumed eq true');
			
			// clean up our mess
			variables.instance.delete(table="Contact", id=loc.result);
		</cfscript>
	</cffunction>
	
	<cffunction name="test_017_rescheduleCampaignStep_successful" access="public" output="false" returntype="void">
		<cfscript>
			loc.result = $addTestContact();
			
			loc.added = variables.instance.addToCampaign(contactId=loc.result, campaignId=variables.CAMPAIGN_ID);
			loc.rescheduled = variables.instance.rescheduleCampaignStep(contactIds=ListToArray(loc.result), campaignStepId=variables.CAMPAIGN_STEP_ID);
			
			assert('loc.rescheduled eq true');
			
			// clean up our mess
			variables.instance.delete(table="Contact", id=loc.result);
		</cfscript>
	</cffunction>
	
	<!----------------------------------------------------------------------------------------------------------------------------
		ACTION SET CONTACTSERVICE TESTS
	----------------------------------------------------------------------------------------------------------------------------->
	
	<cffunction name="test_018_runActionSequence_successful" access="public" output="false" returntype="void">
		<cfscript>
			loc.result = $addTestContact();
			
			loc.steps = variables.instance.runActionSequence(contactId=loc.result, actionSetId=variables.ACTION_SET_ID);
			
			assert('IsArray(loc.steps)');
			
			// clean up our mess
			variables.instance.delete(table="Contact", id=loc.result);
		</cfscript>
	</cffunction>
	
	<!----------------------------------------------------------------------------------------------------------------------------
		CORE DATASERVICE TESTS
	----------------------------------------------------------------------------------------------------------------------------->

	<cffunction name="test_019_add_successful" access="public" output="false" returntype="void">
		<cfscript>
			loc.result = variables.instance.add(table="Contact", values=$contactData());
			assert('IsNumeric(loc.result)');
			
			// clean up our mess
			variables.instance.delete(table="Contact", id=loc.result);
		</cfscript>
	</cffunction>
	
	<cffunction name="test_020_load_successful" access="public" output="false" returntype="void">
		<cfscript>
			loc.result = variables.instance.add(table="Contact", values=$contactData());
			loc.contact = variables.instance.load(table="Contact", id=loc.result, wantedFields=ListToArray("Id,FirstName,LastName,Email"));
			
			// clean up our mess
			variables.instance.delete(table="Contact", id=loc.result);
			
			assert('IsStruct(loc.contact)');
			assert('ListSort(StructKeyList(loc.contact), "textnocase") eq "Email,FirstName,Id,LastName"');
		</cfscript>
	</cffunction>
	
	<cffunction name="test_021_update_successful" access="public" output="false" returntype="void">
		<cfscript>
			loc.data = {
				"Email" = JavaCast("string", "theonlykid@gmails.com")
			};
		
			loc.result = variables.instance.add(table="Contact", values=$contactData());
			loc.update = variables.instance.update(table="Contact", id=loc.result, values=loc.data);
			loc.contact = variables.instance.load(table="Contact", id=loc.update, wantedFields=ListToArray("Id,FirstName,LastName,Email"));
			
			// clean up our mess
			variables.instance.delete(table="Contact", id=loc.result);
			
			assert('IsStruct(loc.contact)');
			assert('StructKeyExists(loc.contact, "email")');
			assert('loc.contact.email eq loc.data.email');
		</cfscript>
	</cffunction>
	
	<cffunction name="test_022_delete_fails" access="public" output="false" returntype="void">
		<cfscript>
			loc.exception = raised('variables.instance.delete(table="Contact", id="948123402")');
			assert('"infusionsoft.errorResponse" eq loc.exception');
		</cfscript>
	</cffunction>
		
	<!----------------------------------------------------------------------------------------------------------------------------
		QUERY DATASERVICE TESTS
	----------------------------------------------------------------------------------------------------------------------------->
	
	<cffunction name="test_023_findByField_successful" access="public" output="false" returntype="void">
		<cfscript>
			loc.result = variables.instance.add(table="Contact", values=$contactData());
			loc.contacts = variables.instance.findByField(table="Contact", fieldName="Email", fieldValue="thekid@gmails.com", selectedFields=ListToArray("Id,FirstName,LastName,Email"));
			
			// clean up our mess
			variables.instance.delete(table="Contact", id=loc.result);
			
			assert('IsQuery(loc.contacts) and loc.contacts.recordCount');
		</cfscript>
	</cffunction>
	
	<cffunction name="test_024_query_returns_results_as_query" access="public" output="false" returntype="void">
		<cfscript>
			loc.result = variables.instance.query(table="Contact", selectedFields=ListToArray("Id,FirstName,LastName,Email"));
			assert('IsQuery(loc.result) and loc.result.recordCount');
		</cfscript>
	</cffunction>
	
	<cffunction name="test_025_query_returns_results_as_array" access="public" output="false" returntype="void">
		<cfscript>
			loc.result = variables.instance.query(table="Contact", selectedFields=ListToArray("Id,FirstName,LastName,Email"), returnAs="");
			assert('IsArray(loc.result) and ArrayLen(loc.result)');
		</cfscript>
	</cffunction>
	
	<!----------------------------------------------------------------------------------------------------------------------------
		MISCELLANEOUS DATASERVICE TESTS
	----------------------------------------------------------------------------------------------------------------------------->
	
	
	<!--- ALERT!!!!! You must delete the custom field from within infusionsoft after you run the tests!!!! 
	<cffunction name="test_026_addCustomField_successful" access="public" output="false" returntype="void">
		<cfscript>
			loc.result = variables.instance.addCustomField(context="Contact", displayName="Test Custom Field", dataType="Text", groupId=variables.FORM_GROUP_ID);
			
			assert('IsNumeric(loc.result)');
		</cfscript>
	</cffunction>
	--->
	
	<cffunction name="test_027_authenticateUser_successful" access="public" output="false" returntype="void">
		<cfscript>
			try
			{
				loc.loginId = variables.instance.authenticateUser(username=variables.USERNAME, password=variables.PASSWORD);
			}
			catch (Any e)
			{
				loc.loginId = 0;
			}
			
			assert('loc.loginId neq 0');
		</cfscript>
	</cffunction>
	
	<cffunction name="test_028_getApplicationSetting_successful" access="public" output="false" returntype="void">
		<cfscript>
			loc.setting = variables.instance.getApplicationSetting(module="Order", setting="optioncctypes");
			assert('loc.setting eq "American Express,Discover,MasterCard,Visa,,"');
		</cfscript>
	</cffunction>
	
	<cffunction name="test_029_getTemporaryKey_successful" access="public" output="false" returntype="void">
		<cfscript>
			loc.apiKey = "";
			loc.apiKey = variables.instance.getTemporaryKey(vendorKey=variables.VENDORKEY, username=variables.USERNAME, password=variables.PASSWORD);
			assert('Len(loc.apiKey)');
		</cfscript>
	</cffunction>
	
	<cffunction name="test_030_updateCustomField_successful" access="public" output="false" returntype="void">
		<cfscript>
			loc.data = {
				  "Label" = JavaCast("string", "Test Custom Field Blah")
			};
		
			loc.result = variables.instance.addCustomField(context="Contact", displayName="Test Custom Field", dataType="Text", groupId=variables.FORM_GROUP_ID);
			loc.update = variables.instance.updateCustomField(customFieldId=loc.result, values=loc.data);
			
			assert('loc.update eq true');
		</cfscript>
	</cffunction>

	<!----------------------------------------------------------------------------------------------------------------------------
		AFFILIATE SERVICE
	----------------------------------------------------------------------------------------------------------------------------->
		
	<cffunction name="test_031_affClawbacks_successful" returntype="void" access="public">
		<cfscript>
			loc.id = 3;
			loc.filterStartDate = CreateDate(2009, 1, 1);
			loc.filterEndDate = Now();
			loc.result = variables.instance.affClawbacks(loc.id, loc.filterStartDate, loc.filterEndDate);
			assert('IsQuery(loc.result)');
		</cfscript>
	</cffunction>
		
	<cffunction name="test_032_affCommissions_successful" returntype="void" access="public">
		<cfscript>
			loc.id = 3;
			loc.filterStartDate = CreateDate(2009, 1, 1);
			loc.filterEndDate = Now();
			loc.result = variables.instance.affCommissions(loc.id, loc.filterStartDate, loc.filterEndDate);
			assert('IsQuery(loc.result)');
		</cfscript>
	</cffunction>
		
	<cffunction name="test_033_affPayouts_successful" returntype="void" access="public">
		<cfscript>
			loc.id = 3;
			loc.filterStartDate = CreateDate(2009, 1, 1);
			loc.filterEndDate = Now();
			loc.result = variables.instance.affPayouts(loc.id, loc.filterStartDate, loc.filterEndDate);
			assert('IsQuery(loc.result)');
		</cfscript>
	</cffunction>
		
	<cffunction name="test_034_affRunningTotals_successful" returntype="void" access="public">
		<cfscript>
			loc.ids = [ 3 ];
			loc.filterStartDate = CreateDate(2009, 1, 1);
			loc.filterEndDate = Now();
			loc.result = variables.instance.affRunningTotals(loc.ids);
			assert('IsQuery(loc.result)');
			assert('loc.result.RecordCount gt 0');
			assert('loc.result.affiliateId eq 6');
		</cfscript>
	</cffunction>
		
	<cffunction name="test_035_affSummary_successful" returntype="void" access="public">
		<cfscript>
			loc.ids = [3];
			loc.filterStartDate = CreateDate(2009, 1, 1);
			loc.filterEndDate = Now();
			loc.result = variables.instance.affSummary(loc.ids, loc.filterStartDate, loc.filterEndDate);
			assert('IsQuery(loc.result)');
		</cfscript>
	</cffunction>

	<!----------------------------------------------------------------------------------------------------------------------------
		INVOICE SERVICE
	----------------------------------------------------------------------------------------------------------------------------->
	
	<cffunction name="test_036_createBlankOrder_successful" returntype="void" access="public">
		<cfscript>
			loc.contactId = $addTestContact();
			loc.order = variables.instance.createBlankOrder(contactId=loc.contactId, description="", orderDate=Now(), leadAffiliateId=0, saleAffiliateId=0);
			
			// clean up our mess
			variables.instance.delete(table="Contact", id=loc.contactId);
			
			assert('IsNumeric(loc.order) and loc.order gt 0');
		</cfscript>
	</cffunction>
		
	<cffunction name="test_037_addOrderItem_successful" returntype="void" access="public">
		<cfscript>
			loc.contactId = $addTestContact();
			loc.order = variables.instance.createBlankOrder(contactId=loc.contactId, description="", orderDate=Now(), leadAffiliateId=0, saleAffiliateId=0);
			loc.productAdded = variables.instance.addOrderItem(invoiceId=loc.order, productId=variables.PRODUCT_ID, type=4, price=15.00, quantity=1, description="A product", notes="");
			// clean up our mess
			variables.instance.delete(table="Contact", id=loc.contactId);
			
			assert('IsBoolean(loc.productAdded) and loc.productAdded');
		</cfscript>
	</cffunction>
		
	<cffunction name="test_038_chargeInvoice_successful" returntype="void" access="public">
		<cfscript>
			loc.contactId = $addTestContact();
			loc.order = variables.instance.createBlankOrder(contactId=loc.contactId, description="", orderDate=Now(), leadAffiliateId=0, saleAffiliateId=0);
			loc.productAdded = variables.instance.addOrderItem(invoiceId=loc.order, productId=variables.PRODUCT_ID, type=4, price=15.00, quantity=1, description="A product", notes="");
			
			loc.details = $creditCardData(loc.contactId);
			
			loc.ccId = variables.instance.add(table="CreditCard", values=loc.details);
			loc.results = variables.instance.chargeInvoice(loc.order, "", loc.ccId, variables.MERCHANTACCOUNT_ID, 0);
			
			// clean up our mess
			variables.instance.delete(table="Contact", id=loc.contactId);
			
			assert('loc.results.successful eq true');
			assert('loc.results.code eq "APPROVED"');
		</cfscript>
	</cffunction>
	
	<cffunction name="test_039_deleteInvoice_successful" returntype="void" access="public">
		<cfscript>
			loc.contactId = $addTestContact();
			loc.order = variables.instance.createBlankOrder(contactId=loc.contactId, description="", orderDate=Now(), leadAffiliateId=0, saleAffiliateId=0);
			loc.productAdded = variables.instance.addOrderItem(invoiceId=loc.order, productId=variables.PRODUCT_ID, type=4, price=15.00, quantity=1, description="A product", notes="");
			
			loc.orderDeleted = variables.instance.deleteInvoice(invoiceId=loc.order);
			
			// clean up our mess
			variables.instance.delete(table="Contact", id=loc.contactId);
			
			assert('loc.orderDeleted eq true');
		</cfscript>
	</cffunction>
	
	<cffunction name="test_040_addRecurringOrder_successful" returntype="void" access="public">
		<cfscript>
			loc.contactId = $addTestContact();
			
			// add in a credit card for this contact
			loc.details = $creditCardData(loc.contactId);
			loc.ccId = variables.instance.add(table="CreditCard", values=loc.details);
			
			loc.order = variables.instance.addRecurringOrder(contactId=loc.contactId, allowDuplicate=false, cProgramId=variables.CPROGRAM_ID, qty=1, price=60.00, allowTax=false, merchantAccountId=variables.MERCHANTACCOUNT_ID, creditCardId=loc.ccId, affiliateId=0, daysTillCharge=0);
			
			// clean up our mess
			variables.instance.delete(table="Contact", id=loc.contactId);
			
			assert('IsNumeric(loc.order) and loc.order gt 0');
		</cfscript>
	</cffunction>
	
	<cffunction name="test_041_deleteSubscription_successful" returntype="void" access="public">
		<cfscript>
			loc.contactId = $addTestContact();
			
			// add in a credit card for this contact
			loc.details = $creditCardData(loc.contactId);
			loc.ccId = variables.instance.add(table="CreditCard", values=loc.details);
			
			loc.order = variables.instance.addRecurringOrder(contactId=loc.contactId, allowDuplicate=false, cProgramId=variables.CPROGRAM_ID, qty=1, price=60.00, allowTax=false, merchantAccountId=variables.MERCHANTACCOUNT_ID, creditCardId=loc.ccId, affiliateId=0, daysTillCharge=0);
			
			loc.subDeleted = variables.instance.deleteSubscription(id=loc.order);
			// clean up our mess
			variables.instance.delete(table="Contact", id=loc.contactId);
			
			assert('IsBoolean(loc.subDeleted) and loc.subDeleted');
		</cfscript>
	</cffunction>
	
	<cffunction name="test_042_addRecurringCommissionOverride_successful" returntype="void" access="public">
		<cfscript>
			loc.contactId = $addTestContact();
			
			// add in a credit card for this contact
			loc.details = $creditCardData(loc.contactId);
			loc.ccId = variables.instance.add(table="CreditCard", values=loc.details);
			
			loc.order = variables.instance.addRecurringOrder(contactId=loc.contactId, allowDuplicate=false, cProgramId=variables.CPROGRAM_ID, qty=1, price=60.00, allowTax=false, merchantAccountId=variables.MERCHANTACCOUNT_ID, creditCardId=loc.ccId, affiliateId=0, daysTillCharge=0);
			
			loc.overrideAdded = variables.instance.addRecurringCommissionOverride(recurringOrderId=loc.order, affiliateId=variables.AFFILIATE_ID, amount=5.00, payoutType=5, description="Test.");
			// clean up our mess
			variables.instance.delete(table="Contact", id=loc.contactId);
			
			assert('IsBoolean(loc.overrideAdded) and loc.overrideAdded');
		</cfscript>
	</cffunction>
	
	<cffunction name="test_043_createInvoiceForRecurring_successful" returntype="void" access="public">
		<cfscript>
			loc.contactId = $addTestContact();
			
			// add in a credit card for this contact
			loc.details = $creditCardData(loc.contactId);
			loc.ccId = variables.instance.add(table="CreditCard", values=loc.details);
			
			loc.order = variables.instance.addRecurringOrder(contactId=loc.contactId, allowDuplicate=false, cProgramId=variables.CPROGRAM_ID, qty=1, price=60.00, allowTax=false, merchantAccountId=variables.MERCHANTACCOUNT_ID, creditCardId=loc.ccId, affiliateId=0, daysTillCharge=0);
			
			loc.invoiceId = variables.instance.createInvoiceForRecurring(recurringOrderId=loc.order);
			// clean up our mess
			variables.instance.delete(table="Contact", id=loc.contactId);
			
			assert('IsNumeric(loc.invoiceId) and loc.invoiceId gt 0');
		</cfscript>
	</cffunction>
	
	<cffunction name="test_044_addManualPayment_successful" returntype="void" access="public">
		<cfscript>
			loc.contactId = $addTestContact();
			
			// add in a credit card for this contact
			loc.details = $creditCardData(loc.contactId);
			loc.ccId = variables.instance.add(table="CreditCard", values=loc.details);
			
			loc.order = variables.instance.addRecurringOrder(contactId=loc.contactId, allowDuplicate=false, cProgramId=variables.CPROGRAM_ID, qty=1, price=60.00, allowTax=false, merchantAccountId=variables.MERCHANTACCOUNT_ID, creditCardId=loc.ccId, affiliateId=0, daysTillCharge=0);
			
			loc.invoiceId = variables.instance.createInvoiceForRecurring(recurringOrderId=loc.order);
			
			loc.paymentAdded = variables.instance.addManualPayment(invoiceId=loc.invoiceId, amt=60.00, paymentDate=Now(), paymentType="Check", paymentDescription="Test.", bypassCommissions=false);
			// clean up our mess
			variables.instance.delete(table="Contact", id=loc.contactId);
			
			assert('IsBoolean(loc.paymentAdded) and loc.paymentAdded');
		</cfscript>
	</cffunction>

	<cffunction name="test_045_addPaymentPlan_successful" returntype="void" access="public">
		<cfscript>
			loc.contactId = $addTestContact();
			loc.order = variables.instance.createBlankOrder(contactId=loc.contactId, description="", orderDate=Now(), leadAffiliateId=0, saleAffiliateId=0);
			loc.productAdded = variables.instance.addOrderItem(invoiceId=loc.order, productId=variables.PRODUCT_ID, type=4, price=15.00, quantity=1, description="A product", notes="");
			
			loc.details = $creditCardData(loc.contactId);
			
			loc.ccId = variables.instance.add(table="CreditCard", values=loc.details);
			
			
			loc.results = variables.instance.addPaymentPlan(loc.order, true, loc.ccId, variables.MERCHANTACCOUNT_ID, 1, 3, 5.00, Now(), DateAdd("d", 30, Now()), 3, 5);
			
			// clean up our mess
			variables.instance.delete(table="Contact", id=loc.contactId);
			
			assert('IsBoolean(loc.results) and loc.results');
		</cfscript>
	</cffunction>
	
	<cffunction name="test_046_calculateAmountOwed_successful" returntype="void" access="public">
		<cfscript>
			loc.contactId = $addTestContact();
			loc.order = variables.instance.createBlankOrder(contactId=loc.contactId, description="", orderDate=Now(), leadAffiliateId=0, saleAffiliateId=0);
			loc.productAdded = variables.instance.addOrderItem(invoiceId=loc.order, productId=variables.PRODUCT_ID, type=4, price=15.00, quantity=1, description="A product", notes="");
			
			loc.details = $creditCardData(loc.contactId);
			
			loc.ccId = variables.instance.add(table="CreditCard", values=loc.details);
			
			
			loc.results = variables.instance.calculateAmountOwed(loc.order);
			
			// clean up our mess
			variables.instance.delete(table="Contact", id=loc.contactId);
			
			assert('IsNumeric(loc.results) and loc.results eq 15');
		</cfscript>
	</cffunction>

	<cffunction name="test_047_getAllPaymentOptions_successful" returntype="void" access="public">
		<cfscript>
			loc.paymentOptions = variables.instance.getAllPaymentOptions();
			assert('IsStruct(loc.paymentOptions)');
		</cfscript>
	</cffunction>
	
	<cffunction name="test_048_getPayments_successful" returntype="void" access="public">
		<cfscript>
			loc.contactId = $addTestContact();
			
			// add in a credit card for this contact
			loc.details = $creditCardData(loc.contactId);
			loc.ccId = variables.instance.add(table="CreditCard", values=loc.details);
			
			loc.order = variables.instance.addRecurringOrder(contactId=loc.contactId, allowDuplicate=false, cProgramId=variables.CPROGRAM_ID, qty=1, price=60.00, allowTax=false, merchantAccountId=variables.MERCHANTACCOUNT_ID, creditCardId=loc.ccId, affiliateId=0, daysTillCharge=0);
			
			loc.invoiceId = variables.instance.createInvoiceForRecurring(recurringOrderId=loc.order);
			
			loc.paymentAdded = variables.instance.addManualPayment(invoiceId=loc.invoiceId, amt=40.00, paymentDate=Now(), paymentType="Check", paymentDescription="Test.", bypassCommissions=false);
			
			loc.payments = variables.instance.getPayments(loc.invoiceId);
			// clean up our mess
			variables.instance.delete(table="Contact", id=loc.contactId);
			
			assert('IsQuery(loc.payments) and loc.payments.RecordCount eq 1');
		</cfscript>
	</cffunction>
	
	<cffunction name="test_049_locateExistingCard_successful" returntype="void" access="public">
		<cfscript>
			loc.contactId = $addTestContact();
			
			// add in a credit card for this contact
			loc.details = $creditCardData(loc.contactId);
			loc.ccId = variables.instance.add(table="CreditCard", values=loc.details);
			
			loc.ccId2 = variables.instance.locateExistingCard(loc.contactId, Right(loc.details.cardNumber, 4));
			
			assert('loc.ccId eq loc.ccId2');
		</cfscript>
	</cffunction>
	
	<cffunction name="test_050_recalculateTax_successful" returntype="void" access="public">
		<cfscript>
			loc.contactId = $addTestContact();
			loc.order = variables.instance.createBlankOrder(contactId=loc.contactId, description="", orderDate=Now(), leadAffiliateId=0, saleAffiliateId=0);
			loc.productAdded = variables.instance.addOrderItem(invoiceId=loc.order, productId=variables.PRODUCT_ID, type=4, price=15.00, quantity=1, description="A product", notes="");
			
			loc.results = variables.instance.recalculateTax(loc.order);
			
			// clean up our mess
			variables.instance.delete(table="Contact", id=loc.contactId);
			
			assert('IsBoolean(loc.results) and loc.results');
		</cfscript>
	</cffunction>

	<cffunction name="test_051_validateCreditCard_successful" returntype="void" access="public">
		<cfscript>
			loc.contactId = $addTestContact();
			loc.details = $creditCardData(loc.contactId);
			loc.ccId = variables.instance.add(table="CreditCard", values=loc.details);
			
			loc.results = variables.instance.validateCreditCard(loc.ccId);
			
			assert('IsStruct(loc.results) and loc.results.valid eq 1');
		</cfscript>
	</cffunction>
	
	<cffunction name="test_051_validateCreditCardDetails_successful" returntype="void" access="public">
		<cfscript>
			loc.contactId = $addTestContact();
			loc.details = $creditCardData(loc.contactId);
			
			loc.results = variables.instance.validateCreditCardDetails(creditCardDetails=loc.details);
			
			assert('IsStruct(loc.results) and loc.results.valid eq 1');
		</cfscript>
	</cffunction>
	
	<cffunction name="test_052_getAllShippingOptions_successful" returntype="void" access="public">
		<cfscript>
			loc.results = variables.instance.getAllShippingOptions();
			assert('IsStruct(loc.results)');
		</cfscript>
	</cffunction>
--->

	<!----------------------------------------------------------------------------------------------------------------------------
		API EMAIL SERVICE
	----------------------------------------------------------------------------------------------------------------------------->
	
	<cffunction name="test_053_addEmailTemplate_successful" returntype="void" access="public">
		<cfscript>
			loc.results = variables.instance.getAllShippingOptions();
			assert('IsStruct(loc.results)');
		</cfscript>
	</cffunction>






	<!---
		private methods we need to reuse in tests
	--->
	<cffunction name="$addTestContact" access="private" output="false" returntype="any">
		<cfreturn variables.instance.addContact(data=$contactData()) />
	</cffunction>
	
	<cffunction name="$contactData" access="private" output="false" returntype="struct">
		<cfscript>
			var data = {
				  "FirstName" = JavaCast("string", "Billy")
				, "LastName" = JavaCast("string", "Kid")
				, "MiddleName" = JavaCast("string", "the")
				, "Email" = JavaCast("string", "thekid@gmails.com")
				, "Password" = JavaCast("string", "easymac")
				, "Username" = JavaCast("string", "bigdaddy")
			};
		</cfscript>
		<cfreturn data />
	</cffunction>
	
	<cffunction name="$creditCardData" access="private" output="false" returntype="struct">
		<cfargument name="contactId" type="numeric" required="true" />
		<cfscript>
			var loc = {};
			
			// add in a credit card to charge
			loc.details["ContactId"] = JavaCast("int", arguments.contactId);
			loc.details["NameOnCard"] = JavaCast("string", "Billy Kid");
			loc.details["CardNumber"] = JavaCast("string", "4111111111111111");
			loc.details["CardType"] = JavaCast("string", "Visa");
			loc.details["CVV2"] = JavaCast("string", RandRange(111, 999));
			loc.details["ExpirationYear"] = JavaCast("string", RandRange(2012, 2019));
			loc.details["ExpirationMonth"] = JavaCast("string", "05");
			loc.details["BillAddress1"] = JavaCast("string", "2873 Marsala Court");
			loc.details["BillAddress2"] = JavaCast("string", "");
			loc.details["BillCity"] = JavaCast("string", "Orlando");
			loc.details["BillState"] = JavaCast("string", "FL");
			loc.details["BillZip"] = JavaCast("string", "32806");
			loc.details["BillCountry"] = JavaCast("string", "US");
		</cfscript>
		<cfreturn loc.details />
	</cffunction>
	
</cfcomponent>

