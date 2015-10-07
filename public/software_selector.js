$(function() {
  console.log("asd");

  $("#addSelectionButton").click(function () {
    var items = $("#software-options option:selected");
    $("#software-selected").append(items);
  });

  $("#removeSelectionButton").click(function () {
    var items = $("#software-selected option:selected");
    $("#software-options").append(items);
  });
});
