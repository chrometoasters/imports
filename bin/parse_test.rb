require './lib/inports'

include FieldParsers
include IncludeResolver

field = ARGV[0]
path = ARGV[1]

doc = get_nokogiridoc_from_path(path)

field = send "get_#{field}".to_sym, doc

puts field
