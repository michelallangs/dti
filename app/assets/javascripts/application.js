//= require tinymce
//= require jquery
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
//= require select2-full

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

  tinymce.init({
    selector: '.tinymce',  // change this value according to your HTML
    license_key: 'gpl',
    menubar: false,
    resize: false,
    branding: false,
    toolbar: "styleselect | bold italic underline | undo redo | aligncenter alignleft alignright | bullist numlist | table",
    plugins: "lists"
  });

  $(".select2-dropdown, .select2-dropdown-multiple").select2({
    language: { 
      "noResults": function(){
         return "Nenhum dado encontrado";
      }
    }   
  });
};

$(document).ready(ready);
$(document).on('page:load', ready);

//= require turbolinks
