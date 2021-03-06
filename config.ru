require 'bundler'
Bundler.require


use Rack::CommonLogger
use Rack::Static, {
  :urls => %w{/css /images /js /blank.htm /favicon.ico /LICENSE /robots.txt},
  :root => 'public'
}


# handle exceptions
unless 'production' == ENV['RACK_ENV']
  use Rack::ShowExceptions
else
  require './lib/rack/app_error'
  use Rack::AppError, :file => 'public/500.html'
end


# qrcode middleware
begin
  Bundler.require :qrcode
  require './lib/rack/qrcode'

  use Rack::QRCode, {
    :path  => '/qr.png',
    :data  => lambda{ |req| req.referer.to_s },
    :allow => lambda{ |req, str| str.start_with? "#{req.env['rack.url_scheme']}://#{req.env['HTTP_HOST']}/" }
  }
rescue LoadError
  puts 'WARN: QR Code support disabled - bundler failed to load required gems.'
end


map "/bits" do
  run Rack::Directory.new 'bits'
end


map "/" do
  # toto extensions
  require './lib/toto'

  toto = Toto::Server.new do
    set :author,      "Aleksey V. Zapparov AKA ixti"
    set :title,       "ixti's personal sandbox"
    set :url,         "http://blog.ixti.net"
    set :markdown,    [:gh_blockcode, :strikethrough, :fenced_code, :no_intraemphasis]
    set :disqus,      "ixti"
    set :cache,       24*60*60
    set :ext,         "mkdown"
    set :error,       lambda { |code|
      code = 500 unless [400, 404, 500].include? code.to_i
      IO.read "public/#{code}.html"
    }
  end

  run toto
end


# vim:ts=2:sw=2
