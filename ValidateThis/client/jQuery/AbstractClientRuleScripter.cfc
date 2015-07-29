/**
*	Copyright 2008, Bob Silverberg
*	
*	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
*	compliance with the License.  You may obtain a copy of the License at 
*	
*		http://www.apache.org/licenses/LICENSE-2.0
*	
*	Unless required by applicable law or agreed to in writing, software distributed under the License is 
*	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
*	implied.  See the License for the specific language governing permissions and limitations under the 
*	License.
* 
* @file  AbstractClientRuleScripter.cfc
* @contributor  David Fairfield (david.fairfield@sharp.com)
* @name AbstractClientRuleScripter
* @hint I am a base object which all concrete ClientRuleScripters extend.
* @output=false
* */

component{
	// ------------------------ PROPERTIES ------------------------ //
		property name="DefaultFailureMessage" type="string" default="";

	// ------------------------ CONSTRUCTOR ------------------------ //
	/**
	* I am responsible for building a new ClientRuleScripter
	* @access public
	* @returntype any
	* @output false
	**/
		function init( 
			required any Translator, 
			required any messageHelper, 
			required string defaultFailureMessagePrefix
		){
			variables.ValType = lcase(ListLast(getMetadata(this).name,"_"));
			variables.Translator = arguments.Translator;
			variables.messageHelper = arguments.messageHelper;
			variables.defaultFailureMessagePrefix = arguments.defaultFailureMessagePrefix;

			return this;
		}
	// ------------------------ PUBLIC FUNCTIONS ------------------------ //
	/**
	* I am responsible for generating the JS addMethod script required to implement a validation.
	* @access public
	* @returntype any
	* @output false
	* @theMethod The JS method to use for the validator.
	**/
		function generateAddMethod(
			required any theMethod, 
			required string defaultmessage
		){
			var theScript = "";
			savecontent variable="theScript"{
			writeoutput('$.validator.addMethod("#getValType()#",#arguments.theMethod#,$.format("#arguments.defaultMessage#"))');
			};
			return trim(theScript);
		}

	/**
	* I am responsible for generating the JS Validation script required to implement a validation.
	* @access public
	* @returntype any
	* @output false
	* @validation The validation object that describes the validation.
	**/
		function generateValidationScript(
			required any validation, 
			required any locale, 
			required any formname
		){
			var safeSelectorScript = getSafeSelectorScript(argumentCollection=arguments);
			var theScript = generateRuleScript(validation=arguments.validation,locale=arguments.locale,selector=safeSelectorScript);
			return theScript;
		}

	/**
	* I am responsible for generating the JS Rule script required to implement a validation.
	* @access public
	* @returntype any
	* @output false
	* @validation The validation object that describes the validation.
	**/	
		function generateRuleScript(
			required any validation, 
			required any locale, 
			required any selector
		){
			return generateAddRule(argumentCollection=arguments);
		}
	
	/**
	* I am responsible for generating the JS Add Rule script required to implement a validation.
	* @access public
	* @returntype any
	* @output false
	* @validation The validation object that describes the validation.
	**/
		function generateAddRule(
			required any validation, 
			required any locale, 
			required any selector
		){
			var theScript = "";
			savecontent variable="theScript"{
				if(#arguments.selector#.length){
					writeoutput("#arguments.selector#.rules('add',#generateRuleStruct(argumentCollection=arguments)#)");
				}
			};
			return theScript;
		}

	/**
	* I am responsible for generating the JS JSON object required to implement the validations.
	* @access public
	* @returntype any
	* @output false
	* @validation The validation object that describes the validation.
	**/	
		function(
			required any validation, 
			required any locale, 
			required any formname
		){
			var theJSON = "";
			arguments.selector = getSafeSelectorScript(argumentCollection=arguments);
			theJSON = '{"#validation.getClientFieldName()#":#generateRuleStruct(argumentCollection=arguments)#}';
			return theJSON;
		}
	
	/**
	* I am responsible for generating the JSON object required to implement conditions for validations.
	* @access public
	* @returntype any
	* @output false
	* @validation The validation object that describes the validation.
	**/
		function generateConditionJSON(
			required any validation, 
			required any locale, 
			required any formname
		){
			var theConditions = {};
				//theCondition = '{"conditions": #getConditionDef(argumentCollection=arguments)#}';
				//theConditions["#arguments.formName#"]["#arguments.validation.getClientFieldName()#"]["#arguments.validation.getValType()#"] = deserializeJSON(conditionDef);
			return  serializeJSON(getConditionDef(argumentCollection=arguments));
		}

	/**
	* I am responsible for generating the JS Rule Struct script required to implement a validation.
	* @access public
	* @returntype any
	* @output false
	* @validation The validation object that describes the validation.
	**/
		function generateRuleStruct(
			required any validation, 
			required any locale, 
			required any selector
		){
			// Determine what failureMessage to use for this Validation 
			var parameters = arguments.validation.getParameters();
			var failureMessage = determineFailureMessage(arguments.validation,arguments.locale,parameters);
			var theStruct = "";
			
			var conditionDef = getConditionDef(argumentCollection=arguments)>
			var ruleDef = getRuleDef(arguments.validation,parameters);
			var messageDef = getMessageDef(failureMessage,getValType(),arguments.locale)/>
			
			if(len(ruleDef)) theStruct = "{#ruleDef##messageDef##conditionDef#}";

			return theStruct;
		}
	
	/**
	* I am responsible for returning just the rule definition which is required for the generateAddRule method.
	* @access public
	* @returntype any
	* @output false
	* @validation The validation object that describes the validation.
	* @parameters The parameters stored in the validation object.
	**/
		function getRuleDef(
			required any validation, 
			required any parameters
		){
			var parameterDef = getParameterDef(arguments.validation);
			var ruleDef = '"#getValType()#":#parameterDef#'};
			return ruleDef};
		}	
	
	/**
	* I am responsible for generating the JS script required to pass the appropriate paramters to the validator method.
	* @access public
	* @returntype any
	* @output false
	* @validation The validation object that describes the validation.
	**/
		function getParameterDef(required any validation){

			var parameterDef = "";
			var conditionDef = "";
			
			var paramName = "" ;
			var paramList = "" ;
			var parameters = {} ;

			if(arguments.validation.hasClientTest()){
				arguments.validation.addParameter("depends",arguments.validation.getConditionName())>
			}
			
			parameters = arguments.validation.getParameters();
			
			if(structCount(parameters)){
				if(structCount(parameters) EQ 1){
					paramName = structKeyArray(parameters) ;
					paramName = paramName[1] ;
					parameterDef = parameterDef & parameters[paramName] ;
				}else{
					parameterDef = serializeJSON(parameters);
				}
			}
			
			if(!len(parameterDef)){
				parameterDef &= '"true"' ;
			}
			
			return parameterDef;
		}

	/**
	* I am responsible for generating the JS script required to pass the appropriate depends conditions to the validator method.
	* @access public
	* @returntype any
	* @output false
	* @validation The validation object that describes the validation.
	**/
		function getConditionDef(any validation){
			var condition = arguments.validation.getCondition();
			var parameters = arguments.validation.getParameters();
			var conditionDef = "";
			if(arguments.validation.hasClientTest()){
				return  ',"conditions":{"#arguments.validation.getConditionName()#":"#arguments.validation.getClientTest()#"}';
			}else{
				return '';
			}
		}
	
	/**
	* I am responsible for generating the JS script required to display the appropriate failure message.
	* @access public
	* @returntype any
	* @output false
	**/
		function getMessageDef(
			string message=getGeneratedFailureMessage(), 
			string valType=getValType(), 
			string locale=""
		){
			var messageDef = "";
			var failureMessage = arguments.message;		
			if(len(failureMessage)){
				failureMessage = translate(failureMessage,arguments.locale);
				messageDef = ',"messages":{"#arguments.valType#":"#failureMessage#"}';
			}
			return messageDef;
		}

	// ------------------------ PRIVATE FUNCTIONS ------------------------ //

	/**
	* I am responsible for value type.
	* @access private
	* @returntype string
	* @output false
	**/
		function getValType(){
			return variables.ValType;
		}
	
	/**
	* I am responsible for generating the JS script required to select a property input element.
	* @access private
	* @returntype string
	* @output false
	**/
		function getSafeSelectorScript(any validation, string formname=''){
			var safeFieldName = arguments.validation.getClientFieldName();
			return "fm['#safeFieldName#']";
		}	
	
	/**
	* I am responsible for determining the actual failure message to be used.
	* @access private
	* @returntype any
	* @output false
	* @validation The validation object that describes the validation.
	* @locale The locale to use to generate the default failure message.
	* @parameters The parameters stored in the validation object.
	**/
		function determineFailureMessage(
			required any validation, 
			required string locale, 
			required any parameters
		){
			// Lets first try getCustomFailureMessage on either the AbstractClientRuleScripter or the CRS implementation 
			var failureMessage = getCustomFailureMessage(arguments.validation);

			// If we don't get anything there, lets go for getTheDefaultFailuremessage for this validation 
			if(!len(failureMessage)){
				<cfset failureMessage = getGeneratedFailureMessage(arguments.validation,arguments.locale,arguments.parameters);
			}
			
			return failureMessage;
		}
	
	/**
	* I am responsible for returning the custom failure message from the validation object.
	* @access private
	* @returntype any
	* @output false
	**/
		function getCustomFailureMessage(any validation){
			// If this validation a failureMessage from the metadata, then use that
			if(arguments.validation.hasFailureMessage()){
				return arguments.validation.getFailureMessage();
			}else{
				return "";
			}
		}
	
	/**
	* I am responsible for returning the generated failure message from the resource bundle for this CRS. Override me to customize further.
	* @access private
	* @returntype string
	* @output false
	* @validation The validation object that describes the validation.
	* @locale The locale to use to generate the default failure message.
	* @parameters The parameters stored in the validation object.
	**/
		function getGeneratedFailureMessage(
			required any validation, 
			required string locale, 
			required any parameters
		){
			// TODO: Here is where the failure message is being retrieved from the RB 
			var args = [arguments.validation.getPropertyDesc()];
				args.addAll(getFailureArgs(arguments.parameters));

			return variables.messageHelper.getGeneratedFailureMessage("defaultMessage_" & variables.ValType,args,arguments.locale);
		}


	/**
	* I am responsible for providing arguments needed to generate the failure message.
	* @access private
	* @returntype array
	* @output false
	* @validation The validation struct that describes the validation.
	**/
		function getFailureArgs(required any validation){
			return [];
		}

	/**
	* I am responsible for translating a message.
	* @access private
	* @returntype string
	* @output false
	**/
		function translate(
			string message="", 
			string locale=""
		){
			return  variables.Translator.translate(arguments.message,arguments.locale);
		}
}


