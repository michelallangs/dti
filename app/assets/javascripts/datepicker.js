var ready;

ready = function() {
  $("#start_date").datepicker({
    container: '#start-date',                
    language: 'pt-BR',
    autoclose: true,
    clearBtn: true
  }).on("changeDate", function(){
    $(this).parents(".form").submit();
  });

  $("#end_date").datepicker({
    container: '#end-date',                
    language: 'pt-BR',
    autoclose: true,
    clearBtn: true
  }).on("changeDate", function(){
    $(this).parents(".form").submit();
  });
};

$(document).ready(ready);
$(document).on('page:load', ready);

