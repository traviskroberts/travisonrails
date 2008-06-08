# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def strip_chars(string='')
	  return '' if string.blank?
    string.gsub(' ','-').gsub(/[^a-z0-9\-]+/i, '')
	end
	
	def show_tags(object=nil)
	  return '' if object.nil?
	  output = ""
	  unless object.tags.empty?
			output << '<p class="tagged">Tagged: '
			object.tags.each do |tag|
			  output << link_to(tag.name, tagged_path(:name => strip_chars(tag.name), :page => nil))
  			output << ', ' unless object.tags.last==tag
			end
			output << '</p>'
		end
	end
end
