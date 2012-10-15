module EzPub
  class MediaFolder < EzPub::Handler
    # This handler is kept out of the main list.
    #
    # It is only used by the MediaPathHelper module for
    # creation of parallel heirarchies of folders in the
    # eZPublish Media Library.

    extend NameMaker

    def self.priority
      0
    end


    def self.mine?(path)
      # This should never be called via ::mine?, so raise an exception if it is.

      raise BadHandlerOrder, "MediaFolder should not be in the main list of handlers. It's special."
    end


    def self.store(path)
      # Paths passed to MediaFolder::store should be of the non-standard form:
      #
      # media:files:./input/etc/etc
      # or
      # media:images:./input/etc/etc

      unless path =~ /^media:\w+:\.\//
        raise BadPath, "Passed a non media path to MediaFolder::store."
      end

      $r.log_key(path)

      $r.hset path, 'id', $r.get_id

      begin
        parent = parent_id path

      # Since orphanity, in this case, could just mean that we've bottomed out
      # on the non-standard /files and /images folders, we test for that before
      # raising a general exception.

      rescue Orphanity

        # This hard codes the expectation that input paths will begin with '.'.
        #
        # It checks that this is legitmately a bottom level path.

        if path._parentize =~ /^media:\w+:\.$/

          case /media:([^:]+)/.match(path)[1]

          # Case switch for appropriate folder values in
          # config file.

          when 'images'
            parent = CONFIG['ids']['images']
          when 'files'
            parent = CONFIG['ids']['files']
          else
            raise BadPath, "Unhandled MediaFolder parent due to no matches in predefined folders."
          end

        else
          raise Orphanity, "Unhandled MediaFolder parent. Unhandled path didn't bottom out as expected."
        end
      end

      $r.hset path, 'parent', parent

      $r.hset path, 'priority', '0'

      $r.hset path, 'type', 'folder'

      $r.hset path, 'fields', 'name:ezstring'

      $r.hset path, 'field_name', pretify_foldername(path)
    end
  end
end
