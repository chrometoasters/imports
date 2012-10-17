module EzPub
  class File < EzPub::Handler
    EzPub::HandlerSets::All << self
    EzPub::HandlerSets::Static << self

    extend StaticCopy
    extend NameMaker
    extend MediaPathHelper
    extend ImportPathHelper

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

        exts = /\.#{EZP_ICON_BINARY_EXTENSIONS.join('|')}$/

        # Use MediaPathHelper module to create a heirarchy of media library
        # folders for this path, if needed.

        unless has_media_path? path, 'files'
          create_media_path(path, 'files')
        end

        if exts.match(path.downcase)
          true
        else
          Logger.warning path, 'Unknown ext for file'
          false
        end

      else
        false
      end
    end


    def self.store(path)
      dest = move_to_files path

      $r.log_key(path)

      $r.hset path, 'id', $r.get_id

      # Pass in a "media:files:./xyz" path, rather than a standard path.
      # (Since we want to match against the various Media locations).

      $r.hset path, 'parent', parent_id(mediaize_path(path, 'files'))

      $r.hset path, 'priority', '0'

      $r.hset path, 'type', 'file'

      $r.hset path, 'fields', 'file:ezbinaryfile,name:ezstring'

      $r.hset path, 'field_file', trim_for_ezp(dest)
      $r.hset path, 'field_name', pretify_filename(dest)
    end
  end
end
