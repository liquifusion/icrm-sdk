<h2>Connection Tests</h2>
<cfinvoke component="net.sourceforge.cfunit.framework.TestSuite"
	method="init"
	classes="tests.liquifusion.infusionsoft.core.ConnectionTests"
	returnvariable="testSuite" />

<cfinvoke component="net.sourceforge.cfunit.framework.TestRunner" method="run">
	<cfinvokeargument name="test" value="#testSuite#">
	<cfinvokeargument name="name" value="">
</cfinvoke>

<h2>SDK Tests</h2>
<cfinvoke component="net.sourceforge.cfunit.framework.TestSuite"
	method="init"
	classes="tests.liquifusion.infusionsoft.core.SdkTests"
	returnvariable="testSuite" />

<cfinvoke component="net.sourceforge.cfunit.framework.TestRunner" method="run">
	<cfinvokeargument name="test" value="#testSuite#">
	<cfinvokeargument name="name" value="">
</cfinvoke>
