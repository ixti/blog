require 'bundler'
Bundler.require


use Rack::CommonLogger
use Rack::Static, {
  :urls => %w{/css /images /js /blank.htm /favicon.ico /LICENSE /robots.txt},
  :root => 'public'
}


begin
  Bundler.require :qrcode
  qrcode = '/qr.png'
  qrscale = 2

  # return PNG image with QR code of referrer
  use Rack::SimpleEndpoint, qrcode => :get do |req, res|
    # allow qr encoding from ourselves only
    unless req.referer.start_with? "#{req.env['rack.url_scheme']}://#{req.env['HTTP_HOST']}/"
      return :pass
    end

    qr    = RQRCode::QRCode.new(req.referer, :size => 10, :level => :l )
    size  = qr.modules.count * qrscale
    img   = Magick::Image.new(size, size)
    
    # draw matrix
    qr.modules.each_index do |r|
      row = r * qrscale
    
      qr.modules.each_index do |c|
        col = c * qrscale
        dot = Magick::Draw.new
    
        dot.fill(qr.dark?(r, c) ? 'black' : 'white')
        dot.rectangle(col, row, col + qrscale, row + qrscale)
        dot.draw(img)
      end
    end

    data = img.to_blob { self.format = 'PNG' }
    img.destroy!

    res['Content-Length'] = data.bytesize.to_s
    res['Content-Type']   = Rack::Mime.mime_type(".png")

    data
  end
rescue LoadError
  qrcode = false
end


if ENV['RACK_ENV'] == 'development'
  use Rack::ShowExceptions
end


module Toto
  module Template
    def extra_info date, category = nil, tags = nil
      info = "Date: #{date}"
      unless category.nil? or category.empty?
        info << " ~ Category: " << category
      end
      unless tags.nil? or tags.empty?
        info << " ~ Tags: " << tags.collect{|t| "<a href='#{t.path}'>#{t.title}</a>"}.join(', ')
      end
      info
    end
  end
end


toto = Toto::Server.new do
  set :author,      "Aleksey V. Zapparov AKA ixti"
  set :title,       "ixti's personal sandbox"
  set :url,         "http://blog.ixti.ru"
  set :qrcode,      qrcode
  set :markdown,    [:gh_blockcode, :strikethrough, :fenced_code, :no_intraemphasis]
  set :disqus,      "ixti"
  set :cache,       24*60*60
end

run toto
