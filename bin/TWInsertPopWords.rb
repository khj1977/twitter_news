#!/usr/local/bin/ruby

require "com/gmail/eulerbonjour/app/BaseApp"
require "com/gmail/eulerbonjour/app/DefaultConfig"
require "date"

class TWInsertPopWords < BaseApp

  public

  def exec(path, year, month, day, hour)
    createTime = sprintf("%s-%s-%s %s:00:00", year, month, day, hour)

    iStatement = @mysql.prepare("INSERT INTO pop_words (WORD, DF, CREATE_TIME) VALUES(?, ?, ?)")

    dfs = Hash.new
    statement = @mysql.prepare("SELECT WORD, COUNT(WORD) as cnt FROM inv_indices WHERE CREATE_TIME > ? GROUP BY WORD")
    statement.execute(createTime)
    while row = statement.fetch
      word = row[0]
      cnt = row[1].to_i

      dfs[word] = cnt
    end

    popWords = Array.new
    IO.foreach(path) do |line|
      line = line.chop
      splitted = line.split("\t")
      n = splitted.size
      for i in 3 .. n - 1
        popWords.push(splitted[i])
      end
    end

    popWords.each do |popWord|
      df = dfs[popWord]
      if df == nil
        next
      end

      iStatement.execute(popWord, df, createTime)
    end

  end

end

if ARGV.length != 1
  puts "usage: prog path"

  exit
end

path = ARGV[0]

# year = ARGV[1]
# month = ARGV[2]
# day = ARGV[3]
# hour = ARGV[4]

# This script will be run around 5AM JST and range of data is 12 or 24 hours.
# Also, these date/time is used to specify which word master is used => 
# CREATE_TIME > ?
date = DateTime.now - 1
year = date.year
month = date.month
day = date.day
hour = date.strftime("%H")

app = TWInsertPopWords.new(DefaultConfig.new, "twitter_news_dev")
app.exec(path, year, month, day, hour)
