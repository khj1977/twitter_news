# -*- coding: utf-8 -*-
require "mysql"

class TWInvIndexBuffer

  public

  def initialize(mysql)
    @mysql = mysql
    # word => tweet idの関係
    @buffer = Array.new
    @num = 0
    @thBulk = 300
  end

  def push(data)
    @buffer.push({"word" => data["word"], "tweet_id" => data["tweet_id"]})

    @num = @num + 1
    if @num > @thBulk
      self.flushBuffer
    end
    
  end

  protected

  def flushBuffer
    # debug
    puts "flushBuffer"
    # end of debug

    sql = "INSERT INTO inv_indices (WORD, TWEET_ID, CREATE_TIME) VALUES "

    i = 0
    @buffer.each do |element|
      val = sprintf("('%s', '%s', now())", @mysql.quote(element["word"]), element["tweet_id"])

      if i != 0
        sql = sql + ","
      end

      sql = sql + val

      i = i + 1
    end

    @mysql.query(sql)

    @buffer = Array.new
    @num = 0
  end

end
