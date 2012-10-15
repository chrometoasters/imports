module EzPub
  class MediaFolder < EzPub::Handler
    # This handler is kept out of the main list.

    extend NameMaker

    def self.priority
      0
    end


    def self.mine?(path)
      # This should never be called via ::mine?, so raise an exception if it is.

      raise BadHandlerOrder, "MediaFolder should not be in the main list of handlers. It's special."
    end


    def self.store(path)
      $r.log_key(path)

      $r.hset path, 'id', $r.get_id

      begin
        parent = parent_id path

      rescue Orphanity

        case /media:([^:]+)/.match(path)[1]

        when 'images'
          parent = CONFIG['ids']['images']
        when 'files'
          parent = CONFIG['ids']['files']
        else
          raise "Serious problem - unhandled MediaFolder parent"
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
