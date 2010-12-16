<!---
	// **************************************** LICENSE INFO **************************************** \\
	
	Copyright 2010, Bob Silverberg
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
	
--->
<cfcomponent output="false">
	
	<cffunction name="init" access="public" returntype="any">
		<!--- get the current classloader --->
		<cfset var classLoader = getClass().getClassLoader() />
		<!--- load the class for java.lang.Object --->
		<cfset var objectClass = classLoader.loadClass("java.lang.Object") />
		<!--- get the equals method --->
		<cfset var arr = [objectClass] />
		<cfset variables.equalsMethod = objectClass.getMethod("equals", arr) />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="isEqual" access="public" returntype="boolean">
		<cfargument name="thing1" type="any" required="true" hint="One thing to compare" />
		<cfargument name="thing2" type="any" required="true" hint="Another thing to compare" />
		
		<cfset var thing2Array = [arguments.thing2] />
		<cfreturn variables.equalsMethod.invoke(arguments.thing1,thing2Array) />
	</cffunction>

	<cffunction name="isInArray" access="public" returntype="boolean">
		<cfargument name="theThing" type="any" required="true" hint="The thing that you want to check for in the array" />
		<cfargument name="thingArray" type="array" required="true" hint="An array of things to check" />
		
		<cfset var thing = 0 />
		<cfset var thingHolder = [] />
		<cfloop array="#arguments.thingArray#" index="thing">
			<cfset thingHolder[1] = thing />
			<cfif variables.equalsMethod.invoke(arguments.theThing,thingHolder)>
				<cfreturn true />
			</cfif>
		</cfloop>
		<cfreturn false />
	</cffunction>

</cfcomponent>
