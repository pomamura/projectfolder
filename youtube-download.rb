urls = []
#取得したい動画のURLを入力する。
urls.push("")

urls.each {|url|
	puts url
	system("youtube-dl -t #{url}")
}