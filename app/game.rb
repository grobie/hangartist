class Game < ActiveRecord::Base
  belongs_to :artist

  validates  :artist, :presence => true
  validates  :permalink, :presence => true

  before_validation :set_artist, :on => :create
  before_validation :set_permalink, :on => :create

  def set_permalink
    self.permalink ||= SecureRandom.hex(8)
  end

  def set_artist
    self.artist ||= Artist.create_random
  end

end
