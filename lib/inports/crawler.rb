class Crawler
  include Logger

  def initialize(root = CONFIG['directories']['input'])
    @root = root
  end


  # Main script loop.
  # Runs through our list of files/folders, passing each to the
  # EzObject children for handling.

  def run
    list.each do |path|
      unless EzObject.handle path
        Logger.warning path, 'unhandled'
      end
    end
  end


  def list
    Dir.glob(@root + "**/**/**")
  end
end
