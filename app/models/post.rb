class Post < ActiveRecord::Base
  has_and_belongs_to_many :tags
  has_many :comments, :dependent => :destroy
  has_many :approved_comments, :class_name => 'Comment', :conditions => ["approved = ?", true]
  
  named_scope :featured, :conditions => ["featured = ?", true], :order => 'date DESC'
	
	validates_presence_of :content, :title
end
