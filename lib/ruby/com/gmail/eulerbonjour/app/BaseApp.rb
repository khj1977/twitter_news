require "mysql"
require "jcode"
require "com/gmail/eulerbonjour/conf/DefaultConfig"

$KCODE = "u"

class BaseApp

  public

  def initialize(config, dbName)
    config = config.config
    @mysql = Mysql.init
    # @mysql = Mysql.real_connect(config["db_host"], config["user_name"], config["password"], dbName)
    @mysql = Mysql.real_connect(config["db_host"], config["user_name"], config["password"], config["db_name"])
  end

  def getMySql
    return @mysql
  end

  def exec
  end

end
