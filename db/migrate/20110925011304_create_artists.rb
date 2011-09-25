class CreateArtists < ActiveRecord::Migration
  def self.up
    create_table :artists do |t|
      t.string :eid, :name
    end
  end

  def self.down
    drop_table :artists
  end
end
