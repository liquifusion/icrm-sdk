<!---
	Sample CFC to be tested using RocketUnit.
	
	Note that although we are testing a CFC in this instance, we could also test includes,
	custom tags, functions or even web pages or remote services using cfhttp etc.

	Copyright 2007 RocketBoots Pty Limited - http://www.rocketboots.com.au

    This file is part of RocketUnit.

    RocketUnit is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    RocketUnit is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with RocketUnit; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

	@version $Id: Sample.cfc 167 2007-04-12 07:50:15Z robin $
--->
<cfcomponent>
	
	<!---
		Constructor - the test case calls this and checks to see that it is returning
		the instance to the caller.
	--->
	<cffunction access="public" returntype="com.rocketboots.sample.Sample" name="init">
		<!--- Do something here --->
		<cfreturn this>
	</cffunction>
	
	
	
	<!---
		Simple method with a deliberate bug, so that we can see how
		RocketUnit reports failed assertions.
	--->
	<cffunction access="public" returntype="numeric" name="addOne">
		<cfargument type="numeric" name="value" required="true">
		
		<!--- <cfreturn value + 1> --->
		<cfreturn value>
	
	</cffunction>
	
	
	
	<!---
		Cause a runtime error: sqrt doesn't exist
	--->
	<cffunction access="public" returntype="numeric" name="squareRoot">
		<cfargument type="numeric" name="value" required="true">
		
		<cfreturn sqrt(value)>
		
	</cffunction>
	
	
	
	<!---
		A fixed verision of the above
	--->
	<cffunction access="public" returntype="numeric" name="squareRoot2">
		<cfargument type="numeric" name="value" required="true">
		
		<cfreturn sqr(value)>
		
	</cffunction>
	
</cfcomponent>