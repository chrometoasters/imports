class Processor

  # Pass in an optional input folder and handlers constant.

  def initialize(opts = {})
    @root = opts[:root] || CONFIG['directories']['input']
    @handlers = opts[:handlers] || EzPub::Handlers::All
  end


  # Main script loop.
  # Runs through our list of files/folders, passing each to the
  # EzPub::Handlers constants for handling.

  def ingest
    list.each do |path|
      unless handle path
        Logger.warning path, "Unhandled by #{@handlers}", 'shh'
      end
    end
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
