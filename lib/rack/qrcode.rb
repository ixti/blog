# blog.ixti.ru, private scratchpad with public access
# 
# Copyright (c) 2011 Aleksey V Zapparov AKA ixti <ixti@member.fsf.org>
# 
# blog.ixti.ru is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# blog.ixti.ru is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with blog.ixti.ru.  If not, see <http://www.gnu.org/licenses/>.


# 3rd party libs
require 'rqrcode'
require 'RMagick'


module Rack
  # Returns PNG image with QR Code of referer URL.
  # "QR Code" is registered trademark of DENSO WAVE INCORPORATED
  class QRCode
    def initialize(app, options={})
      @app = app
      @path = options[:path] || '/qr.png'
      @scale = options[:scale] || 2
    end

    def call(env)
      unless @path == env["PATH_INFO"] and 'GET' == env['REQUEST_METHOD']
        @app.call(env)
      else 
        req = Request.new(env)
        unless allow? req
          [
            403,
            {
              "Content-Type" => "text/plain",
              "Content-Length" => "10",
              "X-Cascade" => "pass"
            },
            ["Forbidden\n"]
          ]
        else
          # prepare image data
          blob = qrcode(req.referer, 'PNG')
  
          [
            200,
            {
              "Content-Length" => blob.bytesize.to_s,
              "Content-Type" => Rack::Mime.mime_type(".png")
            },
            [blob]
          ]
        end
      end
    end

    private

    def qrcode(str, format)
      qr    = RQRCode::QRCode.new(str, :size => 10, :level => :l )
      size  = qr.modules.count * @scale
      img   = Magick::Image.new(size, size)
      
      # draw matrix
      qr.modules.each_index do |r|
        row = r * @scale
      
        qr.modules.each_index do |c|
          col = c * @scale
          dot = Magick::Draw.new
      
          dot.fill(qr.dark?(r, c) ? 'black' : 'white')
          dot.rectangle(col, row, col + @scale, row + @scale)
          dot.draw(img)
        end
      end
  
      data = img.to_blob { self.format = format }
      img.destroy!
  
      data
    end

    def allow?(req)
      valid = "#{req.env['rack.url_scheme']}://#{req.env['HTTP_HOST']}/"
      !req.referer.nil? and req.referer.start_with? valid
    end
  end
end

# vim:ts=2:sw=2
