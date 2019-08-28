// step i
var arrowButtonGroupInputBinding = new Shiny.InputBinding();

// step ii
$.extend(arrowButtonGroupInputBinding, {

  find: function(scope) {
    return $(scope).find(".arrow-button")
  },
  
  getValue: function(el) {
    return($(el).text())
  },

  subscribe: function(el, callback) {   
    $(el).on('click',function(event){
      callback();
    })
  },
  unsubscribe: function(el) {
    $(el).off('.arrow-button');
  }
});

// step iii
Shiny.inputBindings.register(arrowButtonGroupInputBinding,"shiny.arrowButtonGroupInput");