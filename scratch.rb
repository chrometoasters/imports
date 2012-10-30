require './lib/inports'

# $r.kill_keys

# #puts EzPub::File.mine?('./input/curriculum-support/Teacher-Education/PTTER-framework/E1/E1A2.htm')


# str = StringFromPath.get_case_insensitive('./input/curriculum-support/Teacher-Education/PTTER-framework/E1/E1A2.htm')

# doc = Nokogiri::HTML(str)

# include FieldParsers

# puts get_title(doc)

# include IsARedirect

# redirect?('./input/curriculum-support/CSP/index.htm')


# DatabaseImporters::Question.run
# include PostProcessor

# post_process




# str = StringFromPath.get_case_insensitive('./input/Case-studies/Technological-practice/Soft-Materials/Conscious-Cloth/index.htm')


# puts to_ezp(str, :config => Sanitize::InportConfig::EZXML)

path = './input/curriculum-support/indicators/practice/'


puts EzPub::GeneralContent.mine?(path)
EzPub::GeneralContent.store(path)

include PostProcessor
post_process

puts $r.hget(path, 'field_title')
puts $r.hget(path, 'field_body')

# puts $r.hget(path, 'field_body')

# Processor.new.list.each do |path|
#   puts path
#   str = StringFromPath.get_case_insensitive(path)
#   path.gsub!('./input', 'http://www.techlink.org.nz')
#   Sanitize.clean(str, :transformers => [ClassAttributeInspector], :path => path)
# end

# puts $r.hget(path, 'field_category')
# puts $r.hget(path, 'field_case_study_date')
# puts $r.hget(path, 'field_year_level')
# puts $r.hget(path, 'field_cover_image')


# File.open('classes.txt', 'a') do |f|
#   $r.smembers('classes').each do |line|
#     f.write(line + "\n")
#   end
# end

# File.open('examples.txt', 'a') do |f|
#   $r.smembers('examples').each do |line|
#     f.write(line + "\n")
#   end
# end
