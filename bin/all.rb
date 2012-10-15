require './lib/inports'

@p = Processor.new(:handlers => EzPub::HandlerSets::All)

@p.ingest

@p.post_process

@p.to_xml :name => 'static_files'
