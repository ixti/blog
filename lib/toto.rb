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


# stdlib
require 'digest/sha1'


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

    def qrcode_img
      "/qr.png?cb=#{Digest::SHA1.hexdigest @env['REQUEST_URI']}"
    end

    def qrcode_enabled?
      defined? Rack::QRCode
    end

    def noindex!
      @noindex = true
    end

    def nofollow!
      @nofollow = true
    end

    def robots
      [] << (@noindex ? 'noindex' : 'index') << (@nofollow ? 'noindex' : 'follow')
    end
  end

  class Article
    def has_bits?() ::File.directory?(::File.join '.', bits_dir)        end
    def bits_dir()  "/bits/#{self[:date].strftime "%Y-%m-%d"}-#{slug}"  end
  end
end
