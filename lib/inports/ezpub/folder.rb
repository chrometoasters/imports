module EzPub
  class Folder < EzPub::Handler
    EzPub::HandlerSets::All << self
    EzPub::HandlerSets::Content << self

    extend NameMaker
    extend IsARedirect
    extend HasValidIndex

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

      $r.log_key(path)

      $r.hset path, 'parent', parent_id(path)

      $r.hset path, 'id', $r.get_id

      $r.hset path, 'priority', '0'

      $r.hset path, 'type', 'folder'

      $r.hset path, 'fields', 'name:ezstring'

      $r.hset path, 'field_name', pretify_foldername(path)
    end
  end
end
