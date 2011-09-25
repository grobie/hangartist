require "json"
require "faraday"

require_relative "echonest/config"
require_relative "echonest/artist"

module Echonest

  def self.config
    @config ||= Config.new
  end

  def self.configure
    yield(config)
  end

  def self.connection
    @connection ||= begin
      Faraday.new(:url => config.api_root) do |builder|
        builder.request :url_encoded
        builder.request :json

        builder.adapter :net_http
      end
    end
  end

  def self.post(path, payload = {}, headers = {})
    response = connection.post(path, payload, headers)
    JSON.parse(response.body)["response"]
  end

  def self.get(path, params = {})
    params = { :api_key => config.api_key }.merge(params)
    response = connection.get do |request|
      request.url path
      params.each { |key, value| request.params[key] = value }
    end
    JSON.parse(response.body)["response"]
  end

end
