class Crawler
  def initialize(root = CONFIG['directories']['input'])
    @root = root
  end


  def run
    list.each do |path|
      next if EzObject.dispatch path
    end
  end


  private


  def list
    Dir.glob(@root + "**/**/**")
  end
end
