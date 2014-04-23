require "com/gmail/eulerbonjour/util/TheWorld"

class PopWord

  public
  
  def initialize
  end

  def currentPopWords
    popWords = Array.new

    dateTime = self.latestDateTime
    
    begin
      statement = TheWorld.instance.mysql.prepare("SELECT WORD, DF FROM pop_words WHERE CREATE_TIME = ?")
      statement.execute(dateTime)

      while row = statement.fetch
        word = row[0]
        df = row[1].to_i
        popWords.push({"word" => word, "df" => df})
      end
    ensure
      statement.close
    end

    return self.addFontProps(popWords)
  end

  def addFontProps(popWords)
    max = 0
    popWords.each do |word|
      if word["df"] > max
        max = word["df"]
      end
    end

    result = Array.new
    popWords.each do |word|
      word["font_size"] = Math.log10(word["df"]) / Math.log10(max) * 7.0
      word["font_color"] = "black"

      result.push(word)
    end

    return result
  end

  protected
  
  def latestDateTime

    result = nil
    begin
      statement = TheWorld.instance.mysql.prepare("SELECT CREATE_TIME FROM pop_words ORDER BY ID DESC LIMIT 1")
      statement.execute()
      row = statement.fetch
      
      result = row[0]
    ensure
      statement.close
    end

    return result
  end

end
