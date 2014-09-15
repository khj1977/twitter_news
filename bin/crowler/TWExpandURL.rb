#!/usr/local/bin/ruby

require 'rubygems'
require 'amqp'
require 'mq'
require "com/gmail/eulerbonjour/app/BaseApp"
require "com/gmail/eulerbonjour/conf/DefaultConfig"
require "com/gmail/eulerbonjour/util/Util"
require "mysql"

class TWExpandURL < BaseApp
  
  public

  def exec
    statement = @mysql.prepare("INSERT INTO urls (TWEET_ID, URL, TITLE, CREATE_TIME) VALUES(?, ?, ?, now())")
    
    AMQP.start(:host => 'localhost' ) do
      q = MQ.new.queue('tw_news_url_dev')
      q.subscribe do |rawMsg|
        msg = Marshal.load(rawMsg)
        url = msg["url"]
        tweetId = msg["tweet_id"]
        
        begin
          expandedUrl = Util.expandUrl(url)
          html = Util.getOriginalHTML(expandedUrl)
          title = Util.extractHTMLTitle(html)

          statement.execute(tweetId, expandedUrl, title)
          puts title + " : " + expandedUrl
        rescue => ex
          puts "TWExpandURL::exec(): " + ex.to_s
        end

      end
    end

  end
  

end

app = TWExpandURL.new(DefaultConfig.new, "twitter_news_dev")
app.exec
