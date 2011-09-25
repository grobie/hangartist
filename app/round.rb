require "aasm"

class Round < ActiveRecord::Base
  include AASM

  aasm_column :state
  aasm_initial_state :active
  aasm_state :active
  aasm_state :won
  aasm_state :lost

  aasm_event :solve do
    transitions :from => :active, :to => :won
  end

  aasm_event :give_up do
    transitions :from => :active, :to => :lost
  end

  belongs_to :game

  validates :game, :presence => true
  validates :permalink, :presence => true

  before_validation :set_game, :on => :create
  before_validation :set_permalink, :on => :create

  before_create :set_player

  def set_game
    self.game ||= Game.create
  end

  def set_permalink
    self.permalink ||= SecureRandom.hex(8)
  end

  def set_player
    self.player ||= "Guest"
  end

  def artist_name
    game.artist.name
  end

  def question
    game.question(question_number)
  end

  def increment_question_number!
    update_attributes!(:question_number => question_number + 1)
  end

  def solved?(attempt)
    attempt == artist_name
  end

end
