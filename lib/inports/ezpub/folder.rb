module EzPub
  class Folder < EzPub::Handler
    EzPub::HandlerSets::All << self
    EzPub::HandlerSets::Content << self

    extend NameMaker
    extend IsARedirect
    extend HasValidIndex
    extend IncludeOrPage
    extend ActsAsIndex

    def self.priority
      49
    end


    def self.mine?(path)
      # Identify folders without index.htm files.
      if ::File.directory?(path) && !has_valid_index?(path)
        true
      else
        false
      end
    end


    def self.store(path)
      # Sanity check.
      if has_valid_index?(path)
        raise NotJustAFolder, "#{path} has an index.htm!"
      end

      path = path + '/' unless path =~ /\/$/

      # Give precedence to key that already exists.
      #
      # For more information see ActsAsIndex module.

      if $r.exists(path)
        return nil
      end


      # Rekey another item if this folder's index redirects to that item.
      if has_remote_index? path
        replacement = has_remote_index? path

        # Check if its referent exists, if so, simply key as that item.
        # So that anything calling #parent_id gets this remote id.
        if $r.hget(replacement, 'id')
          new_id = $r.hget(replacement, 'id')

          $r.hset path, 'id', new_id
        end

        if !$r.hget(replacement, 'id') && page?(replacement)
          # In the event that we're keying a page that doesn't exist yet,
          # we check it's a valid page, and that it's a valid page.
          # We then set its id ahead of time, which $redis.get_id(path) will
          # now respect, and return.

          $r.hset replacement, 'id', new_id

          # Now set this key as having that id also, so that #get_parent(path)
          # will still function as expected.

          new_id = $r.hget(replacement, 'id')

          $r.hset path, 'id', new_id

          # And remove this folder from the keys list so it isn't in the xml.
          $r.lrem 'keys', 1, path

          puts path
          # Check that that actuall works.
        end

        Logger.warning path, 'Underwent remote index rekey'

        # Just create the folder as normal otherwise:
      else
        $r.log_key(path)

        $r.hset path, 'parent', parent_id(path)

        $r.hset path, 'id', $r.get_id(path)

        $r.hset path, 'priority', '0'

        $r.hset path, 'type', 'folder'

        $r.hset path, 'fields', 'name:ezstring'

        $r.hset path, 'field_name', pretify_foldername(path)
      end
    end
  end
end
