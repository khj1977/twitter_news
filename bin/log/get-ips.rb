#!/usr/local/bin/ruby

path = ARGV[0]

ips = Hash.new
IO.foreach(path) do |line|
  line.chop!
  splitted = line.split(" ")
  ip = splitted[0]

  if ips[ip] == nil
    ips[ip] = 0
  end

  ips[ip] = ips[ip] + 1

end

ips.each do |ip, num|
  STDOUT.printf("%s\t%d\n", ip, num)
end
