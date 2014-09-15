# -*- coding: utf-8 -*-
require 'rubygems'
require 'oauth'
require 'json'
require "com/gmail/eulerbonjour/conf/DefaultConfig"

class TwitterOrdinaryAPI

  public

  def initialize
    config = DefaultConfig.new.config

    consumerKey = config.consumerKey
    consumerSecret = config.consumerSecret
    accessToken = config.accessToken
    accessTokenSecret = config.accessTokenSecret

    @consumer = OAuth::Consumer.new(
                                   consumerKey,
                                   consumerSecret,
                                   :site => 'http://twitter.com'
                                   )
    @access_token = OAuth::AccessToken.new(
                                          @consumer,
                                          accessToken,
                                          accessTokenSecret
                                          )
    
  end

  def getMyTimeline(page = 0)
    response = @access_token.get(sprintf('http://api.twitter.com/1/statuses/user_timeline.json?page=%d', page))
    JSON.parse(response.body).reverse_each do |status|
      # user = status['user']
      # puts "#{user['name']}(#{user['screen_name']}): #{status['text']}"
      yield(status)
    end
  end

  def getPublicTimeline
    response = @access_token.get('http://twitter.com/statuses/friends_timeline.json')
    JSON.parse(response.body).reverse_each do |status|
      user = status['user']
      puts "#{user['name']}(#{user['screen_name']}): #{status['text']}"
    end
  end

  def update(message)
    response = @access_token.post(
                                  'http://twitter.com/statuses/update.json',
                                  'status'=> message
                                  )

  end

  def search(word, lang="ja", locale="ja")
    url = "http://search.twitter.com/search.json"
    response = @access_token.post(
                                  url,
                                  "q" => word,
                                  "lang"=> lang,
                                  "locale" => locale
                                  )

    # debug
    # puts response.body
    # end of debug
    
    results = JSON.parse(response.body)
    # Array of Hash
    results = results["results"]

    # results.each do |result|
    #  result.each do |key, val|
    #    STDOUT.printf("%s\t%s\n", key, val)
    #  end
    # end

    return results
    
  end

end
