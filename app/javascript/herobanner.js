function animateHeadline($headlines) {
  var duration = animationDelay;
  $headlines.each(function () {
      var headline = $(this);

      if (headline.hasClass('loading-bar')) {
          duration = barAnimationDelay;
          setTimeout(function () {
              headline.find('.cd-words-wrapper').addClass('is-loading')
          }, barWaiting);
      } else if (headline.hasClass('clip')) {
          var spanWrapper = headline.find('.cd-words-wrapper'),
              newWidth = spanWrapper.width() + 10
          spanWrapper.css('width', newWidth);
      } else if (!headline.hasClass('type')) {
          //assign to .cd-words-wrapper the width of its longest word
          var words = headline.find('.cd-words-wrapper b'),
              width = 0;
          words.each(function () {
              var wordWidth = $(this).width();
              if (wordWidth > width) width = wordWidth;
          });
          headline.find('.cd-words-wrapper').css('width', width);
      };

      //trigger animation
      setTimeout(function () {
          hideWord(headline.find('.is-visible').eq(0))
      }, duration);
  });
}