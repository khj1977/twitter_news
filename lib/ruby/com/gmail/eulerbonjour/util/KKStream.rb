# -*- coding: utf-8 -*-
class KKStream

  public

  def initialize
    @queue = Array.new
  end

  def push(kkElement)
    word = kkElement["word"]
    word = word.gsub(/・/, "")
    kkElement["word"] = word
    kkElement["genkei"] = word

    prevElement = self.getQueueLast
    if prevElement != nil
      if kkElement["hinshi"] == "名詞" and prevElement["hinshi"] == "名詞"
        prevElement["word"] = prevElement["word"] + kkElement["word"]
        prevElement["genkei"] = prevElement["genkei"] + kkElement["genkei"]
        self.setQueueLast(prevElement)
      else
        self.addQueueLast(kkElement)
      end
    else
      self.addQueueLast(kkElement)
    end

  end

  def getElements
    toReturn = @queue
    @queue = Array.new
    
    return toReturn
  end

  protected

  def getQueueLast
    return @queue[@queue.length - 1]
  end

  def setQueueLast(element)
    @queue[@queue.length - 1] = element
  end

  def addQueueLast(element)
    @queue.push(element)
  end

end
