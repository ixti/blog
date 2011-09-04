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


module Rack
  class AppError
    def initialize(app, options={})
      @app = app
      @file = options[:file]
    end

    def call(env)
      @app.call(env)
    rescue StandardError, LoadError, SyntaxError => e
      env["rack.errors"].puts(dump_exception e)
      env["rack.errors"].flush

      if prefers_plain_text?(env)
        content_type = "text/plain"
        body = "Application Error\n"
      else
        content_type = "text/html"
        body = ::IO.readlines @file
      end

      [
        500,
        {
          "Content-Type" => content_type,
          "Content-Length" => Rack::Utils.bytesize(body.join).to_s
        },
        body
      ]
    end

    protected

    def prefers_plain_text?(env)
      env["HTTP_X_REQUESTED_WITH"] == "XMLHttpRequest" && (!env["HTTP_ACCEPT"] || !env["HTTP_ACCEPT"].include?("text/html"))
    end

    def dump_exception(exception)
      string = "#{exception.class}: #{exception.message}\n"
      string << exception.backtrace.map { |l| "\t#{l}" }.join("\n")
      string
    end
  end
end

# vim:ts=2:sw=2
