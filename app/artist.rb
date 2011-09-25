require "tactful_tokenizer"

class Artist < ActiveRecord::Base
  validates :eid, :presence => true
  validates :name, :presence => true
  before_validation :get_echonest_id, :on => :create

  def self.create_random
    (hot = Echonest::Artist.hot.sample) && create(:eid => hot.id, :name => hot.name)
  end

  def biographies
    Echonest::Artist.biographies(eid)
  end

  def random_biography_sentence
    random_sentence(biographies.sample)
  end

  def random_song
    song = Echonest::Artist.songs(eid).sample
    song && ["The artist created", song]
  end

  def random_track
    Echonest::Artist.tracks(eid).sample
  end

  def years_active
    years_active = Echonest::Artist.years_active(eid)
    years_active && ["Active since", years_active["start"]]
  end

  def reviews
    Echonest::Artist.reviews(eid)
  end

  def random_review_sentence
    random_sentence(self.reviews.sample)
  end

  def random_image
    Echonest::Artist.images(eid).sample
  end

private

  def get_echonest_id
    (artist = Echonest::Artist.search(self.name)) && self.eid = artist.id
  end

  def random_sentence(text)
    return unless text.strip.present?
    sentences = TactfulTokenizer::Model.new.tokenize_text(text)
    (sentence = sentences.sample) ? sentence.gsub(self.name, "*******") : nil
  end

end
