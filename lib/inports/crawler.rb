class Crawler
  include Logger

  def initialize(root = CONFIG['directories']['input'])
    @root = root
  end


  # Main script loop.
  # Runs through our list of files/folders, passing each to the
  # EzPub::Handler children for handling.

  def run
    list.each do |path|
      unless EzPub::Handler.handle path
        Logger.warning path, 'unhandled'
      end
    end
  end


  def list
    Dir.glob(@root + "**/**/**")
  end
end
