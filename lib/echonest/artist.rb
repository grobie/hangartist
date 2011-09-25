module Echonest
  class Artist
    attr_accessor :id, :name

    def initialize(id, name)
      self.id = id
      self.name = name
    end

    def biography
      self.class.biography(self.id)
    end

    def self.hot
      get_many(:top_hottt, :results => 15)
    end

    def self.search(name)
      get_one(:search, :name => name, :results => 1)
    end

    def self.biographies(id)
      response = get(:biographies, :id => id, :results => 1, :license => "cc-by-sa")
      biographies = response["biographies"]
      biographies.present? ? biographies.map { |biography| biography["text"] } : []
    end

    def self.songs(id)
      result = song_data(id)
      result.present? ? result["songs"].map { |song| song["title"] } : []
    end

    def self.tracks(id)
      result = song_data(id)
      result.present? ? result["songs"].map { |song| (tracks = song["tracks"]) ? tracks.first["preview_url"] : nil }.compact : []
    end

    def self.years_active(id)
      response = get(:profile, :id => id, :bucket => "years_active")
      response["artist"] && response["artist"]["years_active"].first
    end

    def self.reviews(id)
      response = get(:reviews, :id => id)
      reviews = response["reviews"]
      reviews.present? ? reviews.map { |review| review["summary"] } : []
    end

    def self.images(id)
      response = get(:images, :id => id, :license => "cc-by-sa")
      images = response["images"]
      images.present? ? images.map { |image| image["url"] } : []
    end

    def self.get_one(action, params = {})
      artists = get(action, params)["artists"]
      artists.present? ? new(*artists.first.values_at("id", "name")) : nil
    end

    def self.get_many(action, params = {})
      artists = get(action, params)["artists"]
      artists.map { |artist| new(*artist.values_at("id", "name")) }
    end

    def self.get(url, params = {})
      Echonest.get("artist/#{url}", params)
    end

  private

    def self.song_data(id)
      Echonest.get("song/search?bucket=id:7digital-US&bucket=tracks", :artist_id => id)
    end

  end
end
