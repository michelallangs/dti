var ready;

ready = function() {
  (function($) {
    $.fn.hasScrollBar = function() {
      return this.get(0).scrollHeight > this.height();
    }
  })(jQuery);

  var ordersGrid = $('#orders .container-body'),
      scrollbarContainer = $('#orders .hidden-scrollbar'),
      prevBtn = scrollbarContainer.find(".prev-btn"),
      nextBtn = scrollbarContainer.find(".next-btn");
  
  if (ordersGrid.length > 0) {
    if (ordersGrid.hasScrollBar() && !ordersGrid.hasClass("list")) {
      if (ordersGrid.scrollLeft() + ordersGrid.innerWidth() < ordersGrid[0].scrollWidth - 1) {
        nextBtn.fadeIn();
      }

      ordersGrid.on("scroll", function(){
        if (ordersGrid.scrollLeft() > 0) {
          prevBtn.fadeIn();
        }
        else {
          prevBtn.fadeOut();
        }

        if (ordersGrid.scrollLeft() + ordersGrid.innerWidth() >= ordersGrid[0].scrollWidth - 1) {
          nextBtn.fadeOut();
        }
        else {
          nextBtn.fadeIn();
        }
      })
    }

    prevBtn.on("click", function(){
      var scroll = ordersGrid.scrollLeft();

      ordersGrid.stop().animate({
        scrollLeft: scroll - 300
      }, 400)
    })

    nextBtn.on("click", function(){
      var scroll = ordersGrid.scrollLeft();
      ordersGrid.stop().animate({
        scrollLeft: scroll + 300
      }, 400)
    })
  }
};

$(document).ready(ready);
$(document).on('page:load', ready);
