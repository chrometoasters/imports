require './lib/inports'

@p = Processor.new(:handlers => EzPub::Handlers::Static)

@p.ingest

@p.to_xml :name => 'static_files'
