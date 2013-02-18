$(document).ready(function() {
  var rnextImg = '#r_next img';
  var rarrow = 'rarrow.png';
  var rarrowHover = 'rarrow_hover.png';

  $('#r_next').hover(
    function() {
      var newSrc = $(rnextImg).attr('src').replace(rarrow, rarrowHover);
      $(rnextImg).attr('src', newSrc);
      $('#r_next span').addClass('pseudo_hover');
    },

    function() {
      var newSrc = $(rnextImg).attr('src').replace(rarrowHover, rarrow);
      $(rnextImg).attr('src', newSrc);
      $('#r_next span').removeClass('pseudo_hover');
    }
  );

  var lnextImg = '#l_next img';
  var larrow = 'larrow.png';
  var larrowHover = 'larrow_hover.png';

  $('#l_next').hover(
    function() {
      var newSrc = $(lnextImg).attr('src').replace(larrow, larrowHover);
      $(lnextImg).attr('src', newSrc);
      $('#l_next span').addClass('pseudo_hover');
    },

    function() {
      var newSrc = $(lnextImg).attr('src').replace(larrowHover, larrow);
      $(lnextImg).attr('src', newSrc);
      $('#l_next span').removeClass('pseudo_hover');
    }
  );
});
