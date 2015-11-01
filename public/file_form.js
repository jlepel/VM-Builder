$(function() {
  var template = '<div class="form-inline">'
      +  '<div class="file-item">'
      +   '<div class="form-group col-sm-5">'
      +     '<input type="file" class="form-control" name="files[]file" id="file">'
      +    '</div>'
      +    '<div class="form-group col-sm-5">'
      +      '<label for="exampleInputEmail2">target</label>'
      +       '<input type="text" class="form-control" name="files[]path" placeholder="/usr/local" required>'
      +    '</div>'
      +    '<div class="form-group col-sm-2">'
      +      '<a class="btn btn-default" data-acts-as="file-remove-button">'
      +        '<span class="glyphicon glyphicon-minus" aria-hidden="true"></span>'
      +      '</a>'
      +    '</div>'
      +  '</div>'
      + '</div>';

  var removeFileFields = function(event) {
    $(event.currentTarget).parent().parent().remove();
  }

  var appendFileFields = function() {
    $("#file-selector").append(template);
  }

    $("#file-add-button").click(appendFileFields);
    $("#file-selector").on("click", "[data-acts-as=file-remove-button]", removeFileFields);


});
