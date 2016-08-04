#!/usr/bin/ruby
require_relative 'card'

puts 'Enter CC number: '
cc = Card.new(gets.chomp)

puts "Card is valid? #{cc.correct?}"
puts "Card system: #{cc.system}"
