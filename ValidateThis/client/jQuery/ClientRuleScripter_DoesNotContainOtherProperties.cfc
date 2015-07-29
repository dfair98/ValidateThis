/**
* *
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
*
* @file  ClientRuleScripter_DoesNotContainOtherProperties.cfc
* @author  David Fairfield (david.fairfield@gmail.com)
* @name ClientRuleScripter_DoesNotContain
* @extends AbstractClientRuleScripter
* @hint "Fails if the validated property contains the value of another property
* */
/*
DoesNotContain:

	Definition Usage Example:

	<rule type='DoesNotContain' failuremessage='Password may not contain your first or last name.' >
		<param name='propertyNames' value='firstName,LastName'/>
	</rule>
	<rule type='DoesNotContain' failuremessage='Password may not contain your username.'>
		<param name='propertyNames' value='username' />
	</rule>
	<rule type='DoesNotContain' failuremessage='Password may not contain your email address.' >
		<param name='propertyNames' value='emailAddress'/>
	</rule>
	<rule type='DoesNotContain' failuremessage='This better be ignored!' >
		<param name='propertyNames' value'='thisPropertyDoesNotExist'/>
	</rule>
*/


component{

	/**
	* I am responsible for generating the validation 'method' function for the client during fw initialization.
	* @access public
	* @returntype any
	* @output false
	**/
		function generateInitScript(required string defaultMessage="The value cannot not contain the value of another property."){
			var theScript="";
			var theCondition="function(value,element,options) { return true; }";
			<!--- JAVASCRIPT VALIDATION METHOD --->
			savecontent variable="theCondition"{
			writeoutput('function(v,e,o){
				var ok=true;
				var $form=$(e).closest("form");
				$(o).each(function(){
					var propertyValue = $(':input[name='+this+']',$form).getValue();
					if(propertyValue.length){
						// if this is a mutiple select list, split the value into an array for iteration
						if(propertyValue.search(",")){
							propertyValue = propertyValue.split(",");
						}
						// for each property value in the array to check
						$(propertyValue).each(function(){
							var test = v.toString().toLowerCase().search(this.toString().toLowerCase())===-1;
							if (!test){ // Only worry about failures here so we return true if none of the other values fail.
								ok = false;
							}
						});
					}
					return ok;
				});
				return ok;
			}');
			}
				
			return generateAddMethod(theCondition,arguments.defaultMessage);
		}
	
	/** 
	* I am responsible for generating the JS script required to pass the appropriate parameters to the validator method.
	* @access public
	* @returntype string
	* @output false
	**/
		function getParameterDef(any validation){
			var params = arguments.validation.getParameters();
			return serializeJSON(listToArray(trim(params.propertyNames)));
		}
	
	/**
	* I am responsible for providing arguments needed to generate the failure message.
	* @access private
	* @returntype array
	* @output false
	* @parameters The parameters stored in the validation object.
	**/
	function getFailureArgs(required any parameters){
		var args = [arguments.parameters.propertyNames];
		return args;
	}


}