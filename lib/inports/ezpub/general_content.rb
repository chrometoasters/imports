module EzPub
  class GeneralContent < EzPub::Handler
    EzPub::HandlerSets::All << self
    EzPub::HandlerSets::Content << self

    extend NameMaker
    extend IncludeOrPage
    extend IncludeResolver
    extend FieldParsers

    # Identifying general_content is primarily a case of elimination.
    # We place general_content last among our content handlers as

    def self.priority
      50
    end


    def self.mine?(path)
      if page?(path) || ::File.exists?(path + '/index.htm')
        true
      else
        false
      end
    end


    def self.store(path)
      filepath = path

      unless page? path
        if ::File.exists? path + '/index.htm'
          filepath = path + '/index.htm'
        else
          raise JustAFolder, "#{path} has no index.htm!"
        end
      end


      $r.log_key(path)

      $r.hset path, 'id', $r.get_id

      $r.hset path, 'parent', parent_id(path)

      $r.hset path, 'priority', '0'

      $r.hset path, 'type', 'general_content'

      $r.hset path, 'fields', 'title:ezstring,body:ezxmltext'

      # Resolve includes and get a nokogiri doc at the same time.

      @doc = resolve_includes(filepath, :return => :doc)


      title = get_title(@doc)

      if title
        $r.hset path, 'field_title', title
      else
        $r.hset path, 'field_title', 'TITLE NOT FOUND'
        Logger.warning path, 'No title found'
      end


      body = get_body(@doc)

      if body
        $r.hset path, 'field_body', body
      else
        $r.hset path, 'field_body', 'BODY NOT FOUND'
        Logger.warning path, 'Body not found'
      end

      # Register general content for post_processing.
      PostProcessor.register path
    end
  end
end
