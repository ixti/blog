require 'fileutils'
require 'bundler'
Bundler.require

BLOG_URL = "http://blog.ixti.net/"

$config = Toto::Config::Defaults
$editor = ENV['EDITOR'] || ""

task :default => :new

desc "Create a new article."
task :new do
  title = ask('Title: ')
  slug = title.empty?? nil : title.strip.slugize

  article = {'title' => title, 'date' => Time.now.strftime("%d/%m/%Y")}.to_yaml
  article << "\n"
  article << "Once upon a time...\n\n"

  name = "#{Time.now.strftime("%Y-%m-%d")}#{'-' + slug if slug}"
  post_path = "#{Toto::Paths[:articles]}/#{name}.#{$config[:ext]}"
  bits_path = "bits/#{name}"

  unless File.exist? post_path
    File.open(post_path, "w") do |file|
      file.write article
    end

    if ask('With bits? ').upcase[0] == 'Y'
      FileUtils::mkdir_p bits_path
      File.open("#{bits_path}/descript.ion", "w") do |file|
        file.puts "Bits of #{title}"
      end

      toto "bits will be kept under #{bits_path}."
    end

    if !$editor.empty? && ask('Edit? ').upcase[0] == 'Y'
      system "#{$editor} #{post_path}"
    end

    toto "an article was created for you at #{post_path}."
  else
    toto "I can't create the article, #{post_path} already exists."
  end
end

if !$editor.empty?
  @articles_per_page = 9;

  desc "Edit artile."
  task :edit do
    articles = Dir["#{Toto::Paths[:articles]}/**/*"].select{|f| File.file? f}.sort_by{|f| File.basename f}.reverse!
  
    begin
      page = articles.slice!(0, @articles_per_page)
      page.each_with_index {|f, i| puts "%2d %s" % [i + 1, File.basename(f)]}

      puts "Enter number to edit, or nothing to skip to next page"
      id = ask "> "
    end while articles.count > 0 && id.empty?

    case
      when "Q" == id.upcase
        exit 0
      when id.empty?
        toto "no more articles"
        exit 0
      else
        id = id.to_i
        unless 0 < id && id < @articles_per_page
          toto "wrong article number"
          exit 1
        end
    end

    system "#{@editor} #{page[id - 1]}"
  end
end


desc "Rebuild sitemap"
task :sitemap do
  xml = Builder::XmlMarkup.new(:indent => 2)
  xml.urlset "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9" do
    xml.url do
      xml.loc BLOG_URL
      xml.lastmod "2005-01-01"
      xml.changefreq "weekly"
      xml.priority 0.8
    end

    archived = Time.new - (365 * 24 * 60 * 60)

    Toto::Site.new($config).archives.delete(:archives).each do |article|
      d, m, y = article.date.split "/"
      xml.url do
        xml.loc "#{BLOG_URL}#{article.path}".squeeze("/")
        xml.lastmod "#{y}-#{m}-#{d}"
        xml.changefreq (Time.new(y, m, d) < archived) ? "never" : "monthly"
      end
    end
  end

  File.open "sitemap.xml", "w+" do |f|
    f.puts xml.target!
  end
end

def toto msg
  puts "\n  toto ~ #{msg}\n\n"
end

def ask message
  print message
  STDIN.gets.chomp
end
