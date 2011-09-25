require "aasm"

class Round < ActiveRecord::Base
  include AASM

  aasm_column :state
  aasm_initial_state :created
  aasm_state :created
  aasm_state :won
  aasm_state :lost

  aasm_event :right do
    transitions :from => [ :created ], :to => :won
  end

  aasm_event :give_up do
    transitions :from => [ :created ], :to => :lost
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

  def artist
    game.artist
  end

  # :quote => [ :random_biography_sentence, :random_review_sentence ]
  # :fact  => [ :years_active, :random_track ]
  # :image => [ :random_image ]
  # :track => [ :random_track ]
  def question
    types = {
      :quote => [ :random_biography_sentence, :random_review_sentence ],
      :fact  => [ :years_active, :random_song ],
      :image => [ :random_image ],
      :track => [ :random_track ],
    }
    type = types.keys.sample
    method = types[type].sample
    (value = artist.send(method)) ? [ type, value ] : question
  end

end
