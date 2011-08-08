;(function ($) {
  $(function () {
    $('pre code').each(function () {
      var $this = $(this);
      $this.addClass('language-' + $this.parent().attr('lang'));
      hljs.highlightBlock(this, '    ');
    });
  });
})(jQuery);
// vim:ts=2:sw=2
