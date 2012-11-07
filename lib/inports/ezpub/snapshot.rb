module EzPub
  class Snapshot < EzPub::Handler
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
    extend Descriptions

    def self.priority
      37
    end


    def self.mine?(path)
      response = nil

      if page?(path)

        # Narrow down to the section

        if path =~ /teaching-snapshot\/(Y01-06-Junior|Y07-10-Middle|Y12-13-Senior|Y11-Senior)\/(\w|-|_)+\.htm$/i
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


    def self.find_parent(path)
      parent = nil
      # Add to list now, if it's not already there.

      if path =~ /\/teaching-snapshot\/y01-06-junior\/(\w|-|_)+\.htm$/i
        landing_page = './input/teaching-snapshot/y01-06-junior/'
        parent = $r.get_id landing_page
        $r.log_key landing_page
      end

      if path =~ /\/teaching-snapshot\/y07-10-middle\/(\w|-|_)+\.htm$/i
        landing_page = './input/teaching-snapshot/y07-10-middle/'
        parent = $r.get_id landing_page
        $r.log_key landing_page
      end

      if path =~ /\/teaching-snapshot\/y12-13-senior\/(\w|-|_)+\.htm$/i
        landing_page = './input/teaching-snapshot/y12-13-senior/'
        parent = $r.get_id landing_page
        $r.log_key landing_page
      end

      if path =~ /\/teaching-snapshot\/y11-senior\/(\w|-|_)+\.htm$/i
        landing_page = './input/teaching-snapshot/y11-senior/'
        parent = $r.get_id landing_page
        $r.log_key landing_page
      end

      parent
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
      end

      parent = find_parent(path)

      if parent
        $r.hset path, 'parent', parent
      else
        $r.hset path, 'parent', parent_id(path)
      end

      # Handled differently here.
      # We log the key after #find_parent since find_parent may be declaring the
      # parent object, which needs to be first in the keys list.

      $r.log_key(path)


      $r.hset path, 'id', $r.get_id(path)

      $r.hset path, 'priority', '0'

      $r.hset path, 'type', 'snapshot'

      $r.hset path, 'fields', 'description:ezxmltext,old_site_url:ezstring,title:ezstring,image:ezimage,body:ezxmltext'

      $r.hset path, 'field_old_site_url', techlink_url(path + '#snapshot')

      # Resolve includes and get a nokogiri doc at the same time.

      @doc = resolve_includes(filepath, :return => :doc)

      title = get_title(@doc, path)

      if title
        $r.hset path, 'field_title', title
      else
        $r.hset path, 'field_title', 'SNAPSHOT TITLE NOT FOUND'
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

      description = get_db_description(path)

      if description
        puts description.class
        $r.hset path, 'field_description', description
      else
        Logger.warning path, 'Description not found'
      end

      # Register general content for post_processing.
      PostProcessor.register path
    end
  end
end
