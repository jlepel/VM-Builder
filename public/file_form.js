$(function() {
  var template = $("#file-selector").html();

  var removeFileFields = function(event) {
    $(event.currentTarget).parent().parent().remove();
  }

  var appendFileFields = function() {
    var html = $(template);
    html.find("[data-acts-as=file-remove-button]").click(removeFileFields);
    $("#file-selector").append(html);
  }

  $("#file-add-button").click(appendFileFields);
  $("[data-acts-as=file-remove-button]").click(removeFileFields);
});
