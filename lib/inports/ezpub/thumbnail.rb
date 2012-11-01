module EzPub
  class Thumbnail < EzPub::Handler
    EzPub::HandlerSets::All << self
    EzPub::HandlerSets::Static << self

    # EzPub::Thumbnail runs immediately before EzPub::Image, so that thumbnails
    # are out of the way.

    def self.priority
      98
    end


    def self.mine?(path)
      response = false

      # Stops ptools throwing an exception in the unlikely event
      # of a previously unhandled directory.

      unless ::File.directory? path

        # Check if an image - basic check from ptools gem.

        exts = /\.#{EZP_ICON_IMAGE_EXTENSIONS.join('$|\.')}$/i

        if exts.match(path.downcase)

          # Check the extension is a thumbnail.
          # This is pretty inexact currently, and may cause issues for links.
          #
          # Link resolution should throw an exception if a thumbnail turns out
          # to be important.

          if path =~ /\/thumbs\/|\/thumbnails\/|-thumbnail\.\w{3,4}|-thumb\.\w{3,4}/
            response = true
          end
        end
      end
      response
    end


    def self.store(path)
      Logger.warning path, 'ignored as thumb', 'shhh'
    end
  end
end
