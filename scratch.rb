require './lib/inports'

$r.kill_keys

$r.hset './input/curriculum-support', 'id', '123'

EzPub::GeneralContent.store('./input/curriculum-support/index.htm')



# CONFIG['directories']['input'] = './test/mocks'

# result = resolve_includes './test/mocks/has_includes.htm'




#puts result #if $verbose

# puts Crawler.new.list
