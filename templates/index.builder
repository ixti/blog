BASEURL = "http://#{@config[:url].sub("http://", '')}/#{@config[:prefix]}/"

def fix html
  doc = Nokogiri::HTML(html)
  doc.xpath('//img').each do |img|
    src = img.attr('src')
    img.set_attribute('src', (BASEURL + src).squeeze('/')) if src =~ /^\/[^\/]/
  end
  doc.at('body').inner_html
end

xml.instruct!
xml.feed "xmlns" => "http://www.w3.org/2005/Atom", "xml:base" => @config[:url] do
  xml.title @config[:title]
  xml.id @config[:url]
  xml.updated articles.first[:date].iso8601 unless articles.empty?
  xml.author { xml.name @config[:author] }

  articles.reverse[0...10].each do |article|
    title = if article[:category].nil? or article[:category].empty? then article.title
            else "[#{article[:category]}] #{article.title}" end

    xml.entry do
      xml.title title
      xml.link "rel" => "alternate", "href" => article.url
      xml.id article['feed-id'.to_sym] || article.url
      xml.published article[:date].iso8601
      xml.updated article[:date].iso8601
      xml.author { xml.name @config[:author] }
      xml.summary fix(article.summary), "type" => "html"
      xml.content fix(article.body), "type" => "html"
    end
  end
end

