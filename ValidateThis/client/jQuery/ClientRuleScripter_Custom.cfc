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
* @file  ClientRuleScripter_Custom.cfc
* @contributor  David Fairfield (david.fairfield@gmail.com)
* @name ClientRuleScripter_remote
* @extends AbstractClientRuleScripter
* @hint I am responsible for generating JS code for the custom validation.
* 
* */

component{

	/**
	* I am responsible for generating  the JS script required to implement a validation.
	* @access public
	* @returntype any
	* @output false
	* @validation The validation struct that describes the validation.
	**/
		function generateRuleScript(
			required any valiation,
			required string locale,
			string selector=''
		){
		
	        if(arguments.validation.hasParameter('remoteURL')){
				return generateAddRule(argumentCollection=arguments);
			}
			
			return "";
		}

	/**
	* I am responsible for overriding the val type because jQuery uses the built-in 'remote' type for this.
	* @access public
	* @returntype any
	* @output false
	**/
		function getValType(){
			return 'remote';
		}

	/**
	* I am responsible for  overriding the parameter def because the VT param names do not match those expected by the jQuery plugin.
	* @access public
	* @returntype any
	* @output false
	*  @validation The validation struct that describes the validation.
	**/
		function getParameterDef(required any validation){
			return '"#arguments.validation.getParameterValue('remoteURL')#"';
		}
	
}


