class Comment < ActiveRecord::Base
  belongs_to :post
  
  validates_presence_of :name, :content
  
  def post_title
    self.post.title
  end
end
