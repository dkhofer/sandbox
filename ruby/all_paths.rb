#!/usr/bin/env ruby

puts (0..(2**20)).count { |n| n.to_s(2).chars.count("1") == 10 }
