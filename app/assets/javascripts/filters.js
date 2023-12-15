var ready;

ready = function() {
  $("body").on("click", ".filters .select-items div", function(){
    $(this).parents(".form").submit();
  })

  $("body").on("click", ".enable-filters", function(){
    $(this).stop().toggleClass("filter-on");
    $(".filters").stop().fadeToggle(300);
  })
};

$(document).ready(ready);
$(document).on('page:load', ready);