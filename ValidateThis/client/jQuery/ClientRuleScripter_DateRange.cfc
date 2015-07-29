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
* @file  ClientRuleScripter_DateRange.cfc
* @contributor  David Fairfield (david.fairfield@gmail.com)
* @name ClientRuleScripter_DateRange
* @extends AbstractClientRuleScripter
* @hint I am responsible for generating JS code for the past date validation.
* */

component{

	/**
	* I am responsible for generating the validation 'method' function for the client during fw initialization.
	* @access public
	* @returntype any
	* @output false
	* **/
		function generateInitScript(required string defaultMessage="The date entered must be in the range specified."){
			var theScript="";
			var theCondition="function(value,e,options) { return true; }";

			// JAVASCRIPT VALIDATION METHOD 
			savecontent variable="theCondition"{
			writeoutput('function(v,e,o){
				if (v==='') return true;
				var thedate = new Date(v);
				var ok = !/Invalid|NaN/.test(thedate);
				var start = new Date();
				var end = new Date();
				
				if(ok){
					if(o.from){
						start=new Date(o.from);
					}
					if(o.until){
						var end=new Date(o.until);
					}
					if(start!==end){
						ok=((start<=thedate)&&(thedate<=end));
					}
				}
				return ok;
			}');
			}

			return generateAddMethod(theCondition,arguments.defaultMessage);
		}

	/**
	* I am responsible for providing arguments needed to generate the failure message.
	* @access private
	* @returntype array
	* @output false
	* @parameters The parameters stored in the validation object.
	**/
		function getFailureArgs(required any parameters){
			var args = [arguments.parameters.from,arguments.parameters.until];
			return args;
			
		}

}

