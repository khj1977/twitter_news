require "com/gmail/eulerbonjour/util/DebugStream"
require "conf/DefaultConfig"
require "com/gmail/eulerbonjour/util/Logger"
require "mysql"

class TheWorld
  @@instance = nil

  public

  def TheWorld.instance

    if @@instance == nil
      @@instance = TheWorld.new
    end

    return @@instance
  end

  def resetInstance
    @mysql.close
    @@instance = nil
  end

  def debugStream
    return @debugStream
  end

  def mysql
    return @mysql
  end

  def logger
    return @logger
  end

  def config
    return @config
  end

  protected

  def initialize()
    @debugStream = DebugStream.out
    @logger = Logger.new

    @config = DefaultConfig.new.config
    @mysql = Mysql.init
    @mysql = Mysql.real_connect(@config["db_host"], @config["user_name"], @config["password"], @config["db_name"])
  end

end
