$("select#chat-format").chosen();

$("form[data-remote='true']").submit(function(event) {
  event.preventDefault();

  var form = $(event.target);
  var formData = {};

  form.find("input").each(function() {
    formData[$(this).attr('name')] = $(this).val();
  });

  var e = $.Event("ajax:beforeSend", {request: formData});

  form.trigger(e);

  $.ajax({
    url: form.attr("action"),
    method: form.attr("method") || "GET",
    data: formData
  })
    .done(function(response) {
      e = $.Event("ajax:done", {response: response});
      form.trigger(e);
    })
    .error(function(response) {
      form.trigger($.Event("ajax:error", {response: response}));
    });
});

$("form.fav-form").on("ajax:beforeSend", function(event) {
  $(event.target).find("button.fav-icon").fadeTo(500, 0.5);
});

$("form.fav-form").on("ajax:done", function(event) {
  var response = JSON.parse(event.response);
  if (response.favorite) {
    $(this).find(".fav-button").removeClass('no-favorited').addClass('favorited');
  } else {
    $(this).find(".fav-button").removeClass('favorited').addClass('no-favorited');
  }
  $(this).find("button.fav-button").fadeTo(500, 1);
});

$("form.fav-form").on("ajax:error", function(event) {
  console.log(event.response);
});

$("form#search-chist").on("ajax:beforeSend", function(event) {
  var url = "/search?query=" + event.request.query;

  history.pushState(null, "Search", url);
  sessionStorage.setItem("restoreLocation", 1);

  $("#search-box").blur();
});

$("form#search-chist").on("ajax:done", function(event) {
  $("#container").html(event.response);
});

window.addEventListener("popstate", function(event) {
  if (sessionStorage.restoreLocation) {
    sessionStorage.removeItem("restoreLocation");
    window.location = location.pathname;
  }
});

$("body").on('click', ".delete-button", function(event) {
  event.preventDefault();
  event.stopPropagation();
  var _this = $(this),
      action = _this.parent('form').attr('action');

  modal = $("#modal-chist-delete");
  modal.find('form').attr('action', action);
  modal.modal("show");
});

$("#delete-key-modal").on('show.bs.modal', function(event) {
  var button = $(event.relatedTarget);
  key_id = button.data('key-id');

  var modal = $(this);

  modal.find("#delete-form").attr("action", "/users/keys/" + key_id);
});

$('span.private_chist span').on('click', function() {
  var _this = $(this);
  if (_this.hasClass('private')){
      _this.removeClass('private').addClass('public').html('Public');
      $('#public_chist').val(1);
  } else {
      _this.removeClass('public').addClass('private').html('Private');
      $('#public_chist').val(0);
  }
});

$("body").on('click', '.btn-cancel',function(event) {
  window.history.back();
});

$('body').on('keyup', 'textarea.form-control',function(){
  var count = 0;
  if ($(this).val().length > 0){
    var count = $(this).val().split("\n").length;
  }
  var text = "Line";
  if (count > 1){
    text += "s";
  }
  $('span.lines').html(count+' '+text);
});