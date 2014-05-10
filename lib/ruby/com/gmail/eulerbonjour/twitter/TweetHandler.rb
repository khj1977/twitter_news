# -*- coding: utf-8 -*-
require 'rubygems'
require 'amqp'
require 'mq'

class TweetHandler

  def initialize(wordID, tweetID)
    @japanesePattern = Regexp.compile("[あ-ん]", nil, "u")
    @urlPattern = Regexp.compile("^.*(http:\/\/[a-zA-Z0-9\.\/]*).*$")

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

    if geo != nil
      geo = geo["coordinates"]
      geo = geo[0].to_s + "::::" + geo[1].to_s
    else
      geo = "null::::null"
    end

    if tweetText == nil || tweetText == nil || userID == nil || screenName == nil || userImage == nil || createTime == nil
      return
    end

    if not self.isJapanese(tweetText)
      return
    end

    AMQP.start(:host => 'localhost') do
      channel = AMQP::Channel.new.queue("tw_news_dev")
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
    # puts tweetText
    
    return
  end
  
end
