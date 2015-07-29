
/**
*	
*	Copyright 2008, Adam Drew
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
*
* @file  ClientRuleScripter_FutureDate.cfc
* @contributor  David Fairfield (david.fairfield@gmail.com)
* @name  ClientRuleScripter_FutureDate
* @extends AbstractClientRuleScripter
* @hint I am responsible for generating JS code for the past date validation.
* */


component{

	/**
	* I am responsible for generating the validation 'method' function for the client during fw initialization.
	* @access public
	* @returntype any
	* @output false
	**/
		function generateInitScript(string defaultMessage="The date entered must be in the future."){
			var theCondition="function(value,element,options) { return true; }";
			
			// JAVASCRIPT VALIDATION METHOD
			savecontent variable="theCondition"{
				writeoutput('function(v,e,o){ 
					if(v===''){return true;}
					var dToday = new Date();
					var dValue = new Date(v);
					if(o.after){
						dToday = new Date(o.after);
					}
					return (dToday<dValue);
				}');
			}
			
			return generateAddMethod(theCondition,arguments.defaultMessage);
		}
	
	/**
	* I am responsible for overriding the parameter def because the VT param names do not match those expected by the jQuery plugin.
	* @access public
	* @returntype any
	* @output false
	* @validation The validation object that describes the validation.
	**/
		function getParameterDef(required any validation){
			var options = true />
			if(arguments.validation.hasParameter("after")){
				options = {};
				options["after"] = arguments.validation.getParameterValue("after");
			}
			return serializeJSON(options);
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
		any validation,
		required string locale,
		required any parameters
	){
		var args = [arguments.validation.getPropertyDesc()];
		var msgKey = "defaultMessage_FutureDate";
		var theDate = "";

		if(arguments.validation.hasParameter("after")){
			theDate = arguments.validation.getParameterValue("after");
			msgKey = "defaultMessage_FutureDate_WithAfter";
			arrayAppend(args,theDate);
		}
		return variables.messageHelper.getGeneratedFailureMessage(msgKey,args,arguments.locale);
	}

}
