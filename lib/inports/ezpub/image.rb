module EzPub
  class Image < EzPub::Handler
    EzPub::Handlers::All << self
    EzPub::Handlers::Static << self

    include StaticCopy

    def self.priority
      99
    end


    def self.mine?(path)
      # Stops ptools throwing an exception in the unlikely event
      # of a previously unhandled directory.

      unless ::File.directory? path

        # Check if an image - basic check from ptools gem.

        ::File.image? path
      end
    end


    def self.store(path)
      puts path
    end
  end
end
