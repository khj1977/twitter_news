$LOAD_PATH.push(File.dirname(__FILE__) + "/../")
$LOAD_PATH.push(File.dirname(__FILE__) + "/../../lib/ruby/")

require 'sinatra'
require "model/tweet"
require "model/pop_word"
require "model/tw_url"
require "date"

set :views, File.dirname(__FILE__) + "/../view/"

get '/search/' do
  @searchKeys = nil
  @searched = Array.new
  @newsToShow = Array.new
  
  @action = "search"
  @config = TheWorld.instance.config
  @popWords = PopWord.new.currentPopWords
    
  TheWorld.instance.resetInstance
  
  erb :search
end
  
get '/search/:query' do
  @action = "search"
  @config = TheWorld.instance.config

  query = params[:query]

  thTime = (Date.today - 3).strftime("%Y-%m-%d 0:00:00")
  @searchKeys = query
  @searched = Tweet.new.tweets(query, thTime)
  @popWords = PopWord.new.currentPopWords
  @newsToShow = Array.new
  # @newsToShow = TwUrl.new.getUrls(@searchKeys, thTime)

  TheWorld.instance.resetInstance

  erb :search
end
