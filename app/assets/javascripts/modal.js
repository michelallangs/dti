var ready;

ready = function() {
  $(document).on("click", ".modal__close", function(){
    $(this).parents(".modal-container").fadeOut();;
  })
};

$(document).ready(ready);
$(document).on('page:load', ready);