require './lib/inports'
include Convert

file = File.open('./input/curriculum-support/index.htm')
contents = file.read

puts to_ezp contents

File.open('./output/thing.xml', 'a') {|f| f.write(to_ezp contents) }
