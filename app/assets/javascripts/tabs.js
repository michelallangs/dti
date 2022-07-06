var ready;

ready = function() {
  $(".btn-data").on("click", function(){
    var orderData = $(this).attr("order-data");
    var i;
    var x = document.getElementsByClassName("order-data");

    for (i = 0; i < x.length; i++) {
      $(".btn-data").removeClass("current");
      $(".order-data").removeClass("current");
      x[i].style.display = "none";
    }
    
    $("#" + orderData).addClass("current").fadeIn();
    $(this).addClass("current");
  })
};

$(document).ready(ready);
$(document).on('page:load', ready);

