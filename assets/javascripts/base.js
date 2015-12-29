(function() {
  'use strict';

  function params() {
    var qs;

    qs = location.search.substring(1);

    if (!qs.length) {
      return {};
    }

    return qs.split('&').reduce(function(memo, pair) {
      var ref, k, v;

      ref = pair.split('=');
      k = ref[0];
      v = ref[1];
      memo[k] = decodeURIComponent(v);
      return memo;
    }, {});
  };

  function encode(val) {
    var encoded, options;
    options = params();
    encoded = 'text=' + encodeURIComponent(val.replace(/\n/g, ' '));
    if (options.type) encoded = encoded + '&type=' + options.type;
    return encoded;
  };

  function init() {
    var $audio, $controls, $form, $input, $progress, $source, $submit, options;

    options = params();
    $form = $('.js-form');
    $audio = $('.js-audio');
    $submit = $('.js-submit');
    $source = $('.js-source');
    $input = $('.js-input');
    $controls = $('.js-controls');
    $progress = $('.js-progress');

    options.input && $input.val(options.input);

    $input.on('keydown', function(e) {
      if (e.keyCode === 13 && e.metaKey) $form.submit();
    });

    $form.on('submit', function(e) {
      var val;

      e.preventDefault();

      val = $input.val();

      if (val === '') {
        $input.focus();
        return;
      };

      $source.attr('src', '/render?' + encode(val));
      $audio[0].load();
      $audio[0].play();
    });

    var wait;

    function status(to, reset, length) {
      $submit.text(to);

      if (reset) return setTimeout(function() {
        $submit.text(reset);
      }, length);
    };

    function progress(duration) {
      if (duration) {
        $progress.css({
          width: '100%',
          transition: 'width ' + duration + 's'
        });
      } else {
        $progress.css({
          width: '0%',
          transition: 'none'
        });
      }
    };

    $audio
      .on('playing', function() {
        status('Playing');
        clearInterval(wait);
      })
      .on('waiting', function() {
        status('Wait');
      })
      .on('suspend', function() {
        wait = status('Wait', 'Error', 2000);
      })
      .on('error', function() {
        status('Error');
      })
      .on('loadedmetadata', function(e) {
        progress($audio[0].duration);
      })
      .on('ended', function(e) {
        status('Play');
        progress();
        $input.focus();
      });
  };

  $(init);
}());
