module EzPub
  class CaseStudy < EzPub::Handler
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

    # Identifying general_content is primarily a case of elimination.
    # We place general_content last among our content handlers as

    def self.priority
      20
    end


    def self.mine?(path)
      response = nil

      if page?(path)

        # Narrow down to the section

        if path =~ /\/Case-studies\/(Classroom-practice|Technological-practice)\//
          if has_case_studies_table?(path)
            response = true
          end
        end
      end

      response
    end



    def self.has_case_studies_table?(path)
      response = nil

      str = StringFromPath.get_case_insensitive(path)
      doc = Nokogiri::HTML(str)

      if doc.xpath("//td[@bgcolor='#6D2C91']").first && doc.xpath("//td[@bgcolor='#D2222A']").first
        if doc.xpath("//td[@bgcolor='#6D2C91']").count == 2
          response = true
        end

      elsif doc.xpath("//td[@bgcolor='#AED13C']").first && doc.xpath("//td[@bgcolor='#D2222A']").first
        if doc.xpath("//td[@bgcolor='#AED13C']").count == 2
          response = true
        end
      end

      response
    end


    def self.strip_redundant_content(doc)
      if doc.css('table.cover-table').count == 2
        doc.css('table.cover-table').first.remove
      end

      doc.css('img').each do |img|
        img.remove
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

      $r.hset path, 'type', 'case_study'

      $r.hset path, 'fields', 'old_site_url:ezstring,title:ezstring,cover_image:ezimage,body:ezxmltext,description:ezxmltext,category:ezstring,year_level:ezstring,case_study_date:ezstring'

      $r.hset path, 'field_old_site_url', techlink_url(path + '#case_study')

      # Resolve includes and get a nokogiri doc at the same time.

      @doc = resolve_includes(filepath, :return => :doc)

      title = get_case_study_title(@doc, path)

      if title
        $r.hset path, 'field_title', title
      else
        $r.hset path, 'field_title', 'CASESTUDY TITLE NOT FOUND'
        Logger.warning path, 'No title found'
      end


      dest = move_to_images(get_case_study_image_path(@doc, path))

      $r.hset path, 'field_cover_image', trim_for_ezp(dest)


      details = get_case_study_details(@doc, path)

      $r.hset path, 'field_category', details[:category] || 'CATEGORY NOT FOUND'
      $r.hset path, 'field_year_level', details[:level] || 'LEVEL NOT FOUND'
      $r.hset path, 'field_case_study_date', details[:date] || 'DATE NOT FOUND'

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
        $r.hset path, 'field_description', description
      end

      # Register general content for post_processing.
      PostProcessor.register path
    end
  end
end
