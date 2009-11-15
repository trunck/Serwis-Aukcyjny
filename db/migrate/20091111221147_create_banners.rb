class CreateBanners < ActiveRecord::Migration
  def self.up
    create_table :banners do |t|
      t.string :url
      t.integer :pagerank
      t.integer :users_daily
      t.integer :width, :null=> false
      t.integer :height, :null=> false
      t.integer :x_pos, :null=> false
      t.integer :y_pos, :null=> false
      t.references :auction
      t.timestamps
    end
  end

  def self.down
    drop_table :banners
  end
end
