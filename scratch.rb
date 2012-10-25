require './lib/inports'

$r.kill_keys

# #puts EzPub::File.mine?('./input/curriculum-support/Teacher-Education/PTTER-framework/E1/E1A2.htm')


# str = StringFromPath.get_case_insensitive('./input/curriculum-support/Teacher-Education/PTTER-framework/E1/E1A2.htm')

# doc = Nokogiri::HTML(str)

# include FieldParsers

# puts get_title(doc)

# include IsARedirect

# redirect?('./input/curriculum-support/CSP/index.htm')


DatabaseImporters::Question.run
include PostProcessor

post_process
