var ready;

ready = function() {
  setTimeout(function(){
    $(".loading").fadeOut();
  }, 700)
};

$(document).ready(ready);
$(document).on('page:load', ready);