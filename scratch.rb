require './lib/inports'
include IncludeResolver

CONFIG['directories']['input'] = './test/mocks'

result = resolve_includes './test/mocks/has_includes.htm'


puts result #if $verbose

# puts Crawler.new.list
