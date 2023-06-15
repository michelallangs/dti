//= require tinymce
//= require jquery3
//= require popper
//= require bootstrap
//= require jquery.turbolinks
//= require jquery_ujs
//= require jquery-ui/widgets/autocomplete
//= require autocomplete-rails
//= require bootstrap-datepicker
//= require chartkick
//= require Chart.bundle
//= require chosen-jquery

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
    $(this).siblings("ul").stop().toggle();

    $(this).parents(".order-card").stop().toggleClass("focused")
  });

  $(document).on("click", function(){
    $(".main-sidebar").removeClass("visible");
    $(".options-btn").siblings("ul").hide();
    $(".order-card").removeClass("focused");
    var radio = $("input.radio_buttons:checked");
    $("input.radio_buttons").parent().removeClass("checked");

    radio.parent().addClass("checked");
  });

  $(".filters .select-items div").on("click", function(){
    $(this).parents(".form").submit();
  })

  $(".menu-icon").on("click", function(e){
    e.stopPropagation();

    $(".main-sidebar").addClass("visible");
  })

  $(".enable-filters").on("click", function(){
    $(this).stop().toggleClass("filter-on");
    $(".filters").stop().fadeToggle(300);
  })

  $(".search input").each((i, e) => {
    if ($(e).val() != "") {
      $(".enable-filters").stop().addClass("filter-on");
      $(".filters").stop().show();
    }
  })

  $(".custom-select select option:selected").each((i, e) => { 
    if ($(e).index() != 0) {
      $(".filters").stop().show();
    }
  })
};

$(document).ready(ready);
$(document).on('page:load', ready);

//= require turbolinks
