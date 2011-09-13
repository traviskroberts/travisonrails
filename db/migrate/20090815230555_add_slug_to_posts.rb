class AddSlugToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :slug, :string

    # create slugs for existing posts
    Post.all.each do |post|
      post.update_attribute(:slug, post.title.gsub(/\s+/,'-').gsub(/[^a-z0-9\-]+/i, '').gsub(/[\-]+/,'-'))
    end
  end

  def self.down
    remove_column :posts, :slug
  end
end
