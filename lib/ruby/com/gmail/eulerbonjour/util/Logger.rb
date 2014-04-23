require "com/gmail/eulerbonjour/app/DefaultConfig"

class Logger

  public

  INFO = "info"
  ERROR = "error"
  WARN = "warn"

  def initialize
    
  end

  def log(level, rawMessage)
    config = DefaultConfig.config

    date = Date.today.strftime("%Y-%m-%d")
    begin
      stream = File.open(config["log_dir"] + "/log-" + date + ".log")
      stream.printf("%s\t%s\trawMessage", level, dateTime, rawMessage)
    rescue
      # Do nothing
    ensure
      stream.close
    end
  end

end
