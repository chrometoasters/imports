require './lib/inports'
include Convert

file = File.open('./input/curriculum-support/terms.htm')
contents = file.read

str = to_ezp contents


puts str
