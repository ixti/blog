require 'bundler'
Bundler.require

use Rack::CommonLogger
use Rack::Static, { :urls => [ '/css', '/images', '/LICENSE', '/blank.htm',
                               '/favicon.ico', '/robots.txt' ],
                    :root => 'public' }
use Rack::Rewrite do
  r301 %r{^/feed$}, 'http://feeds.feedburner.com/ixti'
  r301 %r{^/(?:\?p=|archives/)3$}, '/2009/08/10/new-blog-born'
  r301 %r{^/(?:\?p=|archives/)6$}, '/2009/08/14/removing-adobe-flashplugin'
  r301 %r{^/(?:\?p=|archives/)16$}, '/2009/09/06/sending-faxes-with-hylafax-from-chrooted-apache'
  r301 %r{^/(?:\?p=|archives/)27$}, '/2009/09/06/painless-asterisk-call-file-handling'
  r301 %r{^/(?:\?p=|archives/)56$}, '/2009/09/08/execute-command-outside-chroot-without-leaving-it-part-1-idea'
  r301 %r{^/(?:\?p=|archives/)60$}, '/2009/09/17/execute-command-outside-chroot-without-leaving-it-part-2--first-coming'
  r301 %r{^/(?:\?p=|archives/)79$}, '/2009/10/01/execute-command-outside-chroot-without-leaving-it-part-3-final'
  r301 %r{^/(?:\?p=|archives/)84$}, '/2009/10/08/disallow-any-browser-cache-any-form-fielddata'
  r301 %r{^/(?:\?p=|archives/)98$}, '/2009/10/11/install-packages-from-deb-withapt'
  r301 %r{^/(?:\?p=|archives/)100$}, '/2009/10/18/running-xdebug-profiler-fromcli'
  r301 %r{^/(?:\?p=|archives/)105$}, '/2009/10/18/socket-reader-inphp'
  r301 %r{^/(?:\?p=|archives/)107$}, '/2009/10/22/socket-reader-in-php-second-part'
  r301 %r{^/(?:\?p=|archives/)116$}, '/2009/10/24/from-simple-socket-reader-to-server-inphp'
  r301 %r{^/(?:\?p=|archives/)132$}, '/2009/11/10/building-and-installing-asterisk-addons'
  r301 %r{^/(?:\?p=|archives/)141$}, '/2009/11/11/ready-steady-go'
  r301 %r{^/(?:\?p=|archives/)151$}, '/2009/11/17/logging-method-name-with-log4net'
  r301 %r{^/(?:\?p=|archives/)192$}, '/2009/12/27/simulating-protected-inner-classes-inphp'
  r301 %r{^/(?:\?p=|archives/)205$}, '/2009/12/26/hide-menu-bar-in-firefox'
  r301 %r{^/(?:\?p=|archives/)218$}, '/2009/12/27/open-urls-by-hot-keys-with-greasemonkey'
  r301 %r{^/(?:\?p=|archives/)236$}, '/2009/12/28/get-real-id-of-zendformsubforms-element'
  r301 %r{^/(?:\?p=|archives/)256$}, '/2010/01/01/bind-zendform-to-themodel'
  r301 %r{^/(?:\?p=|archives/)261$}, '/2010/01/07/bind-zendform-values-to-the-model-part-2-array-type-properties'
  r301 %r{^/(?:\?p=|archives/)263$}, '/2010/02/03/bind-model-to-the-zendform'
  r301 %r{^/(?:\?p=|archives/)276$}, '/2010/02/02/test-if-request-is-really-dispatchable-in-zend-framework'
  r301 %r{^/(?:\?p=|archives/)307$}, '/2010/03/02/get-bootstrap-resource-everywhere-across-your-zendapplication'
  r301 %r{^/(?:\?p=|archives/)320$}, '/2010/03/15/removing-bottom-ads-from-cre-pcice'
  r301 %r{^/(?:\?p=|archives/)343$}, '/2010/03/23/bring-freedom-back-to-cre-pcipro'
  r301 %r{^/(?:\?p=|archives/)361$}, '/2010/06/16/system-tray-icon-with-ruby-andgtk2'
  r301 %r{^/(?:\?p=|archives/)367$}, '/2010/06/23/system-tray-icon-with-ruby-andqt4'
  r301 %r{^/(?:\?p=|archives/)374$}, '/2010/05/17/dynamic-maxrange-for-jquerydatepick-plugin'
  r301 %r{^/(?:\?p=|archives/)407$}, '/2010/06/02/complex-mutators-for-doctrinev1x'
  r301 %r{^/(?:\?p=|archives/)417$}, '/2010/06/03/complex-mutators-for-doctrine-v1x-revisited'
  r301 %r{^/(?:\?p=|archives/)425$}, '/2010/06/08/multi-authentication-joomla-like-with-zend-framework'
  r301 %r{^/(?:\?p=|archives/)440$}, '/2010/06/08/another-step-for-freedom-of-cre-loaded-pcipro'
  r301 %r{^/(?:\?p=|archives/)565$}, '/2010/06/23/joomla-files-and-directories-to-ignore-on-versioning'
  r301 %r{^/(?:\?p=|archives/)573$}, '/2010/06/26/beware-of-phps-list-function'
  r301 %r{^/(?:\?p=|archives/)584$}, '/2010/07/10/adding-thousands-separators-to-a-number'
  r301 %r{^/(?:\?p=|archives/)597$}, '/2010/07/12/fast-debug-someone-elses-php-application'
  r301 %r{^/(?:\?p=|archives/)605$}, '/2010/07/18/qtip-v100-rc3-for-jquery-v142'
  r301 %r{^/(?:\?p=|archives/)615$}, '/2010/08/01/weechat-and-jabberpy'
  r301 %r{^/(?:\?p=|archives/)641$}, '/2010/09/03/translating-variable-strings-with-gettext-or-how-to-translate-doctrines-enums'
  r301 %r{^/(?:\?p=|archives/)664$}, '/2010/09/25/my-desktop-decorations'
  r301 %r{^/(?:\?p=|archives/)712$}, '/2010/10/18/take-control-over-window-appearance-with-devils-pie'
  r301 %r{^/(?:\?p=|archives/)724$}, '/2010/10/25/sudo-changes-in-debian-gnulinux-squeeze'
  r301 %r{^/(?:\?p=|archives/)737$}, '/2010/11/28/add-tags-to-the-issues-in-redmine-project-manager'
  r301 %r{^/(?:\?p=|archives/)790$}, '/2011/02/13/first-real-working-release-of-redminetags'
end

if ENV['RACK_ENV'] == 'development'
  use Rack::ShowExceptions
end


toto = Toto::Server.new do
  set :author,      "Aleksey V. Zapparov AKA ixti"
  set :title,       "ixti's personal sandbox"
  set :url,         "http://blog.ixti.ru"
  set :markdown,    [:gh_blockcode, :strikethrough, :fenced_code, :no_intraemphasis]
  set :disqus,      "ixti"
  set :cache,       24*60*60
end

run toto
