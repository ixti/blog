require 'bundler'
Bundler.require


use Rack::CommonLogger
use Rack::Static, {
  :urls => %w{/css /images /js /blank.htm /favicon.ico /LICENSE /robots.txt},
  :root => 'public'
}


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
  set :markdown,    [:gh_blockcode, :strikethrough, :fenced_code, :no_intraemphasis]
  set :disqus,      "ixti"
  set :cache,       24*60*60
end

run toto
