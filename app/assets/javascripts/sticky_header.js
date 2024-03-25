var ready;

ready = function() {
  $(".main-container").on("scroll", function() {
    pinHeader();
  });

  var header = $(".container-header");
  var headerH = header.outerHeight();
  var body = $(".container-body");
  var parentWidth = header.width();
  var sticky = header.offset().top;

  function pinHeader() {
    if ($(".main-container").scrollTop() > sticky) {
      header.addClass("sticky");
      header.width(parentWidth);
      body.css("padding-top", headerH);
    } else {
      header.removeClass("sticky");
      header.removeAttr("style");
      body.removeAttr("style");
    }
  }
};

$(document).ready(ready);
$(document).on('page:load', ready);