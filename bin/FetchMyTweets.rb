#!/usr/local/bin/ruby

require "com/gmail/eulerbonjour/twitter/TwitterOrdinaryAPI"
require "com/gmail/eulerbonjour/app/BaseApp"
require "com/gmail/eulerbonjour/conf/DefaultConfig"

class FetchMyTweets < BaseApp
  def exec
    twitter = TwitterOrdinaryAPI.new

    for i in 0 .. 5
      twitter.getMyTimeline(i) do |tweet|
        puts tweet["text"]
      end
    end

  end
end

app = FetchMyTweets.new(DefaultConfig.new, "twitter_self_analyze")
app.exec
