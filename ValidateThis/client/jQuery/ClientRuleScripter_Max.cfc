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
* @file  ClientRuleScripter_Max.cfc
* @contributor David Fairfield (david.fairfield@gmail.com)
* @name ClientRuleScripter_Max
* @extends AbstractClientRuleScripter
* @hint I am responsible for generating JS code for the max validation.
* */

component{

	/**
	* I am responsible for providing arguments needed to generate the failure message.
	* @access private
	* @returntype array
	* @output false
	* @parameters The parameters stored in the validation object.
	**/
	function getFailureArgs(required any parameters){
		var args = [arguments.parameters.max];
		return args;
		
	}
}



