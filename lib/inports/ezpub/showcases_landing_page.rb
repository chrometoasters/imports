module EzPub
  class ShowcasesLandingPage < EzPub::Handler
    EzPub::HandlerSets::All << self
    EzPub::HandlerSets::Content << self

    extend IncludeOrPage
    extend IncludeResolver
    extend FieldParsers
    extend TechlinkUrl
    extend HasValidIndex
    extend ActsAsIndex

    # Identifying general_content is primarily a case of elimination.
    # We place general_content last among our content handlers as

    def self.priority
      30
    end


    def self.mine?(path)
      response = nil

      if page?(path)
        # Narrow down to the section

        if path =~ showcases_landing_pages_regex
          response = true
        end
      end

      response
    end


    def self.showcases_landing_pages_regex
      urls = [
        'student-showcase/showcases.htm',
        'student-showcase/index-materials-hard.htm',
        'student-showcase/index-materials-soft.htm',
        'student-showcase/index-electronics.htm',
        'student-showcase/index-food.htm',
        'student-showcase/index-ict.htm',
        'student-showcase/index-graphics.htm',
      ]

      escaped_urls = []

      urls.map do |str|
        escaped_urls << Regexp.escape(CONFIG['directories']['input'] + str) + '?$'
      end

       /#{escaped_urls.join('|')}/i
    end



    def self.strip_redundant_content(doc)
      if doc.css('p.header').first
        doc.css('p.header').remove
      end

      doc
    end



    def self.store(path)
      if has_valid_index? path
        path = path + '/' unless path =~ /\/$/
      end

      # Obliterate parent item (by stealing its key) as if this is the
      # index.htm.
      # This makes the safe assumption that the parent has already
      # been declared.

      if acts_as_index? path
        path = path._parentize
      end

      filepath = path

      $r.log_key(path)

      $r.hset path, 'parent', parent_id(path)

      $r.hset path, 'id', $r.get_id(path)

      $r.hset path, 'priority', '0'

      $r.hset path, 'type', 'showcases_landing_page'

      $r.hset path, 'fields', 'old_site_url:ezstring,title:ezstring,body:ezxmltext'

      $r.hset path, 'field_old_site_url', techlink_url(path + '#showcases_landing_page')

      # Resolve includes and get a nokogiri doc at the same time.

      @doc = resolve_includes(filepath, :return => :doc)

      title = get_title_via_navigation(@doc, path)

      if title
        $r.hset path, 'field_title', title
      else
        $r.hset path, 'field_title', 'SHOWCASE LANDING PAGE TITLE NOT FOUND'
        Logger.warning path, 'No title found'
      end


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
