require 'nokogiri'
require 'anemone'
require 'certified'

opts = {
  :depth_limit => 5,
}

urls = []
# キーワードを入力
search_term = URI.encode("")
url = "https://www.youtube.com/results?sp=CANIAOoDAA%253D%253D&q=#{search_term}"


Anemone.crawl(url, opts) do |anemone|
# 次にクロールするlinkを指定
anemone.focus_crawl do |page|
 page.links.keep_if { |link|
   link.to_s.match(/CANI[A-Z]ouOoDAA%253D%253D&q=#{search_term}/) # ここ正規表現。いまだと起点となるページから飛べるページの内、urlに/01/が含まれるページのみしかpageを回収しないよう予め指定しています。
 } 
end
anemone.on_every_page do |page|

doc = Nokogiri::HTML(open(url), nil,"UTF-8")
doc.xpath("//div[contains(@class, 'yt-lockup-dismissable yt-uix-tile')]").each do |node|
title = node.xpath("./div[contains(@class, 'yt-lockup-content')]/h3[contains(@class, 'yt-lockup-title ')]/a").text
html = node.css("a").attribute("href").value 
puts "<h4><a href='https://www.youtube.com#{html}' target='_blank' rel='nofollow'>#{title} 【提供元】 - YouTube</a>"
html = html.gsub(/\/watch\?v=/, '') 
puts "<a href='https://www.youtube.com/watch?v=#{html}' target='_blank' rel='nofollow'><img src='http://img.youtube.com/vi/#{html}/hqdefault.jpg'></a></h4>"
puts "<br>"
end
tuduki = page.url
puts  "<h4><a href='#{tuduki}' target='_blank' rel='nofollow'>"
puts "もっと見たい方はコチラへ"
puts "</a></h4>"
puts "<br>"
end
end
