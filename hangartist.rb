require 'sinatra'
require 'sinatra/activerecord'

require_relative "lib/echonest"
require_relative "app/artist"
require_relative "app/game"
require_relative "app/round"
require_relative "app/question"

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
  if @round = Round.create
    redirect "/#{@round.permalink}"
  else
    "FAILURE"
  end
end

get '/:permalink' do
  @round = Round.find_by_permalink!(params[:permalink])
  erb @round.state.to_sym
end

post '/:permalink/solve' do
  @round = Round.find_by_permalink!(params[:permalink])
  if @round.active? && @round.solved?(params[:attempt])
    @round.solve!
    erb :won
  else
    @round.increment_question_number! if @round.active?
    redirect "/#{@round.permalink}"
  end
end

post '/:permalink/give_up' do
  @round = Round.find_by_permalink!(params[:permalink])
  @round.give_up!
  erb :lost
end
