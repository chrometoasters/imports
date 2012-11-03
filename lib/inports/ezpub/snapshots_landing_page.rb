module EzPub
  class SnapshotsLandingPage < EzPub::Handler
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
      36
    end


    def self.mine?(path)
      response = nil

      if page?(path)
        # Narrow down to the section

        if path =~ snapshots_landing_page_regex
          response = true
        end
      end

      response
    end


    def self.snapshots_landing_page_regex
      urls = [
        'teaching-snapshot/TS.htm',
        'teaching-snapshot/Y01-06-Junior/',
        'teaching-snapshot/Y07-10-Middle/',
        'teaching-snapshot/Y12-13-Senior/',
      ]

      escaped_urls = []

      urls.map do |str|
        escaped_urls << Regexp.escape(CONFIG['directories']['input'] + str) + '?$'
      end

       /#{escaped_urls.join('|')}/i
    end



    def self.strip_redundant_content(doc)
      # if doc.css('p.header').first
      #   doc.css('p.header').remove
      # end

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

      filepath = path # save filepath in case of rekeying.

      if acts_as_index? path
        puts; puts '!!!!!!!!:  ' + path; puts

        $r.rpush 'pseudo-keys', path

        path = path._parentize

        unless $r.exists(path)
          raise Orphanity "During rekeying, #{path} attempted to rekey as parent which doesn't exist already."
        end

      else
        # We only log the key if we're declaring a truly new object.
        # (It's already been declared as a folder previously)
        $r.log_key(path)
      end

      $r.hset path, 'parent', parent_id(path)

      $r.hset path, 'id', $r.get_id(path)

      $r.hset path, 'priority', '0'

      $r.hset path, 'type', 'snapshots_landing_page'

      $r.hset path, 'fields', 'old_site_url:ezstring,title:ezstring,body:ezxmltext'

      $r.hset path, 'field_old_site_url', techlink_url(path + '#snapshots_landing_page')

      # Resolve includes and get a nokogiri doc at the same time.

      @doc = resolve_includes(filepath, :return => :doc)

      title = get_title(@doc, path)

      if title
        $r.hset path, 'field_title', title
      else
        $r.hset path, 'field_title', 'SNAPSHOT LANDING PAGE TITLE NOT FOUND'
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
