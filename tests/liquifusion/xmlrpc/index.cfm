<h2>Transform Tests</h2>
<cfinvoke component="net.sourceforge.cfunit.framework.TestSuite"
	method="init"
	classes="tests.liquifusion.xmlrpc.TransformTests"
	returnvariable="testSuite" />

<cfinvoke component="net.sourceforge.cfunit.framework.TestRunner" method="run">
	<cfinvokeargument name="test" value="#testSuite#">
	<cfinvokeargument name="name" value="">
</cfinvoke>

<h2>Client Tests</h2>
<cfinvoke component="net.sourceforge.cfunit.framework.TestSuite"
	method="init"
	classes="tests.liquifusion.xmlrpc.ClientTests"
	returnvariable="testSuite" />

<cfinvoke component="net.sourceforge.cfunit.framework.TestRunner" method="run">
	<cfinvokeargument name="test" value="#testSuite#">
	<cfinvokeargument name="name" value="">
</cfinvoke>

