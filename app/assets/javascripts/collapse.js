var ready;

ready = function() {
  $(".container-body.list").on("click", ".order-status-title", function(){
    $(".order-cards").not($(this).siblings(".order-cards")).hide();
    $(".order-container").not($(this).parents(".order-container")).removeClass("collapsed");
    $(this).parents(".order-container").toggleClass("collapsed");
    $(this).siblings(".order-cards").stop().slideToggle();
  });
};

$(document).ready(ready);
$(document).on('page:load', ready);