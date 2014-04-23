# -*- coding: utf-8 -*-
require 'net/http'
require "kconv"

$KCODE = "u"

class Util

  def Util.extractHTMLTitle(html)
    titlePattern = Regexp.compile("<title>(.*)<\/title>")
    title = ""
    html.each_line do |line|
      if line =~ titlePattern
        title = Regexp.last_match[1]
      end
    end
    
    return title.toutf8
  end

  def Util.getOriginalHTML(url, limit = 10)
    Net::HTTP.version_1_2
    response = Net::HTTP.get_response(URI.parse(url))
    # puts response.body.to_s
    
    return response.body.to_s
  end

  def Util.extractUrl(text)
    text =~ /^.*(http:\/\/[a-zA-Z0-9\.\/]*).*$/
    begin
      url = Regexp.last_match[1]
    rescue
      return nil
    end

    return url
  end

  def Util.expandUrl(originalUrl, limit = 10)
    Net::HTTP.version_1_2
    raise ArgumentError, 'http redirect too deep' if limit == 0
    
    response = Net::HTTP.get_response(URI.parse(originalUrl))
    case response
    when Net::HTTPSuccess then return originalUrl
    when Net::HTTPRedirection then return Util.expandUrl(response['location'], limit - 1)
    else
      raise Exception.new("Util.expandUrl(): somethign wrong with http access " + originalUrl + "\t" + limit.to_s)
    end
  end

  def Util.isJapanese(str)
    if str =~ /[あ-ん]/
      return true;
    end

    return false;
  end

  # Sat Jan 15 07:43:14 +0000 2011
  def Util.parseTwitterCreateTime(createTime)
    splitted = createTime.split(" ")
    year = splitted[5].to_i
    month = Util.toNumMonth(splitted[1])
    day = splitted[2].to_i
    tmp = splitted[3].split(":")
    hour = tmp[0].to_i

    return {"year" => year, "month" => month, 
      "day" => day, "hour" => hour}
  end

  def Util.toNumMonth(strMonth)
    mapping = {"Jan" => 1, "Feb" => 2, "Mar" => 3, 
      "Apr" => 4, "May" => 5, "Jun" => 6, "Jul" => 7,
      "Aug" => 8, "Sep" => 9, "Oct" => 10, "Nov" => 11,
      "Dec" => 12
    }

    result = mapping[strMonth]
    if result == nil
      raise Exception.new("Util.toNumMonth(): invalid str: " +
                          strMonth)
    end

    return result
  end


end
