module EzPub
  class Folder < EzPub::Handler
    EzPub::HandlerSets::All << self
    EzPub::HandlerSets::Content << self

    extend NameMaker
    extend IncludeOrPage

    # Identifying general_content is primarily a case of elimination.
    # We place general_content last among our content handlers as

    def self.priority
      49
    end


    def self.mine?(path)
      if ::File.directory?(path) && !::File.exists?(path + '/index.htm')
        true
      else
        false
      end
    end


    def self.store(path)
      if ::File.exists? path + '/index.htm'
        raise NotJustAFolder, "#{path} has an index.htm!"
      end

      $r.log_key(path)

      $r.hset path, 'id', $r.get_id

      $r.hset path, 'parent', parent_id(path)

      $r.hset path, 'priority', '0'

      $r.hset path, 'type', 'folder'

      $r.hset path, 'fields', 'name:ezstring'

      $r.hset path, 'field_name', pretify_foldername(path)
    end
  end
end
