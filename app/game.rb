require "aasm"

class Game < ActiveRecord::Base
  include AASM

  aasm_column :state
  aasm_initial_state :created
  aasm_state :created
  aasm_state :won
  aasm_state :lost

  aasm_event :right do
    transitions :from => [ :created ], :to => :won
  end

  aasm_event :wrong do
    transitions :from => [ :created ], :to => :lost
  end

  belongs_to :artist
  validates :artist, :presence => true
  before_validation :set_random_artist, :on => :create

  def set_random_artist
    self.artist ||= Artist.create_random
  end

end
