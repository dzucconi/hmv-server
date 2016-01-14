(function() {
  'use strict';

  function params() {
    var qs;

    qs = location.search.substring(1);

    if (!qs.length) return {};

    return qs.split('&').reduce(function(memo, pair) {
      var kv;

      kv = pair.split('=');
      memo[kv[0]] = decodeURIComponent(kv[1]);

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
    var options, $form, $input, $submit, $progress, SOUND;

    options = params();

    $form = $('.js-form');
    $input = $('.js-input');
    $submit = $('.js-submit');
    $progress = $('.js-progress');

    options.input && $input.val(options.input);

    function status(to, reset, duration) {
      $submit.text(to);

      if (reset) return setTimeout(function() {
        $submit.text(reset);
      }, duration);
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

    $input.on('keydown', function(e) {
      if (e.keyCode === 13 && e.metaKey) $form.submit();
    });

    $form.on('submit', function(e) {
      var val, src;

      e.preventDefault();

      val = $input.val();

      if (val === '') {
        $input.focus();
        return;
      };

      src = '/render.wav?' + encode(val);

      status('Wait');

      if (SOUND) SOUND.stop();

      SOUND = new Howl({
        src: [src],
        format: ['wav'],
        onloaderror: function() {
          status('Error');
        },
        onend: function() {
          status('Play');
          progress();
          $input.focus();
        },
        onplay: function() {
          status('Playing');
          progress(this.duration());
        }
      });

      SOUND.play();
    });

  };

  $(init);
}());
