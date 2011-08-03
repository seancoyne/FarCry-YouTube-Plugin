<cfcomponent output="false">

<cfscript>
/**
 * Gets the value of a variable in a query string.
 * 
 * @param query_string      The query string to examine. (Required)
 * @param this_var_name      The variable to look for. (Required)
 * @return Returns a string. 
 * @author Shawn Seley (shawnse@hotmail.com) 
 * @version 1, August 1, 2005 
 */
function queryStringGetVar(querystring, this_var_name){
    var re_found_struct = "";
    querystring = trim(querystring);
    
    re_found_struct = REFindNoCase("(^|[\?|&])#this_var_name#=([^\&]*)", querystring, 1, "true");
    // = re_found_struct.len & re_found_struct.pos
    
    if(arrayLen(re_found_struct.pos) gte 3) {
        if (re_found_struct.pos[3] GT 0) return urlDecode(mid(querystring, re_found_struct.pos[3], re_found_struct.len[3]));
        else return "";
    } else return "";
}
</cfscript>	
	  
  <cffunction name="abbreviate" access="public" returntype="string" output="false" hint="Abbreviates a given string to roughly the given length, stripping any tags, making sure the ending doesn't chop a word in two, and adding an ellipsis character at the end.">
    <cfargument name="string" type="string" required="true" />
    <cfargument name="len" type="numeric" required="false" default="450" />

    <cfscript>
      /**
      * Abbreviates a given string to roughly the given length, stripping any tags, making sure the ending doesn't chop a word in two, and adding an ellipsis character at the end.
      * Fix by Patrick McElhaney
      * v3 by Ken Fricklas kenf@accessnet.net, takes care of too many spaces in text.
      *
      * @param string      String to use. (Required)
      * @param len      Length to use. (Required)
      * @return Returns a string.
      * @author Gyrus (kenf@accessnet.netgyrus@norlonto.net)
      * @version 3, September 6, 2005
      */
      var newString = REReplace(string, "<[^>]*>", " ", "ALL");
      var lastSpace = 0;
      newString = REReplace(newString, " \s*", " ", "ALL");
      if (len(newString) gt len) {
        newString = left(newString, len-2);
        lastSpace = find(" ", reverse(newString));
        lastSpace = len(newString) - lastSpace;
        //newString = left(newString, lastSpace) & " &##8230;";
        newString = left(newString, lastSpace) & " ...";
      }    
   	  return newString;
    </cfscript>

  </cffunction>
  
  <cffunction name="XHTMLParagraphFormat" hint="Returns a XHTML compliant string wrapped with properly formatted paragraph tags." output="no">
    <cfargument name="inString" required="yes" type="string" />
    <cfargument name="inAttributeString" required="no" type="string" default="" />
	<cfargument name="bWrapInParentParagraphTag" required="false" type="boolean" default="false" />
    <cfscript>
			/**
			 * Returns a XHTML compliant string wrapped with properly formatted paragraph tags.
			 *
			 * @param string 	 String you want XHTML formatted.
			 * @param attributeString 	 Optional attributes to assign to all opening paragraph tags (i.e. style=""font-family: tahoma"").
			 * @return Returns a string.
			 * @author Jeff Howden (jeff@members.evolt.org)
			 * @version 1.2, March 30, 2005 (modified by Jeff Coughlin jeff@jeffcoughlin.com)
			 */
			  var attributeString = '';
			  var returnValue = '';
			  if(arguments.inAttributeString neq ''){
			    attributeString = ' ' & arguments.inAttributeString;
			  }
			  if(Len(Trim(inString))){
          returnValue = arguments.inString;
          if (arguments.bWrapInParentParagraphTag is true){ returnValue = '<p' & attributeString & '>' & returnValue; }
          returnValue = Replace(returnValue, Chr(13)&Chr(10)&Chr(13)&Chr(10), '</p><p' & attributeString & '>', 'ALL');
          returnValue = Replace(returnValue, Chr(10)&Chr(10), '</p><p' & attributeString & '>', 'ALL');
          returnValue = Replace(returnValue, Chr(13)&Chr(13), '</p><p' & attributeString & '>', 'ALL');
          returnValue = Replace(returnValue, Chr(13)&Chr(10), '<br />', 'ALL');
          returnValue = Replace(returnValue, Chr(10), '<br />', 'ALL');
          returnValue = Replace(returnValue, Chr(13), '<br />', 'ALL');
          if (arguments.bWrapInParentParagraphTag is true){ returnValue = returnValue & '</p>'; }
			  }
    </cfscript>

		<cfreturn returnValue />

  </cffunction>	
	
	<cfscript>
	/**
	 * Makes a row of a query into a structure.
	 * 
	 * @param query      The query to work with. 
	 * @param row      Row number to check. Defaults to row 1. 
	 * @return Returns a structure. 
	 * @author Nathan Dintenfass (nathan@changemedia.com) 
	 * @version 1, December 11, 2001 
	 */
	function queryRowToStruct(query){
	    //by default, do this to the first row of the query
	    var row = 1;
	    //a var for looping
	    var ii = 1;
	    //the cols to loop over
	    var cols = listToArray(query.columnList);
	    //the struct to return
	    var stReturn = structnew();
	    //if there is a second argument, use that for the row number
	    if(arrayLen(arguments) GT 1)
	        row = arguments[2];
	    //loop over the cols and build the struct from the query row    
	    for(ii = 1; ii lte arraylen(cols); ii = ii + 1){
	        stReturn[cols[ii]] = query[cols[ii]][row];
	    }        
	    //return the struct
	    return stReturn;
	}
	</cfscript>
	
</cfcomponent>