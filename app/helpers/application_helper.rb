# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def strip_chars(string='')
	  return '' if string.blank?
    string.gsub(' ','-').gsub(/[^a-z0-9\-]+/i, '')
	end
end
