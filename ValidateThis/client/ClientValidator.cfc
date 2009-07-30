<!---
	
	Copyright 2008, Bob Silverberg
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
	
--->
<cfcomponent displayname="ClientValidator" output="false" hint="I generate client side validations from Business Object validations.">

	<cffunction name="init" access="Public" returntype="any" output="false" hint="I build a new ClientValidator">
		<cfargument name="FileSystem" type="any" required="true" />
		<cfargument name="ValidateThisConfig" type="any" required="true" />
		<cfargument name="Translator" type="any" required="true" />
		<cfset variables.FileSystem = arguments.FileSystem />
		<cfset variables.ValidateThisConfig = arguments.ValidateThisConfig />
		<cfset variables.Translator = arguments.Translator />
		<cfset variables.ScriptWriters = {} />

		<cfset setScriptWriters() />
		<cfreturn this />
	</cffunction>

	<cffunction name="getValidationScript" returntype="any" access="public" output="false" hint="I generate the JS script.">
		<cfargument name="Validations" type="any" required="true" />
		<cfargument name="formName" type="any" required="true" />
		<cfargument name="JSLib" type="any" required="true" />
		<cfargument name="locale" type="Any" required="no" default="" />

		<cfset var validation = "" />
		<cfset var theScript = "" />
		<cfset var theScriptWriter = variables.ScriptWriters[arguments.JSLib] />
		<cfsetting enableCFoutputOnly = "true">
		
		<cfif IsArray(arguments.Validations) and ArrayLen(arguments.Validations)>
			<!--- Loop through the validations array, generating the JS validation statements --->
			<cfsavecontent variable="theScript">
				<cfoutput>#Trim(theScriptWriter.generateScriptHeader(arguments.formName))#</cfoutput>
				<cfloop Array="#arguments.Validations#" index="validation">
					<!--- Generate the JS validation statements  --->
					<cfoutput>#Trim(theScriptWriter.generateValidationScript(validation,arguments.locale))#</cfoutput>
				</cfloop>
				<cfoutput>#Trim(theScriptWriter.generateScriptFooter())#</cfoutput>
			</cfsavecontent>
		</cfif>
		<cfsetting enableCFoutputOnly = "false">
		<cfreturn theScript />

	</cffunction>

	<cffunction name="getGeneratedJavaScript" returntype="any" access="public" output="false" hint="I ask the appropriate client script writer to generate some JS for me.">
		<cfargument name="scriptType" type="any" required="true" hint="Current valid values are Initialization, JSInclude, JSLocaleInclude and Setup." />
		<cfargument name="JSLib" type="any" required="true" />
		<cfargument name="formName" type="any" required="no" default="" />
		<cfargument name="locale" type="Any" required="no" default="" />

		<cfset var local = {jScript=""} />
		<cfif arguments.scriptType EQ "Initialization">
			<cfset arguments.scriptType = "JSInclude,JSLocaleInclude,Setup" />
		</cfif>
		<cfloop list="#arguments.scriptType#" index="local.theType">
			<cfinvoke component="#variables.ScriptWriters[arguments.JSLib]#" method="generate#local.theType#Script" argumentcollection="#arguments#" returnvariable="local.scriptlet" />
			<cfset local.jScript = local.jScript & local.scriptlet />
		</cfloop>
		<cfreturn local.jScript />

	</cffunction>
	
	<cffunction name="getScriptWriters" access="public" output="false" returntype="any">
		<cfreturn variables.ScriptWriters />
	</cffunction>
	
	<cffunction name="setScriptWriters" returntype="void" access="public" output="false">
		<cfset var theMeta = GetMetadata(this) />
		<cfset var thisName = ListLast(theMeta.Name,".") />
		<cfset var basePath = GetDirectoryFromPath(theMeta.Path) />
		<cfset var SWDirs = variables.FileSystem.listDirs(basePath) />
		<cfset var SWDir = 0 />
		<cfset var SWNames = 0 />
		<cfset var SW = 0 />
		<cfloop list="#SWDirs#" index="SWDir">
			<cfset SWNames = variables.FileSystem.listFiles(basePath & SWDir) />
			<cfloop list="#SWNames#" index="SW">
				<cfif ListLast(SW,".") EQ "cfc" AND SW CONTAINS "ClientScriptWriter_">
					<cfset variables.ScriptWriters[ReplaceNoCase(ListLast(SW,"_"),".cfc","")] = CreateObject("component",ReplaceNoCase(theMeta.Name,thisName,"") & "." & SWDir & "." & ReplaceNoCase(SW,".cfc","")).init(variables.FileSystem,variables.ValidateThisConfig,variables.Translator) />
				</cfif>
			</cfloop>
		</cfloop>
	</cffunction>
	<cffunction name="getScriptWriter" access="public" output="false" returntype="any">
		<cfargument name="JSLib" type="any" required="true" />
		<cfreturn variables.ScriptWriters[arguments.JSLib] />
	</cffunction>

</cfcomponent>

