require './lib/inports'

include FieldParsers
include IncludeResolver
include PostProcessor

path = ARGV[0]
field = ARGV[1]
field_type = ARGV[2] || nil

doc = resolve_includes(path, :return => :doc)

output = send "get_#{field}".to_sym, doc, path


if output
  if field == 'body' || field_type == 'ezxml'

    # Remove internal link parsing for the purpose of a single page test.
    conf = Sanitize::InportConfig::EZXML

    conf[:transformers].delete_if {|t| t == InternalLink}

    sanitized_output = to_ezp(output, :config => Sanitize::InportConfig::EZXML)
  end

  puts $term.color(output, :cyan)
  puts $term.color(sanitized_output, :green) if sanitized_output
else
  puts $term.color("Nothing for FieldParsers.get_#{field}", :red)
end
