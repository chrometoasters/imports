class Processor
  # The Processor provides the main script loops - supplying input for
  # migration via #list, ingesting the content, post_processing content via
  # its PostProcessor mixin, and outputing data via #to_xml.


  # PostProcessor handles the sanitization and conversion of ezpublish content
  # after the initial ingest. It takes stored field content from $r and
  # performs actions sucgh as tag substitution and link resolution.
  include PostProcessor

  # Pass in an optional input folder and handlers constant.

  def initialize(opts = {})
    @root = opts[:root] || CONFIG['directories']['input']
    @handlers = opts[:handlers] || EzPub::HandlerSets::All
  end


  # Main script loop.
  # Runs through our list of files/folders, passing each to the
  # EzPub::Handlers constants for handling.

  def ingest
    list.each do |path|
      unless handle path
        Logger.warning path, "Unhandled", 'shh'
      end
    end
  end


  # Wrapper for xml export.
  #
  # Takes an optional array of keys (uses main list by default).
  # Dir and filename option can also be passed on to Formatter::XML.

  def to_xml(opts={})
    keys = opts[:keys] || $r.lrange('keys', 0, -1)
    dir = opts[:dir]
    name = opts[:name]

    formatter = Formatter::XML.new
    formatter.output keys, :dir => dir, :name => name
  end


  # Iterates through the handlers
  # calling ::mine? on each.
  #
  # If a class accepts the item, its ::store method is called.

  def handle(path)
    @handlers.sort! { |a,b| a.priority <=> b.priority }

    handled = @handlers.each do |type|
      if type.mine? path
        type.store path
        return true
      end
    end

    handled == true ? true : false
  end


  def list
    Dir.glob(@root + "**/**/**")
  end
end
