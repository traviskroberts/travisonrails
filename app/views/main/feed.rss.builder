xml.instruct! :xml, :version => '1.0'
xml.rss "version" => "2.0" do
	xml.channel do
		xml.title 'Travis on Rails'
		xml.description 'Recent Posts'
		xml.link post_rss_url(:format => 'rss')
		
		@posts.each do |post|
			xml.item do
				xml.title post.title
				xml.description post.content
				xml.pubDate post.date.to_time.to_s(:rfc822)
				xml.link date_url(:year => post.date.year, :month => post.date.strftime("%m"), :day => post.date.strftime("%d"), :title => strip_chars(post.title))
			end
		end
	end
end