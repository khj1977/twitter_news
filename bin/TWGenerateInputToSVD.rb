#!/usr/local/bin/ruby

require "com/gmail/eulerbonjour/app/BaseApp"
require "mysql"
require "date"

class TWGenerateInputToSVD < BaseApp

  public

  def exec(startDateTime, endDateTime)
    words = Array.new
    sql = "SELECT WORD FROM inv_indices WHERE CREATE_TIME < '" + endDateTime +"' AND CREATE_TIME > '" + startDateTime +"' GROUP BY WORD"
    rows = @mysql.query(sql)

    # debug
    puts sql
    # end of debug

    while row = rows.fetch_hash
      words.push(row["WORD"])
    end
    rows.free

    sql = "SELECT TWEET_ID FROM inv_indices WHERE CREATE_TIME < '" + endDateTime + "' AND CREATE_TIME > '" + startDateTime + "' AND WORD=?"
    statement = @mysql.prepare(sql)

    words.each do |word|
      STDOUT.printf("%s", word)
      statement.execute(word)
      i = 1
      n = statement.num_rows
      while tweetId = statement.fetch
        if i != n
          STDOUT.printf("\t")
        elsif i == 1
          STDOUT.printf("\t")
        end
        STDOUT.printf("%s", tweetId)

        i = i + 1
      end
      STDOUT.printf("\n")
    end

  end

end

# if ARGV.length != 2
#   puts "usage: prog start-datetime end-datetime"
# 
#   exit
# end

# startDateTime = ARGV[0]
# endDateTime = ARGV[1]

startDate = DateTime.now - 1
startDateTime = sprintf("%s-%s-%s %s:00:00", startDate.year, startDate.month, startDate.day, startDate.strftime("%H"))

endDate = DateTime.now
endDateTime = sprintf("%s-%s-%s %s:00:00", endDate.year, endDate.month, endDate.day, endDate.strftime("%H"))

app = TWGenerateInputToSVD.new(DefaultConfig.new, "twitter_news_dev")
app.exec(startDateTime, endDateTime)
