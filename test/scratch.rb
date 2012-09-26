require './lib/inports'

# # docs = []
# doc = Nokogiri::HTML(open('./input/curriculum-support/index.htm'))

# str = doc.xpath("//div[@id='content']").first.to_s

# puts Sanitize.clean(str, Sanitize::Config::RELAXED)

#puts doc.css('cfinclude')[2]

# puts doc.xpath("//cfinclude")
#

# docs.each do |doc|
#   puts doc.internal_subset.system_id
# end

# files = Dir.entries(CONFIG['directories']['input'])

# puts files

 c = Crawler.new
# #puts c.list
 c.run
