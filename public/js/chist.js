$("select#chat-format").chosen();

$("form[data-remote='true']").submit(function(event) {
  event.preventDefault();

  form = $(event.target);
  data = {};

  form.find("input").each(function(element) {
    data[$(this).attr('name')] = $(this).attr('value');
  });

  form.trigger($.Event("ajax:beforeSend"));

  $.ajax({
    url: form.attr("action"),
    method: form.attr("method"),
    data: data
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
  response = JSON.parse(event.response);
  if (response.favorite) {
    $(this).find(".fav-icon").removeClass('no-favorited').addClass('favorited');
  } else {
    $(this).find(".fav-icon").removeClass('favorited').addClass('no-favorited');
  }
  $(this).find("button.fav-icon").fadeTo(500, 1);
});

$("form.fav-form").on("ajax:error", function(event) {
  console.log("ON AJAX:ERROR");
  console.log(event);
});
