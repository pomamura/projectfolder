urls = []
#YOUTUBE/ニコ動などのURLを入力する。
urls.push("")

urls.each {|url|
	puts url
	system("youtube-dl -t #{url}")
}