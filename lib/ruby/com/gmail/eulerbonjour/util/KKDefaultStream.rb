class KKDefaultStream

  public

  def initialize
    @queue = Array.new
  end

  def push(kkElement)
    @queue.push(kkElement)
  end

  def getElements
    toReturn = @queue
    @queue = Array.new

    return toReturn
  end

end
