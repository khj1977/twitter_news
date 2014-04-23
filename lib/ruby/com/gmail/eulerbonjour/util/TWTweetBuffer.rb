require "mysql"

class TWTweetBuffer

  public

  def initialize(mysql)
    @mysql = mysql
    @buffer = Array.new
    @num = 0
    @thBulk = 300
  end

  def push(tweetId, tweet, geo1, geo2, icon)
    @buffer.push({"tweet_id" => tweetId, "tweet" => tweet, "geo1" => geo1, "geo2" => geo2, "icon" => icon})
    
    @num = @num + 1
    if @num > @thBulk
      self.flushBuffer
    end

  end

  protected

  def flushBuffer
    puts "TWTweetBuffer::flushBuffer"

    sql = "INSERT INTO tweets (CREATE_TIME, TWEET_ID, TWEET, GEO1, GEO2, ICON_URL) VALUES "

    i = 0
    @buffer.each do |element|
      val = sprintf("(now(), '%s', '%s', '%s', '%s', '%s')", element["tweet_id"], @mysql.quote(element["tweet"]), element["geo1"], element["geo2"], element["icon"])

      if i != 0
        sql = sql + ", "
      end

      sql = sql + val

      i = i +1
    end

    @mysql.query(sql)

    @buffer = Array.new
    @num = 0
  end

end
