module EzPub
  class Image < EzPub::Handler
    EzPub::HandlerSets::All << self
    EzPub::HandlerSets::Static << self

    extend StaticCopy
    extend NameMaker
    extend MediaPathHelper
    extend ImportPathHelper

    # Image is expected to run immediately after EzPub::Thumbnail, which will
    # catch and disregard thumbnails.

    def self.priority
      99
    end


    def self.mine?(path)
      response = false

      # Stops ptools throwing an exception in the unlikely event
      # of a previously unhandled directory.

      unless ::File.directory? path


        # Check if an image - basic check from ptools gem.

        if ::File.image?(path)

          # Check the extension is a valid image extension.

          exts = /\.#{EZP_ICON_IMAGE_EXTENSIONS.join('$|\.')}$/i

          if exts.match(path.downcase)

            # Use MediaPathHelper module to create a heirarchy of media library
            # folders for this path, if needed.

            unless has_media_path? path, 'images'
              create_media_path(path, 'images')
            end

            response = true

          else
            Logger.warning path, 'Unknown ext for image'
          end
        end
      end
      response
    end


    def self.store(path)
      dest = move_to_images path

      $r.log_key(path)

      $r.hset path, 'id', $r.get_id

      # Pass in a "media:files:./xyz" path, rather than a standard path.
      # (Since we want to match against the various Media locations).

      $r.hset path, 'parent', parent_id(mediaize_path(path, 'images'))

      $r.hset path, 'priority', '0'

      $r.hset path, 'type', 'image'

      $r.hset path, 'fields', 'image:ezimage,name:ezstring'

      $r.hset path, 'field_image', trim_for_ezp(dest)
      $r.hset path, 'field_name', pretify_filename(dest)
    end
  end
end
