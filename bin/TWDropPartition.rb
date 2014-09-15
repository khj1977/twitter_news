#!/usr/local/bin/ruby

require "com/gmail/eulerbonjour/app/BaseApp"
require "conf/DefaultConfig"
require "date"

class TWDropPartition < BaseApp

  public

  def exec
    tableNames = ["inv_indices", "tweets", "pop_words", "urls"]

    tommorow= Date.today - 3
    year = tommorow.year
    month = tommorow.month
    day = tommorow.day

    sql = nil
    tableNames.each do |tableName|
      sql = sprintf("ALTER TABLE %s DROP PARTITION p%d_%d_%d", tableName, year, month, day)
      begin
        self.getMySql.query(sql)
      rescue => ex
        # do nothing
        puts "error: " + ex.to_s + " : " + sql
      end
    end

  end

end

app = TWDropPartition.new(DefaultConfig.new, "")
app.exec
