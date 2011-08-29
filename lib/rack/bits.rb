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
  class Bits
    def initialize(app, options={})
      @app = app
    end

    def call(env)
      # pass to the next middleware
      @app.call(env)
    end
  end
end
