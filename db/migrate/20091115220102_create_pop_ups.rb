class CreatePopUps < ActiveRecord::Migration
  def self.up
    create_table :pop_ups do |t|
      
      t.timestamps
    end
  end

  def self.down
    drop_table :pop_ups
  end
end
