var ready;

ready = function() {
  $(".tab-btn").on("click", function(){
    var data = $(this).attr("tab-data");
    var i;
    var x = document.getElementsByClassName("tab-data");

    for (i = 0; i < x.length; i++) {
      $(".tab-btn").removeClass("current");
      $(".tab-data").removeClass("current");
      x[i].style.display = "none";
    }
    
    $("#" + data).addClass("current").fadeIn(100);
    $(this).addClass("current");
  })
};

$(document).ready(ready);
$(document).on('page:load', ready);

