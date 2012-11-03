require './lib/inports'

# Ingesting and processing content
#
#


@p = Processor.new(:handlers => EzPub::HandlerSets::Content)


puts $term.color("Starting content ingest...", :green)

@p.ingest

puts $term.color("Content ingest complete.", :green)

@p.log_unhandled


puts $term.color("Starting database content ingest...", :green)

@p.database_ingests

puts $term.color("Database content ingest complete.", :green)


puts $term.color("Starting content post-processing...", :green)


@p.post_process


puts $term.color("Post-processing complete.", :green)



puts $term.color("Generating XML...", :green)

path = @p.to_xml :name => 'techlink-content-only'

puts $term.color("XML created at #{path}.", :green)


SanityCheck.summary path

