//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require jquery-ui/widgets/autocomplete
//= require autocomplete-rails
//= require bootstrap-datepicker

//= require_tree .

var ready;

ready = function() {
  //fix data not loading on document ready
  setTimeout(function(){
    $(".main").click();
  }, 1)

  $(".input.boolean label").on("click", function(){
    $(this).find("input").is(":checked") ? $(this).addClass("checked") : $(this).removeClass("checked");
  });

  $("input, textarea").on("focus", function(){
    $(".form-label").removeClass("focused");
    $(this).parent().find(".form-label").addClass("focused");
  });

  $("input, textarea").on("focusout", function(){
    $(".form-label").removeClass("focused");
  });

  $(".options .options-btn").on("click", function(e){
    e.preventDefault();
    e.stopPropagation();

    $(".options .options-btn").not(this).siblings("ul").hide();
    $(this).siblings("ul").toggle();
  });

  $(document).on("click", function(){
    $(".options-btn").siblings("ul").hide();
    var radio = $("input.radio_buttons:checked");
    $("input.radio_buttons").parent().removeClass("checked");

    radio.parent().addClass("checked");
  });

  $(".btn-icon").on("click", function(){
    if ($(this).hasClass("as-grid")) {
      $(".order-cards").removeClass("as-list") ;
    }

    if ($(this).hasClass("as-list")) {
      $(".order-cards").addClass("as-list") ;
    }
  })

  $(".filters .select-items div").on("click", function(){
    $(this).parents(".form").submit();
  })

  $("#start_date").datepicker({
    container: '#start-date',                
    language: 'pt-BR',
    autoclose: true
  }).on("changeDate", function(){
    $(this).parents(".form").submit();
  });

  $("#end_date").datepicker({
    container: '#end-date',                
    language: 'pt-BR',
    autoclose: true
  }).on("changeDate", function(){
    $(this).parents(".form").submit();
  });
};

$(document).ready(ready);
$(document).on('page:load', ready);

//= require turbolinks
