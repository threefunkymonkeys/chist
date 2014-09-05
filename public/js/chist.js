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
    $(this).find(".fav-icon").removeClass('no-favorited').addClass('favorited');
  } else {
    $(this).find(".fav-icon").removeClass('favorited').addClass('no-favorited');
  }
  $(this).find("button.fav-icon").fadeTo(500, 1);
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
