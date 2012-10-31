module EzPub
  class CaseStudyLandingPage < EzPub::Handler
    EzPub::HandlerSets::All << self
    EzPub::HandlerSets::Content << self

    extend NameMaker
    extend IncludeOrPage
    extend IncludeResolver
    extend FieldParsers
    extend HasValidIndex
    extend TechlinkUrl

    # Identifying general_content is primarily a case of elimination.
    # We place general_content last among our content handlers as

    def self.priority
      19
    end


    def self.mine?(path)
      response = nil

      if page?(path)

        # Narrow down to the section

        if path =~ case_study_landing_pages_regex
          response = true
        end
      end

      response
    end


    def self.case_study_landing_pages_regex
      urls = [
        'case-studies/Classroom-practice/',
        'Case-studies/Classroom-practice/materials/',
        'Case-studies/Classroom-practice/Food-and-Biological/',
        'Case-studies/Classroom-practice/ICT/',
        'Case-studies/Classroom-practice/Electronics/',
        'Case-studies/Classroom-practice/Teaching-Practice/',
        'Case-studies/Classroom-practice/Graphics/',

        'case-studies/Technological-practice/',
        'Case-studies/Technological-practice/materials/',
        'Case-studies/Technological-practice/soft-materials/',
        'Case-studies/Technological-practice/Food-and-Biological/',
        'Case-studies/Technological-practice/Electronics/',
        'Case-studies/Technological-practice/ICT/',
      ]

      escaped_urls = []

      urls.map do |str|
        escaped_urls << Regexp.escape(CONFIG['directories']['input'] + str) + '$'
      end

       /#{escaped_urls.join('|')}/i
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

      filepath = path

      $r.log_key(path)

      $r.hset path, 'parent', parent_id(path)

      $r.hset path, 'id', $r.get_id(path)

      $r.hset path, 'priority', '0'

      $r.hset path, 'type', 'case_study_landing_page'

      $r.hset path, 'fields', 'old_site_url:ezstring,title:ezstring,body:ezxmltext'

      $r.hset path, 'field_old_site_url', techlink_url(path + '#case_study_landing_page')

      # Resolve includes and get a nokogiri doc at the same time.

      @doc = resolve_includes(filepath, :return => :doc)

      title = get_case_study_landing_page_title(@doc, path)

      if title
        $r.hset path, 'field_title', title
      else
        $r.hset path, 'field_title', 'CASE STUDY LANDING PAGE TITLE NOT FOUND'
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
