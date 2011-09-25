class CreateQuestions < ActiveRecord::Migration
  def self.up
    create_table :questions do |t|
      t.integer :game_id
      t.string  :kind
      t.text    :content
      t.integer :position
      t.timestamps
    end
    add_index :questions, :game_id
  end

  def self.down
    drop_table :questions
  end
end
