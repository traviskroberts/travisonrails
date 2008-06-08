class Post < ActiveRecord::Base
  has_and_belongs_to_many :tags
  has_many :comments, :dependent => :destroy
  has_many :approved_comments, :class_name => 'Comment', :conditions => 'approved=1'
	
	validates_presence_of :content, :title
end
