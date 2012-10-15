require './lib/inports'

@p = Processor.new(:handlers => EzPub::Handlers::All)

@p.ingest

@p.post_process

@p.to_xml :name => 'static_files'
