require './lib/inports'


# Ingesting static content
#
#


@p = Processor.new(:handlers => EzPub::HandlerSets::Static)

puts $term.color("Starting static file ingest...", :green)

@p.ingest

puts $term.color("Static file ingest complete.", :green)


# Ingesting and processing content
#
#


@p = Processor.new(:handlers => EzPub::HandlerSets::Content)

puts $term.color("Starting content ingest...", :green)

@p.ingest

puts $term.color("Content ingest complete.", :green)

puts $term.color("Starting content post-processing...", :green)

@p.log_unhandled


puts $term.color("Starting database content ingest...", :green)

@p.database_ingests

puts $term.color("Database content ingest complete.", :green)



@p.post_process


# Generating xml
#
#


puts $term.color("Post-processing complete.", :green)

puts $term.color("Generating XML...", :green)

path = @p.to_xml :name => 'techlink-content'

SanityCheck.summary path

puts $term.color("XML created at #{path}.", :green)
