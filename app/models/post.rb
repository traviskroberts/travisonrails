class Post < ActiveRecord::Base
  acts_as_url :title, :url_attribute => 'slug', :sync_url => true
  
  has_and_belongs_to_many :tags
  has_many :comments, :dependent => :destroy
  has_many :approved_comments, :class_name => 'Comment', :conditions => ["approved = ?", true], :order => 'created_at DESC'
  
  named_scope :featured, :conditions => ["featured = ?", true], :order => 'date DESC'
	
	validates_presence_of :content, :title
end
