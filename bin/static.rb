require './lib/inports'

@p = Processor.new(:handlers => EzPub::HandlerSets::Static)

puts $term.color("Starting static file ingest...", :green)

@p.ingest

puts $term.color("Static file ingest complete.", :green)

puts $term.color("Generating XML...", :green)

path = @p.to_xml :name => 'all'

puts $term.color("XML created at #{path}.", :green)
