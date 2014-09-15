#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

# require "mysql"
require "com/gmail/eulerbonjour/twitter/Twitter"
require "com/gmail/eulerbonjour/twitter/TweetHandler"
require "conf/DefaultConfig"

$KCODE="u"

config = DefaultConfig.new.config
twitter = Twitter.new(config["tw_user_name"], config["tw_password"])
handler = TweetHandler.new(wordID, tweetID)

wordID = 0
tweetID = 0

begin
  twitter.queuingHandleSampleStream(handler)
rescue => ex
  puts ex
  
  exit
ensure
  handler.close
end

