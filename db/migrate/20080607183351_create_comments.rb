class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.integer :post_id
      t.date    :date
      t.string  :name
      t.text    :content
      t.boolean :approved, :default => false
      t.timestamps
    end
    
    add_index(:comments, :post_id)
  end

  def self.down
    drop_table :comments
  end
end
