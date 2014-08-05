
<cffunction name="printResults">
  <cfoutput>
  <table>
    <cfloop array="#results#" index="result">
      <tr>
        <td style="<cfif not result.success> background: red;</cfif>">"#result.data.a#" is<cfif not result.success> not</cfif> equal to "#result.data.b#"</td>
      </tr>
    </cfloop>
  </table>
  </cfoutput>
</cffunction>
<cfscript>

  results = [];

  function isEqual(required string a, required string b) {
    var res = {
      data = arguments,
      success = compare(a, b) == 0
    };
    arrayAppend(results, res);
  }

  function isBooleanEqual(required boolean a, required boolean b) {
    var res = {
      data = arguments,
      success = a == b
    };
    arrayAppend(results, res);
  }



  markdown = new Markdown();

  isEqual(markdown.toHTML('Hello *World*!'), '<p>Hello <em>World</em>!</p>');

  isEqual(markdown.toHTML('Hello `World`!'), '<p>Hello <code>World</code>!</p>');





  printResults();

</cfscript>