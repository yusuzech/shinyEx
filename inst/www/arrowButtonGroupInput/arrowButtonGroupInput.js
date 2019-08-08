$(document).on("click","span.arrow-button",function(event){
    var el = event.target;
    var master = $(el).closest(".arrow-button-group");
    // update track
    // send direction
    var direction = $(el).attr("direction");
    master.data("val",direction);
    // update directions(count of each direction)
    var direction_val = master.data(direction);
    master.data(direction,direction_val + 1);
    // update track of total clicks
    var track_val = master.data("track");
    master.data("track",track_val + 1);
    
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
    $(el).data("up",0);
    $(el).data("left",0);
    $(el).data("down",0);
    $(el).data("right",0);
    $(el).data("track",0);
  },
  getValue: function(el) {
    // since observe doesn't respond to the same value, we can't just get direction
    // we need to append another value(count of total clicks) in order to make the
    // value different
    if($(el).data("track") === 0){
      out = null;
    } else {
      var direction = $(el).data("val");
      var direction_val = $(el).data(direction);
      out = direction + ":" + direction_val; 
    }
    return out;
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
