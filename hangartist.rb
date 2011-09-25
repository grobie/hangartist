require 'sinatra'
require 'sinatra/activerecord'

require_relative "lib/echonest"
require_relative "app/artist"
require_relative "app/game"

set :root,   File.expand_path(File.dirname(__FILE__))
set :public, File.expand_path("public", settings.root)

Echonest.configure do |config|
  config.api_root = "http://developer.echonest.com/api/v4"
  config.api_key = "WIU43FOYVQXSRNV1V"
end

get '/favicon.ico' do
end

get '/' do
  erb :index
end

post '/' do
  if @game = Game.create
    redirect "/#{@game.id}"
  else
    "FAILURE"
  end
end

get '/:id' do
  @game = Game.find(params[:id])
  erb :show
end

post '/:id/solve' do
  @game = Game.find(params[:id])
  if @game.artist.name == params[:artist]
    erb :won
  else
    redirect "/#{@game.id}"
  end
end

post '/:id/give_up' do
  @game = Game.find(params[:id])
  @game.give_up!
  erb :lost
end
