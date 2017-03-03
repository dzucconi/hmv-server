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

    if (options.shape) encoded = encoded + '&shape=' + options.shape;
    if (options.scalar) encoded = encoded + '&scalar=' + options.scalar;
    if (options.octave) encoded = encoded + '&octave=' + options.octave;
    if (options.pause) encoded = encoded + '&pause=' + options.pause;

    return encoded;
  };

  function init() {
    var options, $form, $input, $submit, $save, $delete, $progress, SOUND;

    options = params();

    $form = $('.js-form');
    $input = $('.js-input');
    $submit = $('.js-submit');
    $progress = $('.js-progress');
    $save = $('.js-save');
    $delete = $('.js-delete');

    options.input && $input.val(options.input);

    function status(to, reset, duration, cb) {
      $submit.text(to);

      if (reset) return setTimeout(function() {
        $submit.text(reset);
        if (cb) cb();
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
          status('Error', 'Play', 2000, function() {
            $input.val('');
          });
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

    $save.on('click', function(e) {
      e.preventDefault();

      const val = $input.val();

      if (val === '') {
        $input.focus();
        return;
      };

      const restore = $save.text();

      $save.text('Saving');

      $.post('/save', { text: val })
        .then(res => {
          $save.text('Saved');
          setTimeout(() => $save.text(restore), 2500);
        }, () => {
          $save.text('Error');
          setTimeout(() => $save.text(restore), 2500);
        });
    });

    $delete.on('click', function(e) {
      e.preventDefault();

      const $this = $(this);

      if (!confirm('Are you sure you want to continue?')) return false;

      $this.text('Deleting');

      $.post('/delete', { key: $this.data('key') })
        .then(() => location.reload());
    });
  };

  $(init);
}());
