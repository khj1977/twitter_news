#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

# require "mysql"
require "com/gmail/eulerbonjour/twitter/Twitter"
require "com/gmail/eulerbonjour/util/E_Mecab"
require "com/gmail/eulerbonjour/app/DefaultConfig"
require 'rubygems'
require 'amqp'
require 'mq'

$KCODE="u"

class TweetHandler

  def initialize(wordID, tweetID)
    @japanesePattern = Regexp.compile("[あ-ん]", nil, "u")
    @urlPattern = Regexp.compile("^.*(http:\/\/[a-zA-Z0-9\.\/]*).*$")

    @mecab = E_Mecab.new

    @channel = nil

    @tidx = 0
  end

  def reopenThrift
  end

  def isJapanese(str)
    if str =~ @japanesePattern
      return true;
    end

    return false;
  end

  def isURL(str)
    if str =~ @urlPattern
      return true
    end

    return false
  end

  def getURL(str)
    if str =~ @urlPattern
      return Regexp.last_match[1]
    else
      return nil
    end

    raise
  end

  def close

  end

  def handle(tweet)
    begin
      @tweetID = tweet["id"].to_s
      tweetText = tweet["text"]
      screenName = tweet["user"]["screen_name"]
      userID = screenName
      userImage = tweet["user"]["profile_image_url"]
      createTime = tweet["created_at"]
      geo = tweet["geo"]
    rescue
      return
    end

    # debug
    if geo != nil
      geo = geo["coordinates"]
      geo = geo[0].to_s + "::::" + geo[1].to_s
    else
      geo = "null::::null"
    end
    # end of debug

    if tweetText == nil || tweetText == nil || userID == nil || screenName == nil || userImage == nil || createTime == nil
      return
    end

    if not self.isJapanese(tweetText)
      return
    end

    # debug
    # put access to twitter api inside this block?
    # end of debug
    AMQP.start(:host => 'localhost') do
      channel = AMQP::Channel.new.queue("tw_news_dev")
      # channel.publish(Marshal.dump({"tweet_id" => @tweetID, "tweet" => tweetText}))
      channel.publish(@tweetID + "::::" + tweetText + "::::" + geo + "::::" + userImage)
      
      if self.isURL(tweetText)
        urlChannel = AMQP::Channel.new.queue("tw_news_url_dev")
        url = self.getURL(tweetText)
        if url != nil
          urlChannel.publish(Marshal.dump({"tweet_id" => @tweetID, "url" => url}))
        end
      end
      AMQP.stop {EM.stop}
    end    
    puts tweetText
    
    return
  end
  
end

config = DefaultConfig.new.config
twitter = Twitter.new(config["tw_user_name"], config["tw_password"])

wordID = 0
tweetID = 0

# handler = TweetHandler.new(wordID, tweetID)
# twitter.handleSampleStream(handler)

while true
  handler = TweetHandler.new(wordID, tweetID)
  begin
    twitter.queuingHandleSampleStream(handler)
  rescue => ex
    # wordID = handler.getWordID + 1
    # tweetID = handler.getTweetID + 1
    # handler.close
    puts "exception"
    puts ex

    exit
  ensure
    handler.close
  end
end
