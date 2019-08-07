$(document).on("click","span.arrow-button",function(event){
    var el = event.target;
    var master = $(el).closest(".arrow-button-group");
    
    var newVal = $(el).attr("value").split(",").map(function(x){
        return(+x);
    });
    var oldVal = master.data("val");
    var out = [];
    for(var i=0;i<2;i++){
      out.push(oldVal[i] + newVal[i]);
    }
    master.data("val",out);
    master.trigger("change");
    event.preventDefault();
    // console.log(master.data("val"));
});


var arrowButtonGroupInputBinding = new Shiny.InputBinding();

$.extend(arrowButtonGroupInputBinding, {
  find: function(scope) {
    return $(scope).find(".arrow-button-group");
  },
  initialize: function(el){
    var origin = $(el).attr("origin").split(",").map(function(x){return parseInt(x)});
    $(el).data("val",origin);
  },
  
  getValue: function(el) {
    var result = $(el).data("val").map(function(e){return parseInt(e)});
    if($(el).attr("type") === "a"){
      return result;
    } else {
      return result[0] + result[1];
    }
  },
  subscribe: function(el, callback) {
    $(el).on("change.arrowButtonGroupInputBinding", function(e) {
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off(".arrowButtonGroupInputBinding");
  }
  
});

Shiny.inputBindings.register(arrowButtonGroupInputBinding,'shiny.arrowButtonGroupInput');
