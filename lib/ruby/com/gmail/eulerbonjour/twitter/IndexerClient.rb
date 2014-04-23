# -*- coding: utf-8 -*-
class IndexerClient

  public

  def initialize
    self.open

    @internalDocID = self.tweetTT.rnum
    @wordID = @wordMasterVTT.rnum + @wordMasterNTT.rnum

    self.initMisc
  end

  def initMisc
    @monthMap = Hash.new

    @monthMap["Jan"] = "1";
    @monthMap["Feb"] = "2";
    @monthMap["Mar"] = "3";
    @monthMap["Apr"] = "4";
    @monthMap["May"] = "5";
    @monthMap["Jun"] = "6";
    @monthMap["Jul"] = "7";
    @monthMap["Aug"] = "8";
    @monthMap["Sep"] = "9";
    @monthMap["Oct"] = "10";
    @monthMap["Nov"] = "11";
    @monthMap["Dec"] = "12";
  end

  # open and close db connection
  def reopen
    self.close
    self.open
  end

  # open db connection using wrapper of tt
  def open
  end

  # close db connection
  def close
  end

  def putTweet(tweetID, tweetText, createTime, userID)
    self.tweetCreateTimeTT.put(tweetID, createTime)
    self.tweetTouserInfoTT.put(tweetID, userID)
    self.tweetTT.put(@internalDocID.to_s, tweet)
    self.docIDToTweetID.put(@internalDocID.to_s, tweetID)
    self.tweetIDToDocID.put(tweetID, @internalDocID.to_s)

    @internalDocID = @internalDocID + 1
  end

  def putUserInfo(userID, screenName, userImage)
    val = screenName + ":::" + userImage
    self.userInfoTT.put(userID, val)
  end

  def putToInvIndex(word, hinshi, tweetIDAsString, createTime)
    splitted = createTime.split(" ")
    year = splitted[5].to_i
    month = @monthMap[splitted[1]].to_i
    day = splitted[2].to_i
    time = splitted[3]

    splitted2 = time.split(":")
    hour = splitted2[0].to_i
    min = splitted2[1].to_i
    sec = splitted3[2].to_i

    unixTime = Time.utc(year, month, day, hour, min, sec).to_i

    docIDList = Array.new
    docIDList.push(tweetIDAsString)
    @invIndexTT.putList(word, docIDList)

    @tweetIDCreateTimeTT.put(tweetIDAsString, unixTime.to_s)

    if hinshi == "名詞"
      xwordIDAsString = @wordMasterNTT.get(word)
      if xwordIDAsString == nil
        @wordMasterN.put(word, @wordID.to_s)
        @wordID = @wordID + 1
      end
    end

    if hinshi == "形容詞" or hinshi == "動詞"
      xwordIDAsString = @wordMasterVTT.get(word)
      if xwordIDAsString == nil
        @wordMasterVTT.put(word, @wordID.to_s)
        @wordID = @wordID + 1
      end
    end

    popWordAsString = @popWordTT.get(word)
    popWord = 0
    if popWordAsString == nil
      popWord = 1
    else
      popWord = popWordAsString.to_i
      popWord = popWord + 1
    end
    @popWordTT.put(word, popWord.to_s)
  end

end
