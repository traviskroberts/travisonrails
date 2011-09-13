class ApplicationController < ActionController::Base
  protect_from_forgery
  helper :all # include all helpers, all the time

  helper_method :current_user

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
  
  private
    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    def current_user
      @current_user = current_user_session && current_user_session.record
    end
end
