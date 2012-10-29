module EzPub
  class Abstract < EzPub::Handler
    EzPub::HandlerSets::All << self
    EzPub::HandlerSets::Content << self

    extend IncludeOrPage
    extend IncludeResolver
    extend FieldParsers

    # Identifying general_content is primarily a case of elimination.
    # We place general_content last among our content handlers as

    def self.priority
      21
    end


    def self.mine?(path)
      response = nil

      if page?(path)

        # Narrow down to the section

        if path =~ /\/Case-studies\/(Classroom-practice|Technological-practice|enterprise)\//

          if has_abstract_header?(path)
            response = true
          end
        end
      end

      response
    end



    def self.has_abstract_header?(path)
      response = nil

      str = StringFromPath.get_case_insensitive(path)
      doc = Nokogiri::HTML(str)

      if doc.css('p.header').first
        if doc.css('p.header').first.content == 'Abstract'
          response = true
        end
      end

      response
    end


    def self.strip_redundant_content(doc)
      # if doc.css('table.cover-table').count == 2
      #   doc.css('table.cover-table').first.remove
      # end

      # doc.css('img').each do |img|
      #   img.remove
      # end

      doc
    end



    def self.store(path)
      if has_valid_index? path
        path = path + '/' unless path =~ /\/$/
      end

      filepath = path

      $r.log_key(path)

      $r.hset path, 'parent', parent_id(path)

      $r.hset path, 'id', $r.get_id(path)

      $r.hset path, 'priority', '0'

      $r.hset path, 'type', 'abstract'

      $r.hset path, 'fields', 'title:ezstring,body:ezxmltext,reference:ezstring'

      # Resolve includes and get a nokogiri doc at the same time.

      @doc = resolve_includes(filepath, :return => :doc)

      title = get_abstract_title(@doc, path)


      if title
        $r.hset path, 'field_title', title
      else
        $r.hset path, 'field_title', 'ABSTRACT TITLE NOT FOUND'
      end

      reference = get_abstract_reference(@doc, path)

      $r.hset path, 'field_reference', reference || 'CATEGORY NOT FOUND'

      # Keep body last as it kills nodes required by other field getters.

      body = get_body(strip_redundant_content(@doc), path)

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
