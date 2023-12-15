var ready;

ready = function() {
  $("body").on("click", ".input.boolean label", function(){
    $(this).find("input").is(":checked") ? $(this).addClass("checked") : $(this).removeClass("checked");
  });

  $("input, textarea").on("focus", function(){
    $(".form-label").removeClass("focused");
    $(this).parent().find(".form-label").addClass("focused");
  });

  $("input, textarea").on("focusout", function(){
    $(".form-label").removeClass("focused");
  });

  $(".search input").each((i, e) => {
    if ($(e).val() != "") {
      $(".enable-filters").stop().addClass("filter-on");
      $(".filters").stop().show();
    }
  })

  $(".custom-select select option:selected").each((i, e) => { 
    if ($(e).index() != 0) {
      $(".enable-filters").stop().addClass("filter-on");
      $(".filters").stop().show();
    }
  })
};

$(document).ready(ready);
$(document).on('page:load', ready);