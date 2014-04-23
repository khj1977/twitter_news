class DebugStream
  @@instance = nil

  @isDebug

  def initialize
    @isDebug = false
  end

  def isDebug(anBoolean)
    @isDebug = anBoolean
  end

  def DebugStream.out

    if @@instance == nil
      @@instance = DebugStream.new
    end

    return @@instance
  end

  def write(anObject)
    if @isDebug != true
      return
    end

    puts anObject.to_s
  end

end
