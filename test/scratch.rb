require './lib/inports'

# docs = []
# docs << Nokogiri::HTML(open('./input/curriculum-support/index.htm'))
# docs << Nokogiri::HTML(open('./input/curriculum-support/index.htm'))


# docs.each do |doc|
#   puts doc.internal_subset.system_id
# end

# files = Dir.entries(CONFIG['directories']['input'])

# puts files

c = Crawler.new
#puts c.list
c.run
