#!/usr/local/bin/ruby

require "com/gmail/eulerbonjour/app/BaseApp"
require "com/gmail/eulerbonjour/app/DefaultConfig"
require "date"

class TWAddPartition < BaseApp

  public

  def exec
    tableNames = ["inv_indices", "tweets", "pop_words", "urls"]

    tommorow = Date.today + 2
    year = tommorow.year
    month = tommorow.month
    day = tommorow.day

    tableNames.each do |tableName|
      sql = sprintf("ALTER TABLE %s ADD PARTITION (PARTITION p%d_%d_%d VALUES LESS THAN (to_days('%d-%d-%d')))", tableName, year, month, day, year, month, day)
      self.getMySql.query(sql)
    end

  end

end

app = TWAddPartition.new(DefaultConfig.new, "")
app.exec
