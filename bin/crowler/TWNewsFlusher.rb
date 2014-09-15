#!/usr/local/bin/ruby
# -*- coding: utf-8 -*-

require 'rubygems'
require 'amqp'
require 'mq'
require "com/gmail/eulerbonjour/app/BaseApp"
require "com/gmail/eulerbonjour/conf/DefaultConfig"
require "com/gmail/eulerbonjour/util/TWInvIndexBuffer"
require "com/gmail/eulerbonjour/util/TWTweetBuffer"
require "com/gmail/eulerbonjour/util/E_Mecab"
require "com/gmail/eulerbonjour/util/KKStream"
require "com/gmail/eulerbonjour/util/KKDefaultStream"

class TWNewsFlusher < BaseApp

  def exec
    mecab = E_Mecab.new
    buffer = TWInvIndexBuffer.new(@mysql)
    tweetBuffer = TWTweetBuffer.new(@mysql)
    kkCombiner = KKDefaultStream.new

    AMQP.start(:host => 'localhost' ) do
      q = MQ.new.queue('tw_news_dev')
      q.subscribe do |rawMsg|

        msg = rawMsg.split("::::")
        tweetId = msg[0]
        tweet = msg[1]
        geo1 = msg[2]
        geo2 = msg[3]
        icon = msg[4]

        tweetBuffer.push(tweetId, tweet, geo1, geo2, icon)

        mecab.parse(tweet) do |kked|
          word = kked["word"]
          hinshi = kked["hinshi"]
          
          kkCombiner.push(kked)

          # buffer.push({"word" => word, "tweet_id" => tweetId})

        end
        kkCombined = kkCombiner.getElements
        kkCombined.each do |kked|

          hinshi = kked["hinshi"]
          word = kked["word"]

          if hinshi != "名詞"
            next
          end

          if !mecab.isWordAppropriate(word)
            next
          end


          buffer.push({"word" => kked["word"], "tweet_id" => tweetId})
        end
      end
    end

  end

end

app = TWNewsFlusher.new(DefaultConfig.new, "twitter_news_dev")
app.exec
