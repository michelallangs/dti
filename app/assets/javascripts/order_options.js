var ready;

ready = function() {
  $("body").on("click", ".options .options-btn", function(e){
    e.preventDefault();
    e.stopPropagation();

    $(".options .options-btn").not(this).siblings("ul").hide();
    $(this).siblings("ul").stop().toggle();

    $(this).parents(".order-card").stop().toggleClass("focused")
  });
};

$(document).ready(ready);
$(document).on('page:load', ready);