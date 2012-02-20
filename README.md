# iCRM SDK

The iCRM SDK is meant to help ColdFusion developers bridge the gap between the Infusionsoft API and
native CFML functionality. We have (for the most part) achieved this goal by creating a method-for-method conversion
of the Infusionsoft API to a ColdFusion API from which you can easily and reliably access data.

## Getting Started

To get started with the Coldfusion Infusionsoft SDK:

  * Unzip the download package.
  * Move the `com` folder into the root directory of your ColdFusion website.
  * - OR - put the `com` folder anywhere on your server and create a ColdFusion mapping of `/com` pointing to the `com` folder.

## SDK Use

To use the SDK, simply create the SDK object and pass two parameters to the `init()` constructor.

  * The application name of your Infusionsoft install. Ex. If your install URL is `http://myappname.infusionsoft.com/`, then the application name is `myappname`.
  * The Infusionsoft API Key.

The code to instantiate the SDK goes something like the example below.

    <cfset variables.sdk = CreateObject("component", "com.liquifusion.infusionsoft.core.Sdk").init("myappname", "yourApiKey")>

Once you have created the object, you can call any of the [Infusionsoft API][1] methods with the proper parameters and receive
back a ColdFusion object. To see the list of methods, the corresponding parameters and return types, just `<cfdump>` the SDK object.
We have already done this for you at the bottom of the included `documentation.cfm`. Also in the dump, you will notice that we have
included in the `hint` attribute a link to the Infusionsoft documentation for each API method being invoked. Rather than re-document
every method, we instead have chosen to point to the original documentation. Please be forewarned that the Infusionsoft API is not 
perfect and some methods do not work as expected. We have also documented what we know at the bottom of this document.

### [XMLRPC][2]

We have included two XMLRPC implementations with the Infusionsoft SDK. By default, the SDK uses an all-CFML XMLRPC library written
by Liquifusion Studios. This XMLRPC library works great for small implementations. If you need more performant serialization /
deserialization from the XML to ColdFusion, you may install the included `.jar` files, which are documented below.

Also included in this package is the [Apache XMLRPC][3] Java implementation. This XMLRPC client is 500% (at least) faster than our
native CFML implementation.

Both XMLRPC client implementations do the heavy lifting of sending off and receiving XMLRPC requests and serializing/deserializing
communications from the XML dialect to native ColdFusion objects.

XMLRPC requires strict typing of values which can include the following:

  * Integer
  * Double
  * Bolean
  * String
  * Date
  * Array
  * Structure

In order to provide a reliable conversion to the strong data types that are required for XMLRPC communication, the library 
requires that all simple values (boolean, integer, double and strings) be cast to their native Java types before being
serialized.

We have tried to hide this complexity as much as possible by doing the type conversions in the SDK, but there are currently
8 methods that take either structs of data or a single value where all values contained must be `JavaCast()` before being passed
to the SDK method. This is to ensure that the proper serialization is created and transitted to the Infusionsoft API. These
methods have been documented with this warning, which we have provided in the dump run by `documentation.cfm`.

### `/lib/` Contents

If you would like enhanced performace for XMLRPC serialization/deserialization, the contents of the `lib` folder (5 jar files) must be 
installed in a ColdFusion Classpath. Please read Chritian Cantrell's post on [how to install `.jar` files in Coldfusion][4].

### Custom Fields in Infusionsoft

When dealing with the infusionsoft API, you will more than likely be pulling custom fields for the contact table. When pulling
custom fields from the API, you must pass in the field name with an underscore (`_`). If the API returns multiple records, the
query that is returned will have the field name as `custom` and the field name with the underscore. This is because ColdFusion
does not allow underscores at the beginning of query column names.

### Other Fun Facts

  * The Infusionsoft API is CASE SENSITIVE. Please be aware of this when specifying fields that you would like to pull back from the API.</li>
  * When pulling data back, you will only get the fields that are not `null` in the Infusionsoft database.
  * `~null~` represents a `null` value when dealing with the API. You can pass this string in to set any fields back to `null`, or you can query with this value where allowed.

## Future Efforts

  * More performance tuning - this should be near complete with the inclusion of the Apache library for serialization/deserialization.
  * Creation of an ActiveRecord-based model with limited associations.

## Feedback and Contributions

The source code for iCRM SDK is located on our GitHub repository. Code changes submitted via pull requests are much appreciated.
https://github.com/liquifusion/icrm-sdk

If you find a bug with the SDK, please submit an issue in the [GitHub repository][5].

## Known Infusionsoft API Issues

  * `ContactService.addToGroup` - Always returns `true`. Infusionsoft knows of this issues and are working to resolve it.
  * `ContactService.removeFromGroup` - Always returns `true`. Infusionsoft knows of this issues and are working to resolve it.
  * `DataService.getMetaData` - Although documented as a feature of the API, this method is currently not available.
  * `InvoiceService.getPayments` - Method does not return expected results.
  * `InvoiceService.calculateAmountOwed` - Method does not return expected results.

## License: Apache 2.0

Copyright 2012 Liquifusion Studios, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

[1]: http://developers.infusionsoft.com/classes/
[2]: http://www.xmlrpc.com/
[3]: http://ws.apache.org/xmlrpc/
[4]: http://weblogs.macromedia.com/cantrell/archives/2004/07/the_definitive.html
[5]: https://github.com/liquifusion/icrm-sdk/issues