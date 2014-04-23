# -*- coding: utf-8 -*-
require "nkf"
require "jcode"
require "MeCab"

include MeCab

$KCODE="UTF-8"

class E_Mecab

  def initialize
    @mecab = Tagger.new
  end

  def parse(str)
    elements = Array.new

    node = @mecab.parseToNode(str)
    
    while node do
      word = node.surface
      # debug
      
      # end of debug
      feature = node.feature

      hinshi = self.getHinshi(feature)
      if hinshi == "BOS/EOS"
        node = node.next
        next
      end

      genkei = self.getGenkei(feature)

      yield({"word" => word, "hinshi" => hinshi, "genkei" => genkei})
      
      node = node.next
    end

  end

  def getHinshi(feature)
    splitted = feature.split(",")
    hinshi = splitted[0]

    return hinshi
  end

  def getGenkei(feature)
    splitted = feature.split(",")
    genkei = splitted[6]

    return genkei
  end

  def isWordAppropriate(word)
    # debug
    # puts sprintf("word %s", word)
    # end of debug

    if word == "なう" || word == "ナウ"
      return true
    end

    if self.isHiraOnlyWord(word)
      # debug
      # puts sprintf("hira %s", word)
      # end of debug
      return false
    elsif self.isAlphabetOnlyWord(word)
      # debug
      # puts sprintf("alpha %s", word)
      # end of debug
      return false
    elsif self.hasSymbol(word)
      # debug
      # puts sprintf("symbol %s", word)
      # end of debug
      return false
    elsif word.jlength == 1
      # debug
      # puts sprintf("len %s", word)
      # end of debug
      return false
    end
    
    return true
  end

  def isHiraOnlyWord(word)
    if word =~ /^[あ-んー]*$/
      return true
    end

    return false
  end

  def isAlphabetOnlyWord(word)
    if /^[a-zA-Z]*$/ =~ word
      return true
    end

    return false
  end

  def hasSymbol(word)
    eucWord = NKF.nkf("-e", word)
    
    isFirstByte = false
    eucWord.each_byte do |byte|
      # byte = byte[0]
      # debug
      # puts byte
      # end of debug

      if byte < 128
        return true
      end

      if byte > 160 && isFirstByte == false
        isFirstByte = true
      else
        isFirstByte = false
      end

      if isFirstByte == true && 
          ((165 < byte && byte < 176) || (161 < byte && byte < 164))
        return true
      end

      
      
    end

    return false
  end
  
end
