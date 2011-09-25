class Game < ActiveRecord::Base
  belongs_to :artist
  has_many :questions

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

  def question(number)
    questions.find_by_number(number) || questions.create
  end

end
