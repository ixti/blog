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
  # Returns PNG image with QR Code.
  # "QR Code" is registered trademark of DENSO WAVE INCORPORATED
  #
  # Simple Example
  #
  #   use Rack::QRCode, {
  #     :path => '/qr.png',
  #     :data => lambda{ |req| req.referer }
  #   }
  class QRCode
    def initialize(app, options={})
      @app, @path, @data = app, options[:path], options[:data]

      @scale = options[:scale] || 2
      @allow = options[:allow] || lambda { |req, str| true }
    end

    def call(env)
      unless match_path?(env["PATH_INFO"]) and "GET" == env["REQUEST_METHOD"]
        @app.call(env)
      else 
        req = Request.new(env)
        str = @data.call(req)

        unless @allow.call(req, str)
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
          blob = qrcode(str, "PNG")
  
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
  
      blob = img.to_blob { self.format = format }
      img.destroy!
  
      blob
    end

    def match_path?(path)
      @path.is_a?(Regexp) ? @path.match(path.to_s) : @path == path.to_s
    end
  end
end

# vim:ts=2:sw=2
