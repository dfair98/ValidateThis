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
*
* @file  ClientRuleScripter_Integer.cfc
* @contributor  David Fairfield (david.fairfield@gmail.com)
* @name  ClientRuleScripter_Integer
* @extends AbstractClientRuleScripter
* @hint I am responsible for generating JS code for the integer validation.
* */

component{

	/**
	* I am responsible for generating the JS script required to display the appropriate failure message.
	* @access public
	* @returntype string
	* @output false
	**/
		function getMessageDef(
			string message=getGeneratedFailureMessage(),
			string valType=getValType(),
			string locale=''
		){
			return super.getMessageDef(arguments.message,"digits",arguments.locale)
		}

	/**
	* I am responsible for return just the rule definition which is required for the generateAddRule method.
	* @access private
	* @returntype any
	* @output false
	* @validation The validation struct that describes the validation.
	**/
		function getRuleDef(required any validation){
			return """digits"":""true""";
		}
}


