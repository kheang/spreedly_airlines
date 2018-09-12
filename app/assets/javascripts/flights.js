$(document).ready(function() {
  $('input[type=radio][name=destination]').click(function () {
    $(':submit').prop('disabled', false);
    $('input[name=destination]').val($(this).val());
  });
});
