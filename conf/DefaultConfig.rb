class DefaultConfig

  public

  def initialize
    baseDir = ""
    @config = {
      "db_host" => "", 
      "user_name" => "", 
      "password" => "", 
      "db_name" => "", 
      # for old twitter API
      "tw_user_name" => "", 
      "tw_password" => "", 
      "base_url" => "", 
      "base_dir" => baseDir,
      "consumerKey" => "", 
      "consumerSecret" => "",
      "accessToken" => "",
      "accessTokenSecret" => "", 
      "log_dir" => baseDir + "/log/"}
  end

  def config
    return @config
  end

end
