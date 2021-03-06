module EzPub
  class ReviewsLandingPage < EzPub::Handler
    EzPub::HandlerSets::All << self
    EzPub::HandlerSets::Content << self

    extend IncludeOrPage
    extend IncludeResolver
    extend FieldParsers
    extend TechlinkUrl
    extend StaticCopy
    extend ImportPathHelper
    extend ActsAsIndex

    # Identifying general_content is primarily a case of elimination.
    # We place general_content last among our content handlers as

    def self.priority
      24
    end


    def self.mine?(path)
      response = nil
      if page?(path)

        # Narrow down to the section

        if path =~ /\/teaching-snapshot\/Resource\-Reviews\/?$/i
          response = true
        end
      end

      response
    end


    def self.strip_redundant_content(doc)
      if doc.css('p.subsubhead').first
        doc.css('p.subsubhead').xpath('following-sibling::*').remove
        doc.css('p.subsubhead').remove
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

      filepath = path # save filepath in case of rekeying.

      if acts_as_index? path
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

      $r.hset path, 'type', 'reviews_landing_page'

      $r.hset path, 'fields', 'old_site_url:ezstring,title:ezstring,body:ezxmltext'

      $r.hset path, 'field_old_site_url', techlink_url(path + '#reviews_landing_page')

      # Resolve includes and get a nokogiri doc at the same time.

      @doc = resolve_includes(filepath, :return => :doc)

      $r.hset path, 'field_title', 'Resource Reviews'


      if @doc.css('div#content').first
        $r.hset path, 'field_body', strip_redundant_content(@doc.css('div#content').first)
      else
        $r.hset path, 'field_body', 'BODY NOT FOUND'
        Logger.warning path, 'Body not found'
      end


      # Register general content for post_processing.
      PostProcessor.register path
    end
  end
end
