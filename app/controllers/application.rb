# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery
  
	# --------------------------------------------------------------------
	protected
		def handle_tags(params='')
      return nil if params.blank?
      tags = params.split(",")
      tags.each { |x| x.strip! }
      tags.each { |x| x.downcase! }
      tags
    end

    def save_tags(tag_params, object)
      tags = handle_tags(tag_params) if tag_params
      # save off the tags
  		object.tags = []
  		if tags
  		  tags.each do |t|
  		    Tag.find_by_name(t) ? object.tags << Tag.find_by_name(t) : object.tags << Tag.create(:name => t.gsub(/[^a-z0-9 ]+/i, ''))
  	    end
  	  end
    end
    
    def get_tags(object)
      return '' if object.nil?
      @tags = object.tags.collect { |t| t.name }
    end
end
