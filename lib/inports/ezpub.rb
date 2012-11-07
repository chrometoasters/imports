require './lib/inports/ezpub/handler'
require './lib/inports/ezpub/handler_sets'


# load helpers for mine and store methods.
require './lib/inports/ezpub/mine_modules/ezp_extensions.rb'
require './lib/inports/ezpub/mine_modules/is_a_redirect.rb'
require './lib/inports/ezpub/mine_modules/has_valid_index.rb'
require './lib/inports/ezpub/mine_modules/include_or_page.rb'

Dir['./lib/inports/ezpub/store_modules/*.rb'].each {|file| require file }

require './lib/inports/ezpub/media_folder'
require './lib/inports/ezpub/thumbnail'
require './lib/inports/ezpub/image'
require './lib/inports/ezpub/file'
require './lib/inports/ezpub/redirect'

require './lib/inports/ezpub/abstract'
require './lib/inports/ezpub/review'
require './lib/inports/ezpub/reviews_landing_page'
require './lib/inports/ezpub/case_study'
require './lib/inports/ezpub/case_study_landing_page'
require './lib/inports/ezpub/folder'
require './lib/inports/ezpub/general_content'
require './lib/inports/ezpub/showcases_landing_page'
require './lib/inports/ezpub/showcase'
require './lib/inports/ezpub/snapshots_landing_page'
require './lib/inports/ezpub/snapshot'
require './lib/inports/ezpub/simple_gallery'
require './lib/inports/ezpub/db_large_gallery'
require './lib/inports/ezpub/db_small_gallery'
require './lib/inports/ezpub/course_outline_landing_page'

require './lib/inports/ezpub/ignorable'
