class LinkHelpers
  # Helper class for creating internal links.

  # LinkHelpers.parse('/thing.htm') returns a linkhelper object providing
  # #path #key and #anchor accessors.

  def self.parse(path, context_path)
    # Make link absolute (without the full key path) => '/some/page.html'
    if path !~ /^\//
      path = context_path._parentize + '/' + path
    end

    # Return a new linkhelper object.
    self.new(path)
  end


  attr_accessor :key, :path, :anchor


  def initialize(path)
    # Normalize away /index.html
    path.gsub!(/\/index\.html?/, '')

    # Parse and store anchor.
    if m = /#\w+$/.match(path)
      @anchor = m[0]
    else
      @anchor = nil
    end

    # Remove anchor for path and key values.
    path.gsub!(/#\w+$/, '')

    @key = CONFIG['directories']['input'] + path

    @path = path
  end

  # LinkHelpers.special_resolvers(path) runs a number of messy checks for
  # for exceptional link resolutions, returning either a remote_id or
  # nil.

  def self.special_resolvers(path)
    response = nil

    # Send all glossary item links to glossary parent, for now.
    if path =~ /(GlossaryItem|glossarylist|glossary)\.htm\?\w+=/i
      response = CONFIG['ids']['glossary']
    end

    response
  end
end
