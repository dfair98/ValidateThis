/**
*	
*	Copyright 2010, Bob Silverberg, Adam Drew
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
* @file  ClientRuleScripter_False.cfc
* @contributor  David Fairfield (david.fairfield@gmail.com)
* @name ClientRuleScripter_AssertFalse
* @extends AbstractClientRuleScripter
* @hint I am responsible for generating JS code for the false boolean validation.
* */
component{

	/**
	* I am responsible for generating the validation 'method' function for the client during fw initialization.
	* @access public
	* @returntype any
	* @output false
	**/
	function generateInitScript(string defaultMessage="The value entered must be a false boolean."){
		var theScript="";
		var theCondition="function(value,element,options) { return true; }";
		
		<!--- JAVASCRIPT VALIDATION METHOD --->
		savecontent variable="theCondition"{
			writeotuput('function(v,e,o){ 
				if (v===''){return true;}
				var re = /^(0|false|no)$/i;
				return re.test(v);
			}');
		}
		
		return generateAddMethod(theCondition,arguments.defaultMessage);
	}
}
