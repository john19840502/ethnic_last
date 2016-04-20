$(document).on('ready', function() {
  $('#btn_meta_keywords').on('click', function() {
    $.ajax({
      type: "POST",
      url: $('#btn_meta_keywords').data('url'),
      data: {},
      dataType: "script"
    });
    return false;
  });

  $('#btn_meta_description').on('click', function() {
    $.ajax({
      type: "POST",
      url: $('#btn_meta_description').data('url'),
      data: {},
      dataType: "script"
    });
    return false;
  });
})
