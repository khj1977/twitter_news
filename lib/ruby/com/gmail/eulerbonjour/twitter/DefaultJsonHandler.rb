# -*- coding: utf-8 -*-
require "com/gmail/eulerbonjour/util/E_Mecab"

# これは実アプリケーションでは使われてないJSON Handler.
# twitter_news / bin / crowler / TWSQueueClient.rbにあるTweetHandlerが
# 使われている。
class DefaultJsonHandler

  public

  def initialize(mysql)
    @mysql = mysql

    @japanesePattern = Regexp.compile("[あ-ん]", nil, "u")
    # @urlPattern = Regexp.compile("http*", nil, "u")
    @urlPattern = Regexp.compile("^.*(http:\/\/[a-zA-Z0-9\.\/]*).*$")

    @mecab = E_Mecab.new
    @wordMaster = Hash.new

    @numTweets = 0
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

  def handle(tweet)
    begin
      @tweetID = tweet["id"].to_s
      tweetText = tweet["text"]
      screenName = tweet["user"]["screen_name"]
      userID = screenName
      userImage = tweet["user"]["profile_image_url"]
      createTime = tweet["created_at"]
    rescue
      return true
    end

    if tweetText == nil || tweetText == nil || userID == nil || screenName == nil || userImage == nil || createTime == nil
      return true
    end

    begin
      if !self.isJapanese(tweetText)
        return true
      end
    rescue => ex
      puts ex
      # exit
    end

    # debug
    # STDOUT.printf("%d %s\n", @numTweets, tweetText)
    # end of debug

    # puts @tweetID + "\t" + createTime

    @mecab.parse(tweetText) do |xword|
      word = xword["word"]
      hinshi = xword["hinshi"]
      
      if !@mecab.isWordAppropriate(word)
        next
      end

      # if !(hinshi == "名詞" || hinshi == "形容詞" || hinshi == "動詞")
      if not hinshi == "名詞"
        next
      end

      if hinshi == "形容詞" || hinshi == "動詞"
        word = xword["genkei"]
      end

      if @wordMaster[word] == nil
        @wordMaster[word] = 0
      end
      @wordMaster[word] = @wordMaster[word] + 1

    end

    @numTweets = @numTweets + 1

    # debug
    puts @numTweets.to_s
    # end of debug

    if @numTweets > 50000
      puts "flush"
      self.flushWordMaster

      # Kernel.abort
    end

    # @tidx = @tidx + 1

    return true
  end

  def flushWordMaster
    sql = "INSERT INTO Word (ID, WORD, KIND_WORD, DF) VALUES(?, ?, ?, ?)"
    statement = @mysql.prepare(sql)

    i = 1
    @wordMaster.each do |word, df|
      statement.execute(i, word, 0, df)

      i = i + 1
    end
  end

end
