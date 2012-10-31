require './lib/inports'

@files = Processor.new(:handlers => [EzPub::File])

puts $term.color("Starting static file ingest...", :green)

@files.ingest

puts $term.color("Generating XML...", :green)

path = @files.to_xml :name => 'techlink-files'

puts $term.color("XML created at #{path}.", :green)


$r.kill_keys


@images = Processor.new(:handlers => [EzPub::Image])

puts $term.color("Starting images ingest...", :green)

@images.ingest

puts $term.color("Generating XML...", :green)

path = @images.to_xml :name => 'techlink-images'

puts $term.color("XML created at #{path}.", :green)
