/**
*	
*	Copyright 2010, Adam Drew
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
* @file  ClientRuleScripter_InList.cfc
* @contributor  David Fairfield (david.fairfield@gmail.com)
* @name ClientRuleScripter_InList
* @extends AbstractClientRuleScripter
* @hint I am responsible for generating JS code for the InList validation.
* */

component{

	/**
	* I am responsible for generating the validation 'method' function for the client during fw initialization.
	* @access public
	* @returntype any
	* @output false
	**/
		function generateInitScript(string defaultMessage="value was not found in list."){
			var theCondition="function(value,element,options) { return true; }";
			
			// JAVASCRIPT VALIDATION METHOD 
			savecontent variable="theCondition"{
			writeoutput('function(v,e,o){
				if(v===''){return true;}
				var delim = o.delim ? o.delim : ",";
				var lst = o.list.split(delim);
				var ok = false;
				$.each(lst, function(i,el){
					if (v.toLowerCase()==el.toLowerCase()){
						ok=true;
						return false;
					}
				});
				return ok;
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
			var options = true;
			if(arguments.validation.hasParameter("list")){
				options = {};
				options["list"] = arguments.validation.getParameterValue("list");
				if(arguments.validation.hasParameter("delim")){
					options['delim'] = arguments.validation.getParameterValue("delim",",");
				}
			}
			return serializeJSON(options);
		}

	/**
	* I am responsible for providing arguments needed to generate the failure message.
	* @access private
	* @returntype array
	* @output false
	* @parameters The parameters stored in the validation object.
	**/
		function getFailureArgs(required any parameters){
			var args = [""];
			if(structKeyExists(arguments.parameters,"list")){
				args = [arguments.parameters.list];
			}
			return args;
		}

}