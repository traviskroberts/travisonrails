class Post < ActiveRecord::Base
  acts_as_url :title, :url_attribute => 'slug', :sync_url => true

  has_and_belongs_to_many :tags

  attr_accessible :content, :date, :title

  validates :content, :presence => true
  validates :date, :presence => true
  validates :title, :presence => true
end
