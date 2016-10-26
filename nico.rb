require 'nokogiri'
require 'anemone'
require 'certified'

opts = {
  :depth_limit => 5,
}

urls = []
# キーワードを入力
search_term = URI.encode("")
url = "http://www.nicovideo.jp/search/#{search_term}?f_range=0&l_range=0&opt_md="


Anemone.crawl(url, opts) do |anemone|
# 次にクロールするlinkを指定
anemone.focus_crawl do |page|
 page.links.keep_if { |link|
   link.to_s.match(/#{search_term}\?page=[1-9]&sort=h&order=d/) # ここ正規表現。いまだと起点となるページから飛べるページの内、urlに/01/が含まれるページのみしかpageを回収しないよう予め指定しています。
 } 
end
anemone.on_every_page do |page|

doc = Nokogiri::HTML(open(url), nil,"UTF-8")
doc.xpath("//li[contains(@class, 'item')]").each do |node|
title = node.xpath("./div[contains(@class, 'itemContent')]/p[contains(@class, 'itemTitle')]/a").text
puts title
html = node.xpath("//div[contains(@class, 'itemThumb')]/a").attribute("href").value
puts "<a href='http://www.nicovideo.jp/#{html}'>#{title}</a>"
puts "<br>"
img = node.xpath("//img[contains(@class, 'thumb')]").attribute("src").value
puts img
puts "<br>"
end
puts page.url
puts "<br>"
end
end
