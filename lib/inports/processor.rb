class Processor
  # The Processor provides the main script loops - supplying input for
  # migration via #list, ingesting the content, post_processing content via
  # its PostProcessor mixin, and outputing data via #to_xml.


  # PostProcessor handles the sanitization and conversion of ezpublish content
  # after the initial ingest. It takes stored field content from $r and
  # performs actions sucgh as tag substitution and link resolution.
  include PostProcessor

  # Pass in an optional input folder and handlers constant.

  @@runs = 0

  def initialize(opts = {})
    @root = opts[:root] || CONFIG['directories']['input']
    @handlers = opts[:handlers] || EzPub::HandlerSets::All
    @database_importers = opts[:database_importers] || DatabaseImporters::Importers::All
  end


  # Runs through our list of files/folders, passing each to the
  # EzPub::Handlers constants for handling.

  def ingest
    list.each do |path|
      unless handle path

        # Given multiple runs of #ingest, we track unhandled items in
        # a set, adding paths as they fail handling.
        #
        # These are then logged in Processor#log_unhandled

        unless path =~ /\.cfm$/
          $r.sadd "unhandled-#{@@runs}", path
        end
      end
    end

    # Increment run count to distinguish unhandled sets.
    @@runs += 1
  end


  # Runs through the various techlink database importers, creating their
  # associated content. See ./lib/inports/database_importers/

  def database_ingests
    @database_importers.sort! { |a,b| a.priority <=> b.priority }

    @database_importers.each do |importer|
      importer.run
    end
  end


  # See comments for Processor#ingest

  def log_unhandled
    sets = []

    # Use @@runs count to collect up our unhandled set keys.
    @@runs.times {|i| sets << "unhandled-#{i}"}

    # Iterate through the intersection of these sets.
    # This should be all paths unhandled in any run.

    $r.sinter(*sets).each do |k|
      Logger.warning k, 'Unhandled', 'shh'
    end

    $r.del sets
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
