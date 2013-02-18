$(document).on("click", "#tour", function(e) {
  bootbox.confirm($('#tour_dialog').html(), function(confirmed) {
    if (confirmed)
      console.log('START TOUR!!!');
  });
});

$(document).on("click", "#about", function(e) {
  bootbox.dialog($('#about_dialog').html(), function() {
  }, {header: 'About Pry Theme Editor'});
});
