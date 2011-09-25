class Question < ActiveRecord::Base
  belongs_to :game

  validates :game, :presence => true

  before_create :generate
  before_create :set_number

  serialize :kind
  serialize :content

  KINDS = {
    :quote => [ :random_biography_sentence, :random_review_sentence ],
    :fact  => [ :years_active, :random_song ],
    :image => [ :random_image ],
    :track => [ :random_track ],
  }
  AVAILABLE_KINDS = {
    0..5          => [ :quote ],
    6..10         => [ :quote, :fact, :image ],
    11..999999999 => [ :quote, :fact, :image, :track ],
  }

  def artist
    game.artist
  end

  # :quote => [ :random_biography_sentence, :random_review_sentence ]
  # :fact  => [ :years_active, :random_track ]
  # :image => [ :random_image ]
  # :track => [ :random_track ]
  def generate
    while self.content.nil? || previous_questions.any? { |question| question.content == self.content }
      self.kind = choose_kind
      self.content = artist.send(KINDS[self.kind].sample)
    end
  end

  def choose_kind
    AVAILABLE_KINDS.each do |range, kinds|
      return kinds.sample if range === maximum_number
    end
  end

  def previous_questions
    self.class.where(:game_id => game)
  end

  def set_number
    self.number = maximum_number + 1
  end

  def maximum_number
    @maximum_number ||= self.class.where(:game_id => game).maximum(:number) || 0
  end

end
