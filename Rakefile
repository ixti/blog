require 'toto'
require 'fileutils'

@config = Toto::Config::Defaults
@editor = ENV['EDITOR'] || ""

task :default => :new

desc "Create a new article."
task :new do
  title = ask('Title: ')
  slug = title.empty?? nil : title.strip.slugize

  article = {'title' => title, 'date' => Time.now.strftime("%d/%m/%Y")}.to_yaml
  article << "\n"
  article << "Once upon a time...\n\n"

  name = "#{Time.now.strftime("%Y-%m-%d")}#{'-' + slug if slug}"
  post_path = "#{Toto::Paths[:articles]}/#{name}.#{@config[:ext]}"
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

    if !@editor.empty? && ask('Edit? ').upcase[0] == 'Y'
      system "#{@editor} #{post_path}"
    end

    toto "an article was created for you at #{post_path}."
  else
    toto "I can't create the article, #{post_path} already exists."
  end
end

if !@editor.empty?
  @articles_per_page = 9;

  desc "Edit artile."
  task :edit do
    articles = Dir.entries(Toto::Paths[:articles])
    
    articles.collect!{|f| "#{Toto::Paths[:articles]}/#{f}"}
    articles.select!{|f| File.file? f}
    articles.sort!.reverse!
  
    begin
      page = articles.slice!(0, @articles_per_page)
      page.each_with_index {|f, i| puts "%2d #{f}" % [i + 1]}

      puts "Enter number to edit, or nothing to skip to next page"
      id = ask "> "
    end while articles.count > 0 && id.empty?

    exit 0 if id.upcase == "Q"

    id = id.to_i
    unless 0 < id && id < @articles_per_page
      toto "wrong article number"
      exit 1
    end

    system "#{@editor} #{page[id - 1]}"
  end
end

def toto msg
  puts "\n  toto ~ #{msg}\n\n"
end

def ask message
  print message
  STDIN.gets.chomp
end

