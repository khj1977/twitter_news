require "com/gmail/eulerbonjour/util/TheWorld"

class TwUrl

  public

  def initialize
  end

  def getUrls(word, thTime)
    result = Array.new

    statement = TheWorld.instance.mysql.prepare("SELECT u.URL as url, u.TITLE as title FROM urls as u, inv_indices as i WHERE u.TWEET_ID = i.TWEET_ID AND i.WORD = ? AND u.CREATE_TIME >= ? GROUP BY title LIMIT 10")

    statement.execute(word, thTime)
    while row = statement.fetch
      url = row[0]
      title = row[1]

      if url.length == 0 or title.length == 0
        next
      end

      result.push({"url" => url, "title" => title})
    end

    return result
  end

end
