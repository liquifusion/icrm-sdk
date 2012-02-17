<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title>Coldfusion Infusionsoft SDK Documentation</title>
	</head>
	<body>
	
		<div>
			<h1>Coldfusion Infusionsoft SDK</h1>
			<p>The Coldfusion Infusionsoft SDK is meant to help Coldfusion developers bridge the gap between the Infusionsoft API and
				Native Coldfusion functionality. We have (for the most part) achieved this goal by creating a method for method conversion
				of the Infusionsoft API to a Coldfusion API from which you can easily and reliably access data.</p>
			
			<h2>Getting Started Essentials</h2>
			<p>To get started with the Coldfusion Infusionsoft SDK</p>
			<ul>
				<li>Unzip the package you were sent as a part of the purchase.</li>
				<li>Move the "com" folder into the root directory of your coldfusion website.</li>
				<li>- OR - put the "com" folder anywhere on your server and create a coldfusion mapping of "/com" which points to the com folder.</li>
			</ul>
			<h3>SDK Use</h3>
			<p>To use the SDK, simply create the SDK object and pass two parameters to the <code>init()</code>.</p>
			<ol>
				<li>The application name of your infusionsoft install. Ex. If you install URL is http://myappname.infusionsoft.com then the application name
					is myappname.</li>
				<li>The infusionsoft API Key.</li>
			</ol>
			<p>The code to instantiate the sdk goes something like the example below.</p>
			<code>
				&lt;cfset variables.sdk = CreateObject("component", "com.liquifusion.infusionsoft.core.Sdk").init("yourInfusionsoftSubdomain", "yourApiKey") /&gt;
			</code>
			<p>Once you have created the object, you can call any of the 
				<a href="http://www.infusionsoft.com/fusebox/api/" title="Infusionsoft API">Infusionsoft API</a> 
				methods with the proper parameters and receive
				back a coldfusion object. To see the list of methods, the corresponding parameters and return types, just <code>&lt;cfdump&gt;</code> the SDK object.
				We have already done this for you at the bottom of this document. Also in the dump, you will notice that we have included
				in the hint attribute a link to the Infusionsoft documentation for API method being invoked. Rather than re-document every
				method, we instead have chosen to point to the original documentation. Please be forewarned that the Infusionsoft API is not 
				perfect and some methods do not work as expected. We have also documented what we know at the bottom of this document.</p>
				
			<h2><a href="http://www.xmlrpc.com/">XMLRPC</a></h2>
			<p>We have included two XMLRPC implementations with the infusionsoft SDK. By default, the SDK uses an all Coldfusion XMLRPC library
				written by Liquifusion Studios. This XMLRPC library works great for small implementations. If you need more performant serialization /
				deserialization from the XML to Coldfusion, you may install the included .jar files which is documented below. </p>
			<p>Also include in this package is the <a href="http://ws.apache.org/xmlrpc/">Apache XMLRPC</a> Java implementation. This XMLRPC
				client is 500% (at least) faster than our native Coldfusion implementation.</p>
			<p>Both XMLRPC client implementations
				do the heavy lifting of sending off and receiving XMLRPC requests and serializing/deserializing communications from the
				XML dialect to native Coldfusion objects.</p>
			<p>XMLRPC requires strict typing of values which can include the following:</p>
			<ul>
				<li>Integer</li>
				<li>Double</li>
				<li>Bolean</li>
				<li>String</li>
				<li>Date</li>
				<li>Array</li>
				<li>Structure</li>
			</ul>
			<p>In order to provide a reliable conversion to the strong data types that are required for XMLRPC communication, the library 
				requires that all simple values (boolean, integer, double and strings) be cast to their native Java types before being
				serialized.</p>
			<p>We have tried to hide this complexity as much as possible by  doing the type conversions in the SDK, but there are currently
				8 methods that take either structs of data or a single value where all values contained must be <code>JavaCast()</code> before being passed
				to the SDK method. This is to ensure that the proper serialization is created and transitted to the Infusionsoft API. These
				methods have been documented with this warning which you can see in the dump below.</p>
			
			<h3>/lib/ Contents</h3>
			<p>If you would like enhanced performace for XMLRPC serialization / deserialization, the contents of the lib folder (5 jar files) must be 
			installed in a Coldfusion Classpath. Please read <a href="http://weblogs.macromedia.com/cantrell/archives/2004/07/the_definitive.html">Chritian 
			Cantrell's Post</a> on how to install .jar files in Coldfusion.</p>			
			
			<h2>Custom Fields in Infusionsoft</h2>
			<p>When dealing with the infusionsoft API, you will more than likely be pulling custom fields for the contact table. When pulling custom fields from the API, you must
				pass in the field name with an underscore (_). If the API returns multiple records, the query that is returned will have the field name as "custom" and the field
				name with the underscore. This is because coldfusion does not allow underscores at the beginning of query column names.</p>
			
			<h2>Other fun facts</h2>
			<ul>
				<li>The Infusionsoft API is CASE SENSITIVE. Please be aware of this when specifying fields that you would like to pull back from the API.</li>
				<li>When pulling data back, you will only get the fields that are not null in the infusionsoft database.</li>
				<li>"~null~" represents a null value when dealing with the api. You can pass this string in to set any fields back to null or you can query with this value where allowed.</li>
			</ul>
			
			<h2>Future efforts</h2>
			<ul>
				<li>More Performance Tuning - this should be near complete with the inclusion of the apache library for serialization / deserialization.</li>
				<li>Creation of an ActiveRecord Model with limited asscoiations.</li>
			</ul>
			
			<h2>Beta Warning</h2>
			<p>As this is beta software, please expect to find bugs and issues.</p>
			<p>If you find a bug or have an issue with the infusionsoft API, please email us at 
				<a href="mailto:support@liquifusion.com">support@liquifusion.com</a> so that we can quickly respond to your request. Code patches
				are also appreciated.</p>
				
			<h2>Known Infusionsoft API Issues</h2>
			<ul>
				<li>ContactService.addToGroup - Always returns true. Infusionsoft knows of this issues and are working to resolve it.</li>
				<li>ContactService.removeFromGroup - Always returns true. Infusionsoft knows of this issues and are working to resolve it.</li>
				<li>DataService.getMetaData - Although documented as a feature of the API, this method is currently not available.</li>
				<li>InvoiceService.getPayments - Method does not return expected results.</li>
				<li>InvoiceService.calculateAmountOwed - Method does not return expected results.</li>
			</ul>
			
			<h2>Gotta love <code>&lt;cfdump&gt;</code> (aka full documentation)</h2>
			<cfset variables.sdk = CreateObject("component", "com.liquifusion.infusionsoft.core.Sdk").init("yourDomain", "yourApiKey") />
			<cfdump var="#variables.sdk#" />
		</div>


	</body>
</html>


