# Release Notes

## v1.0.0   * ????????

  * update all methods with the new links to the latest documentation
  * update all methods to make sure the argument names were as consistent as possible with the API
  * added the findContactByEmail method to the sdk
  * added the resumeCampaignForContact method to the sdk
  * updated Sdk.cfc to access a timeout from the developer in case infusionsofts systems are down. Defaults to 5 seconds

## v0.6.1   * 2013/09/04

  * Fixed [#5][1] Error: [InvalidConfig]Invalid Configuration: for help setting up your API, please contact Support ( ext. 2) (empty)

## v0.6.0   * 2011/01/04

  * fixed the method getApplicationSetting() to work as expected
  * fixed an issue with validateCreditCardDetails to JavaCast variables as required by the infusionsoft table documentation
  * fixed an inconsistency with getting structs back from the java xmlprc implementation where the struct members were case sensitive and could only be accessed through bracket notation
  * Bud sent in a couple fixes to the SDK, thanks Bud!!! These include a fix for sendEmail() and addEmailTemplate() and the addition of three new methods including delete(), getEmailTemplate() and updateEmailTemplate().

## v0.5.0   * 2010/10/04

  * added new method delete() to the SDK
  * added new method getEmailTemplate() to the SDK
  * added new method sendEmailTemplate() to the SDK
  * fixed a couple items in the documentation.cfm file.
  * added a check in Connection.cfc to make sure that the SDK what instantiate BEFORE trying to send out a call to the API.

## v0.4.1   * 1020/04/19

  * updated findByField() to allow the developer to decide if they would like a query or array of structs returned.

## v0.4.0   * 2010/02/09

  * fixed a bug with converting custom fields that start with an underscore to "custom_" within the transform object

## v0.3.0   * 2010/01/22

  * added support to the sdk to make sure any fields you query on are returned. Infusionsofts default behaviour is to only return fields that are not null.
  * updated the query() method with a new argument returnAs. This arguments defaults to "Query" but can also be set to an empty string "" to return an array of struct. This is the native deserialization that happens for both the Java XMLRPC client and the CF client, therefore is faster as the SDK does not loop over the array of structs to create a query out of them. This is now more practical since I have implemented the previous change.

## v0.2.0   * 2009/07/22

  * new library included with the SDK for XMLRPC calls. (http://ws.apache.org/xmlrpc/)
  * com.liquifusion.infusionsoft.Connection will automatically try to use the Apache implementation and fall back to using the all Coldfusion XMLRPC if it is unable to instanciate the java implementation
  * added the API method getTemporaryKey() for use with a vendor key
  * Updated the SDK to not require an apiKey so that getTemporaryKey() could grab back an api key.
  * Added com.utility.QueryHelper for transforming and array of structures to a query
  * updated documentation to reflect changes to the Connection object and the new xmlrpc library

## v0.1.2   * 2009/06/23

  * update to the SDK since CF7 does not easily JavaCast() string[] and int[]. Created a private method to loop through these arrays and cast each individual item.

## v0.1.1   * 2009/06/22

  * Update to the Transform.cfc to make the object CF7 compatible. Removed the function IsInstanceOf() with  variable.getClass().isInstance().


[1]: https://github.com/liquifusion/icrm-sdk/issues/5