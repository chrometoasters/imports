module EzPub
  class Showcase < EzPub::Handler
    EzPub::HandlerSets::All << self
    EzPub::HandlerSets::Content << self

    extend NameMaker
    extend IncludeOrPage
    extend IncludeResolver
    extend FieldParsers
    extend StaticCopy
    extend ImportPathHelper
    extend TechlinkUrl
    extend HasValidIndex
    extend ActsAsIndex

    # Identifying general_content is primarily a case of elimination.
    # We place general_content last among our content handlers as

    def self.priority
      31
    end


    def self.mine?(path)
      response = nil

      if page?(path)

        # Narrow down to the section

        if path =~ /student-showcase\/(\w|-|_)+\/(\w|-|_)+\.htm$/i
          response = true
        end
      end

      response
    end


    def self.strip_redundant_content(doc)
      if doc.css('div#content').css('img').first
        doc.css('div#content').css('img').first.remove
      end

      doc.css('div#content').css('a').each do |link|
        if link.content.empty?
          link.remove
        end
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

      $r.hset path, 'type', 'showcase'

      $r.hset path, 'fields', 'old_site_url:ezstring,title:ezstring,image:ezimage,body:ezxmltext'

      $r.hset path, 'field_old_site_url', techlink_url(path + '#showcase')

      # Resolve includes and get a nokogiri doc at the same time.

      @doc = resolve_includes(filepath, :return => :doc)

      title = get_title(@doc, path)

      if title
        $r.hset path, 'field_title', title
      else
        $r.hset path, 'field_title', 'SHOWCASE TITLE NOT FOUND'
        Logger.warning path, 'No title found'
      end

      image_path = get_showcase_image_path(@doc, path)

      if image_path
        dest = move_to_images(image_path)

        if dest
          $r.hset path, 'field_image', trim_for_ezp(dest)
        else
          Logger.warning path, 'Variable in image path'
        end

      else
        Logger.warning path, 'No image field path found'
      end

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
