var ready;

ready = function() {
  $("body").on("click", ".menu-icon", function(e){
    e.stopPropagation();

    $(".main-sidebar").addClass("visible");
  })
};

$(document).ready(ready);
$(document).on('page:load', ready);