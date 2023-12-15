var ready;

ready = function() {
  $("#list, #grid").click(function(e) {
    e.preventDefault();
    var el = $(this);

    $.ajax({
      url: el.attr("href"),
      method: 'GET'
    }).done(function(data) {
      $(".order-container").removeClass("collapsed");
      $(".order-cards").removeAttr("style");
      $("#grid, #list, .main-container .hidden-scrollbar:first, .main-container .container-body").removeClass("active grid list");
      el.addClass("active");
      $(".main-container .hidden-scrollbar:first, .main-container .container-body").addClass(el.attr("id"));
    });
  });
};

$(document).ready(ready);
$(document).on('page:load', ready);