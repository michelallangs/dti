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

  $(document).on("click", function(){
    $(".main-sidebar").removeClass("visible");
    $(".options-btn").siblings("ul").hide();
    $(".order-card").removeClass("focused");
    var radio = $("input.radio_buttons:checked");
    $("input.radio_buttons").parent().removeClass("checked");
    radio.parent().addClass("checked");
  });

  $(document).ajaxStart(function() {
    $(".spinner").stop().fadeIn('slow');
  }).ajaxStop(function() {
    $(".spinner").stop().hide();
  });
};

$(document).ready(ready);
$(document).on('page:load', ready);

//= require turbolinks
