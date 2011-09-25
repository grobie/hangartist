require 'sinatra'
require 'sinatra/activerecord'

begin
  require 'sinatra/reloader'
rescue LoadError
end

require_relative "lib/echonest"
require_relative "app/artist"
require_relative "app/game"

Echonest.configure do |config|
  config.api_root = "http://developer.echonest.com/api/v4"
  config.api_key = "WIU43FOYVQXSRNV1V"
end

class HangArtist < Sinatra::Base
  set :root,   File.expand_path(File.dirname(__FILE__))
  set :public, File.expand_path("public",  settings.root)

  get '/favicon.ico' do
  end

  get '/' do
    erb :index
  end

  post '/' do
    if @game = Game.create
      puts @game.inspect
      redirect "/#{@game.id}"
    else
      "FAILURE"
    end
  end

  get '/:id' do
    @game = Game.find(params[:id])
  end
end
