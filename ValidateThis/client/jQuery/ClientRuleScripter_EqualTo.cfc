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

/**
*	
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
* @file  ClientRuleScripter_EqualTo.cfc
* @contributor  David Fairfield (david.fairfield@gmail.com)
* @name ClientRuleScripter_equalTo
* @extends AbstractClientRuleScripter
* @hint I am responsible for generating JS code for the equalTo validation.
* */

component{

	/**
	* I am responsible for generating the validation 'method' function for the client during fw initialization.
	* @access public
	* @returntype any
	* @output false
	**/
		function generateInitScript(string defaultMessage="The value cannot not contain the value of another property."){

			// TODO: We can probably do away with the defaultMessage in here as it should never be used 
			<cfset var theScript="">
			<cfset var theCondition="function(value, element, param) {return true;}" />
			
			// JAVASCRIPT VALIDATION METHOD 
			savecontent variable="theCondition"{
			writeoutput('function(v,e,p){
				var $parentForm = $(e).closest("form");
				var $compareto = $(p,$parentForm);
				// bind to the blur event of the target in order to revalidate whenever the target field is updated
				// TODO find a way to bind the event just once, avoiding the unbind-rebind overhead
				var target = $compareto.unbind(".validate-equalTo").bind("blur.validate-equalTo",function(){
					$(e).valid();
				});
				return v==target.getValue();
			}');
			};
			
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
			var params = arguments.validation.getParameters();
			var compareFieldName = arguments.validation.getValidateThis().getClientFieldName(objectType=arguments.validation.getObjectType(),propertyName=params.ComparePropertyName);

			return """:input[name='#compareFieldName#']""";
		}

	/**
	* I am responsible for providing arguments needed to generate the failure message.
	* @access private
	* @returntype array
	* @output false
	* @parameters The parameters stored in the validation object.
	**/
		function getFailureArgs(required any parameters){
			var args = [variables.defaultFailureMessagePrefix,arguments.parameters.ComparePropertyDesc];
			return args;
		}
	

}
