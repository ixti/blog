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

    toto "an article was created for you at:", "\e[32m#{post_path}\e[0m",
  else
    toto "I can't create the article:",
         "\e[33m#{post_path}\e[0m",
         "\e[31mPath already exists.\e[0m"
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


def article_date article
  d, m, y = article.date.split "/"
  Time.new(y, m, d)
end

desc "Rebuild sitemap"
task :sitemap do
  articles = Toto::Site.new($config).archives.delete(:archives)

  xml = Builder::XmlMarkup.new(:indent => 2)
  xml.urlset "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9" do
    xml.url do
      xml.loc BLOG_URL
      xml.lastmod article_date(articles.first).strftime '%Y-%m-%d'
      xml.changefreq "weekly"
      xml.priority 0.8
    end

    archived = Time.new - (365 * 24 * 60 * 60)

    articles.each do |article|
      date = article_date(article)
      xml.url do
        xml.loc "#{BLOG_URL}#{article.path.slice(1..-1)}"
        xml.lastmod date.strftime '%Y-%m-%d'
        xml.changefreq (date < archived) ? "never" : "monthly"
      end
    end
  end

  File.open "sitemap.xml", "w+" do |f|
    f.puts xml.target!
  end
end

def toto *msgs
  puts "\n\n"
  puts "  toto says:"
  puts "  ~"
  msgs.each{ |msg| puts "  #{msg}" }
  puts "\n\n"
end

def ask message
  print message
  STDIN.gets.chomp
end
