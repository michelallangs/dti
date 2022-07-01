//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs

//= require_tree .

var ready;

ready = function() {
  $(".input.boolean label").on("click", function(){
    $(this).find("input").is(":checked") ? $(this).addClass("checked") : $(this).removeClass("checked");
  });

  $("input, textarea, select").on("focus", function(){
    $(".form-label").removeClass("focused");
    $(this).parent().find(".form-label").addClass("focused");
  });

  $("input, textarea, select").on("focusout", function(){
    $(".form-label").removeClass("focused");
  });

  $(document).on("click", function(){
    var radio = $("input.radio_buttons:checked");
    $("input.radio_buttons").parent().removeClass("checked");

    radio.parent().addClass("checked");
  })
};

$(document).ready(ready);
$(document).on('page:load', ready);

//= require turbolinks
