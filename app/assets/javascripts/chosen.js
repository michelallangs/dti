var ready;

ready = function() {
  $('.chosen-select').chosen({
    no_results_text: "Nenhum dado encontrado"
  });
};

$(document).ready(ready);
$(document).on('page:load', ready);

