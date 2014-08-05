/**
 * @name JSExecutor
 * @displayname JavaScript in CF
 * @hint Run server-side JavaScript in Coldfusion
         By http://blog.atozofweb.com/2010/08/running-server-side-javascript-with-coldfusion-9/
 *
 * @output false
 * @accessors true
 */
component {

    property context;
    property scope;

    /**
     * @output false
     */
    public JSExecutor function init() {
                
        // Create and enter the runtime context of the executing script
        context = createObject('java', 'org.mozilla.javascript.Context').init().enter();
        
        // Maximum level of optimisation
        context.setOptimizationLevel(9);
        
        // Initialise standard objects (Object, Function) and get a scope object
        scope = variables.context.initStandardObjects();
        
        return this;
        
    }
    
    /**
     * @hint add in JavaScript from a file
     */
    public void function addScriptFromFile(required string path/* hint="The absolute path to your template."*/) {
        
        var jsFile = createObject("java", "java.io.File").init(arguments.path);
        if( jsFile.exists() ) {
            stream = createObject("java", "java.io.FileInputStream").init(jsfile);
            streamer = createObject("java", "java.io.InputStreamReader").init(stream);
            context.evaluateReader(
                scope, 
                streamer, 
                jsfile.getName(), 
                1, 
                javaCast('null', '')
            );
        } else {
            throw(message="The JavaScript file you specified does not exist.");
        }
        
        return;
        
    }
    
    /**
     * @hint add in JavaScript from a URL
     */
    public void function addScriptFromURL(required string path/* hint="The URL to retrieve."*/) {
        
        var jsfile = createObject("java", "java.net.URL").init(arguments.href);
        createObject("java", "java.io.InputStreamReader").init(
            jsfile.openConnection().getInputStream()
        );
        
        context.evaluateReader(
            scope, 
            streamer, 
            jsfile.getFile(), 
            1, 
            javaCast('null', '')
        );
        
    }
    
    /**
     * @hint add in JavaScript from a string
     */
    public void function addScript(required string code/* hint="JavaScript code."*/) {
        
        context.evaluateString(
            scope,
            arguments.code, 
            "inlineScript", 
            1, 
            javaCast('null', '')
        );
        
    }
    
    /**
     * @hint Call a JavaScript function
     */
    public any function callJSFunction(
        required string fname/* hint="JavaScript function name."*/,
        array args = arrayNew(1)/* hint="Array of JavaScript arguments to pass to the function"*/
    ) {
                
        var fn = scope.get(arguments.fname, variables.scope);
    
        var jsFunction = createObject('java', "org.mozilla.javascript.Function");
        var fnClass = jsFunction.getClass();
        var compiledFn = fnClass.cast(fn);
        
        return context.call(
            javaCast('null', ''), 
            compiledFn,
            scope, 
            scope, 
            arguments.args
        );
        
    }
    
    /**
     * @hint Let's see if we can be clever and use OnMissingMethod to make the syntax more JavaScript-y.
             Handles missing method exceptions.
     */
    public any function onMissingMethod(
        required string missingMethodName/* hint="The name of the missing method."*/,
        required struct missingMethodArguments/* hint="The arguments that were passed."*/
    ) {
    
        var args = [];
        var i_arg = "";
        var i = 1;
        
        for( i_arg in missingMethodArguments ) {
            args[i] = missingMethodArguments[i_arg];
            i++;
        }
        
        return callJSFunction(missingMethodName, args);
    
    }
    
    /**
     * @hint Cleanup - exit context
     */
    public void function exit() {
        context.exit();
    }
    
    
}