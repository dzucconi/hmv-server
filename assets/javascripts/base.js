(function() {
  'use strict';

  function params() {
    var qs;

    qs = location.search.substring(1);

    if (!qs.length) {
      return {};
    }

    return qs.split('&').reduce(function(memo, pair) {
      var ref = pair.split('='),
        k = ref[0],
        v = ref[1];

      memo[k] = decodeURIComponent(v);
      return memo;
    }, {});
  };

  function encode(val) {
    return encodeURIComponent(val.replace(/\n/g, ' '));
  };

  function init() {
    var options = params();

    var $form = $('form'),
      $audio = $('audio'),
      $submit = $('#submit'),
      $source = $('#source'),
      $input = $('#input'),
      $controls = $('#controls'),
      $progress = $('#progress-bar');

    options.input && $input.val(options.input);

    $input.on('keydown', function(e) {
      if (e.keyCode === 13 && e.metaKey) $form.submit();
    });

    $form.on('submit', function(e) {
      e.preventDefault();

      var val = $input.val();

      if (val === '') {
        $input.focus();
        return;
      };

      $source.attr('src', '/render?text=' + encode(val));
      $audio[0].load();
      $audio[0].play();
    });

    $audio
      .on('playing', function() {
        $submit.text('Playing');
      })
      .on('waiting', function() {
        $submit.text('Wait');
      })
      .on('error suspend', function() {
        $submit.text('Error');
        setTimeout(function() {
          $submit.text('Play');
        }, 2000);
      })
      .on('loadedmetadata', function(e) {
        console.log(e)
        $progress
          .css('width', '100%')
          .animate({ width: 0 }, $audio[0].duration * 1000, 'linear');
      })
      .on('ended', function(e) {
        $submit.text('Play');
        $progress.css('width', '100%');
        $input.focus();
      });
  };

  $(init);
}());
