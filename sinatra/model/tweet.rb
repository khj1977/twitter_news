# -*- coding: utf-8 -*-
require "com/gmail/eulerbonjour/util/TheWorld"

class Tweet
  
  public

  def initialize
  end

  def tweets(searchWord, thTime)
    rows = Array.new

    statement = nil
    begin
      # 高負荷を想定してないから、そこそこ速い以下のSQLでおｋ
      statement = TheWorld.instance.mysql.prepare("SELECT t.TWEET, t.ICON_URL FROM tweets as t, inv_indices as i WHERE t.TWEET_ID = i.TWEET_ID AND i.WORD = ? GROUP BY i.TWEET_ID ORDER BY i.TWEET_ID DESC LIMIT 20")

      statement.execute(searchWord)
      while row = statement.fetch
        rows.push({"tweet" => row[0], "icon" => row[1]})
      end
    rescue
    ensure
      if statement != nil
        statement.close
      end
    end

    return rows
  end

end
