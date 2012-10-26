require './lib/inports'

$r.kill_keys

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


# include PostProcessor


# str = StringFromPath.get_case_insensitive('./input/Case-studies/Technological-practice/Soft-Materials/Conscious-Cloth/index.htm')


# puts to_ezp(str, :config => Sanitize::InportConfig::EZXML)

path = './input/Case-studies/Technological-practice/Food-and-Biological/Gluten-free-cookies/'

puts EzPub::CaseStudy.mine?(path)
EzPub::CaseStudy.store(path)

include PostProcessor
post_process

# puts $r.hget(path, 'field_body')
puts $r.hget(path, 'field_title')
puts $r.hget(path, 'field_category')
puts $r.hget(path, 'field_case_study_date')
puts $r.hget(path, 'field_year_level')
puts $r.hget(path, 'field_cover_image')

