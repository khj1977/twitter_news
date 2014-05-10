#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

# require "mysql"
require "com/gmail/eulerbonjour/twitter/Twitter"
require "com/gmail/eulerbonjour/twitter/TweetHandler"
require "com/gmail/eulerbonjour/app/DefaultConfig"

$KCODE="u"

config = DefaultConfig.new.config
twitter = Twitter.new(config["tw_user_name"], config["tw_password"])

wordID = 0
tweetID = 0

handler = TweetHandler.new(wordID, tweetID)
begin
  twitter.queuingHandleSampleStream(handler)
rescue => ex
  puts ex
  
  exit
ensure
  handler.close
end

