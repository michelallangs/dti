var ready;

ready = function() {
  $(".main-container").on("scroll", function() {
    pinHeader();
  });

  var header = $(".container-header");
  var breadcrumbsH = $(".breadcrumbs").outerHeight()*3;
  var headerH = header.outerHeight();
  var body = $(".main-container");
  var parentWidth = header.width();
  var sticky = header.offset().top;

  function pinHeader() {
    if ($(".main-container").scrollTop() > sticky) {
      header.addClass("sticky");
      header.width(parentWidth);
      body.css("padding-top", headerH + breadcrumbsH);
    } else {
      header.removeClass("sticky");
      header.removeAttr("style");
      body.removeAttr("style");
    }
  }
};

$(document).ready(ready);
$(document).on('page:load', ready);