module EzPub
  class File < EzPub::Handler
    EzPub::Handlers::All << self
    EzPub::Handlers::Static << self

    extend StaticCopy
    extend NameMaker

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

        exts = /\.#{EZP_ICON_BINARY_EXTENSIONS.join('|')}$/

        if ::File.binary?(path)

          if exts.match(path)
            true
          else
            Logger.warning path, 'Unknown ext attempted by File'
            false
          end

        else
          false
        end
      end
    end


    def self.store(path)
      dest = move_to_files path

      $r.log_key(path)

      $r.hset path, 'id', $r.get_id

      $r.hset path, 'parent', CONFIG['ids']['files']

      $r.hset path, 'priority', '0'

      $r.hset path, 'type', 'file'

      $r.hset path, 'fields', 'file:ezbinaryfile,name:ezstring'

      $r.hset path, 'field_file', dest
      $r.hset path, 'field_name', pretify_filename(dest)
    end
  end
end
