/**
 * @name Markdown
 * @hint Markdown-to-html in CF
 * @output false
 */
component {

  public Markdown function init() {
    var executor = new lib.JSExecutor();
    var dirname = getDirectoryFromPath(getCurrentTemplatePath());

    executor.addScript('
      window = {};
    ');
    executor.addScriptFromFile(dirname & '/vendor/markdown.js');
    executor.addScript('
      function toHTML() {
        return window.markdown.toHTML.apply(window.markdown, arguments);
      }
    ');

    variables.executor = executor;
    
    return this;
  }
  
  public string function toHTML(required string markdown) {
    return executor.toHTML(markdown);
  }

}