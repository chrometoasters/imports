module EzPub
  class Review < EzPub::Handler
    EzPub::HandlerSets::All << self
    EzPub::HandlerSets::Content << self

    extend IncludeOrPage
    extend IncludeResolver
    extend FieldParsers
    extend TechlinkUrl
    extend StaticCopy
    extend ImportPathHelper

    # Identifying general_content is primarily a case of elimination.
    # We place general_content last among our content handlers as

    def self.priority
      25
    end


    def self.mine?(path)
      response = nil
      if page?(path)

        # Narrow down to the section

        if path =~ /\/teaching-snapshot\/Resource-Reviews\/.+\.htm$/i
          response = true
        end
      end

      response
    end


    def self.store(path)
      if has_valid_index? path
        path = path + '/' unless path =~ /\/$/
      end

      filepath = path

      $r.log_key(path)

      #$r.hset path, 'parent', parent_id(path)

      $r.hset path, 'id', $r.get_id(path)

      $r.hset path, 'priority', '0'

      $r.hset path, 'type', 'case_study'

      $r.hset path, 'fields', 'old_site_url:ezstring,title:ezstring,image:ezimage,introduction:ezxmltext,description:ezxmltext,curriculum_links:ezxmltext,content:ezxmltext,ease_of_use:ezxmltext,rating:ezxmltext,accessibility:ezxmltext'

      $r.hset path, 'field_old_site_url', techlink_url(path + '#case_study')

      # Resolve includes and get a nokogiri doc at the same time.

      @doc = resolve_includes(filepath, :return => :doc)


      title = get_review_title(@doc, path)

      if title
        $r.hset path, 'field_title', title
      else
        $r.hset path, 'field_title', 'REVIEW TITLE NOT FOUND'
      end


      description = get_review_element(@doc, /^description/i)

      if description
        $r.hset path, 'field_description', description
      else
        $r.hset path, 'field_description', ''
      end


      curriculum_links = get_review_element(@doc, /^curriculum/i)

      if curriculum_links
        $r.hset path, 'field_curriculum_links', curriculum_links
      else
        $r.hset path, 'field_curriculum_links', ''
      end


      content = get_review_element(@doc, /^content/i)

      if content
        $r.hset path, 'field_content', content
      else
        $r.hset path, 'field_content', ''
      end


      ease = get_review_element(@doc, /^ease/i)

      if ease
        $r.hset path, 'field_ease_of_use', ease
      else
        $r.hset path, 'field_content', ''
      end


      rating = get_review_element(@doc, /^rating/i)

      if rating
        $r.hset path, 'field_rating', rating
      else
        $r.hset path, 'field_content', ''
      end


      accessibility = get_review_element(@doc, /^accessibility/i)

      if accessibility
        $r.hset path, 'field_accessibility', accessibility
      else
        $r.hset path, 'field_content', ''
      end

      dest = move_to_images(get_review_image_path(@doc, path))

      $r.hset path, 'field_image', trim_for_ezp(dest)

      # Register general content for post_processing.
      PostProcessor.register path
    end
  end
end
