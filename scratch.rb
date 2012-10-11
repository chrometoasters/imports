require './lib/inports'
include Convert

file = File.open('./input/curriculum-support/Strategies/tp-brief/index.htm')
contents = file.read

str = to_ezp contents


puts str if $verbose

# puts Crawler.new.list
