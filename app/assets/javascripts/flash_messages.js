var ready;

ready = function() {
  $("body").on("click", ".flash .flash-close", function(e){
    e.stopPropagation();
    e.preventDefault();

    $(this).parent(".flash").fadeOut(300);
  })
};

$(document).ready(ready);
$(document).on('page:load', ready);