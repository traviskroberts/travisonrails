class AddFeaturedToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :featured, :boolean, :default => false
  end

  def self.down
    remove_column :posts, :featured
  end
end
