class CreateRounds < ActiveRecord::Migration
  def self.up
    create_table :rounds do |t|
      t.integer :game_id
      t.string  :player, :state, :permalink
      t.integer :question_number, :null => false, :default => 1
      t.timestamps
    end
    add_index :rounds, :game_id
  end

  def self.down
    drop_table :rounds
  end
end
