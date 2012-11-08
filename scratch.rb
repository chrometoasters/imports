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



# @p = Processor.new
# puts @p.list
# path = @p.to_xml :name => 'techlink-content'




# str = StringFromPath.get_case_insensitive('./input/Case-studies/Technological-practice/Soft-Materials/Conscious-Cloth/index.htm')


# puts to_ezp(str, :config => Sanitize::InportConfig::EZXML)

# module EzPub
#   class Handler
#     class << self
#       def parent_id(path)
#         'abc'
#       end
#     end
#   end
# end

# @p = Processor.new

# FasterCSV.read(CONFIG['directories']['dbs'] + "/CourseOutlines.csv").each do |row|
#   puts row[0]
# end


paths = [
        './input/navigation',
        # './input/teaching-snapshot/Y01-06-Junior/',
        # './input/teaching-snapshot/Y07-10-Middle/',
        # './input/teaching-snapshot/Y12-13-Senior/',
  ]

paths.each do |path|
  puts EzPub::Ignorable.mine?(path)
  # EzPub::DBSmallGallery.store(path)
  # include PostProcessor
  # post_process

  # puts $r.hget(path, 'field_title')
  # puts $r.hget(path, 'field_body')
  # puts $r.hget(path, 'field_image')
  #puts $r.hget(path, 'field_curriculum_links')
end

# include ActsAsIndex
# puts acts_as_index? './input/teaching-snapshot/ts.htm'

# puts has_remote_index? './input/student-showcase/Materials/'



# @p = Processor.new
# @p.to_xml :name => 'techlink-content-only.xml'

# SanityCheck.render_as_list './output/xml/techlink-content-only.xml'

# paths.each do |path|
#   puts @p.handle path
# end



# SanityCheck.summary './output/xml/techlink-content.xml'









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
