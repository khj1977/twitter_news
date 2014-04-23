#!/usr/local/bin/ruby

require "com/gmail/eulerbonjour/twitter/Twitter"
require "com/gmail/eulerbonjour/twitter/DefaultJsonHandler"
require "com/gmail/eulerbonjour/app/BaseApp"
require "com/gmail/eulerbonjour/app/DefaultConfig"

class FetchStreamingTweets < BaseApp

  public 

  def exec
    userName = ""
    password = ""

    tweetHandler = DefaultJsonHandler.new(@mysql)
    twitter = Twitter.new(userName, password)
    twitter.handleSampleStream(tweetHandler)
  end

end

app = FetchStreamingTweets.new(DefaultConfig.new, 
                               "twitter_self_analyze")
app.exec
