module EzPub
  class File < EzPub::Handler
    EzPub::Handlers::All << self
    EzPub::Handlers::Static << self

    include StaticCopy

    def self.priority
      # I should run nearly last,
      # to keep my ::mine? check simple.
      100
    end


    def self.mine?(path)
      # Stops ptools throwing an exception in the unlikely event
      # of a previously unhandled directory.

      unless ::File.directory? path

        # Check if an image - basic check from ptools gem.

        if ::File.image? path
          raise BadHandlerOrder, "#{path} flagged as image from generic File handler."
        end

        # ::binary? method from ptools gem.
        #
        # It performs a "best guess" based on a simple test
        # of the first +File.blksize+ characters.

        ::File.binary?(path)
      end
    end


    def self.store(path)
      puts '!!!!!!!!!!!!!!!!!!!'
    end
  end
end
