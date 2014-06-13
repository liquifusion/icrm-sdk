<cfcomponent output="false">

	<cffunction name="init" access="public" output="false" returntype="any">
		<cfreturn this />
	</cffunction>

	<cffunction name="toQuery" access="public" output="false" returntype="query">
		<cfargument name="array" required="true" type="array" />
		<cfset var loc = StructNew() />
		
		<cfif ArrayIsEmpty(arguments.array) or not IsStruct(arguments.array[1])>
			<cfreturn QueryNew("empty") />
		</cfif>
		
		<cfset loc.length = ArrayLen(arguments.array) />
		<cfset loc.columns = getQueryColumnNames(arguments.array) />
		<cfset loc.columnLen = ArrayLen(loc.columns) />
		<cfset loc.columnsForQuery = [] />
		
		<cfloop index="loc.i" from="1" to="#loc.columnLen#">
			<cfset loc.workingColumn = rereplace(loc.columns[loc.i],"[!@##$%^&*()/+-]","_","all") />
			<cfset loc.workingColumn = rereplace(loc.workingColumn,"^_","custom_","one") />
			<cfset loc.workingColumn = rereplace(loc.workingColumn,"^(\d)","_\1","one") />
			<cfset loc.dump = arrayAppend(loc.columnsForQuery,loc.workingColumn) />
		</cfloop>
		
		<cfset loc.query = QueryNew(arrayToList(loc.ColumnsForQuery)) />

		
		<!--- add all of the row ahead of the loop --->
		<cfset loc.dump = QueryAddRow(loc.query, loc.length)>
		
		<cfloop index="loc.x" from="1" to="#loc.length#">
		
			<cfset loc.struct = arguments.array[loc.x] />
			
			<cfloop index="loc.y" from="1" to="#loc.columnLen#">
				<cfif StructKeyExists(loc.struct, loc.columns[loc.y])>
					<cfif IsBinary(loc.struct[loc.columns[loc.y]])>
						<cfset loc.struct[loc.columns[loc.y]] = ToBase64(loc.struct[loc.columns[loc.y]]) />
					</cfif>
					<cfset loc.dump = QuerySetCell(loc.query,loc.columnsForQuery[loc.y], loc.struct[loc.columns[loc.y]], loc.x) /> 
				</cfif>
			</cfloop>
		</cfloop>
		<cfreturn loc.query />
	</cffunction>
	
	<cffunction name="getQueryColumnNames" access="private" output="false" returntype="array">
		<cfargument name="array" required="true" />
		<cfset var loc = StructNew() />
		<cfset loc.array = arguments.array />
		<cfset loc.members = "" />
		<cfset loc.results = ArrayNew(1) />
		<cfset loc.resultsCounter = 1 />
		<cfset loc.x = "" />
		<cfset loc.y = "" />
		
		<cfloop index="loc.y" from="1" to="#ArrayLen(loc.array)#">
			<cfset loc.members = ListToArray(StructKeyList(loc.array[loc.y])) />
			
			<cfloop index="loc.x" from="1" to="#ArrayLen(loc.members)#">
				<cfif not ListFind(ArrayToList(loc.results), loc.members[loc.x])>
					<cfset loc.results[loc.resultsCounter] = Trim(loc.members[loc.x]) />
					<cfset loc.resultsCounter = loc.resultsCounter + 1 />
				</cfif>
			</cfloop>		
		</cfloop>

		<cfreturn loc.results />
	</cffunction>
	
</cfcomponent>

