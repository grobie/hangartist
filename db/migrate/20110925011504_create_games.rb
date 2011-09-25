class CreateGames < ActiveRecord::Migration
  def self.up
    create_table :games do |t|
      t.integer :artist_id
      t.string  :permalink
      t.timestamps
    end
    add_index :games, :artist_id
  end

  def self.down
    drop_table :games
  end
end
