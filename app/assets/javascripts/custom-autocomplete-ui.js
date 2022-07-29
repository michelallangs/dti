var ready;

ready = function() {
  var spots = [];
  var categories = [];
  var brands = [];

  $("#patrimony").on("autocompleteselect", function(event, ui) {
    $(this).val(ui.item.label);
    $(this).closest("form").submit();
  });

  //local de instalação
  $(".list_spots").each(function(){
    var item = $(this).html();

    spots.push(item);
  })

  $("#spot").autocomplete({
    source: spots,
    appendTo: $("#autocomplete-spot"),
    minLength: 2,
    select: function(event, ui) {
      $(this).val(ui.item.label);
      $(this).closest("form").submit();
      return false;
    }
  });

  //categoria
  $(".list_categories").each(function(){
    var item = $(this).html();

    categories.push(item);
  })

  $("#category").autocomplete({
    source: categories,
    appendTo: $("#autocomplete-category"),
    minLength: 2,
    select: function(event, ui) {
      $(this).val(ui.item.label);
      $(this).closest("form").submit();
      return false;
    }
  });

  //marca/modelo
  $(".list_brands").each(function(){
    var item = $(this).html();

    brands.push(item);
  })

  $("#brand").autocomplete({
    source: brands,
    appendTo: $("#autocomplete-brand"),
    minLength: 2,
    select: function(event, ui) {
      $(this).val(ui.item.label);
      $(this).closest("form").submit();
      return false;
    }
  });
};

$(document).ready(ready);
$(document).on('page:load', ready);

