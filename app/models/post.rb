class Post < ActiveRecord::Base
  acts_as_url :title, :url_attribute => 'slug', :sync_url => true
  has_and_belongs_to_many :tags
  validates_presence_of :content, :title, :date
end
