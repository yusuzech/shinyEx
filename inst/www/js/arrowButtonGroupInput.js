// step i
var binding = new Shiny.InputBinding();

// step ii
$.extend(binding, {

  find: function(scope) {
    return $(scope).find(".arrow-button")
  },

  initialize: function(el){
    ...
  },
  
  getValue: function(el) {  
    ...
  },

  subscribe: function(el, callback) {   
    ...
  }
  
});

// step iii
Shiny.inputBindings.register(binding);