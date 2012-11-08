module EzPub
  class Ignorable < EzPub::Handler
    EzPub::HandlerSets::All << self
    EzPub::HandlerSets::Content << self

    extend IsARedirect
    extend IncludeOrPage

    # Identifying redirects, and then ignore them.
    # Runs before content classes so they don't have to deal
    # with this nonsense.

    def self.priority
      2
    end


    def self.mine?(path)
      response = false

      # Check against our ignore list
      if regex_list.match path
        response = true
      end

      if path =~ /\/print.htm$/i
        response = true
      end

      if path =~ /teaching-snapshot\/Audio_Snapshots/i
        response = true
      end

      if path =~ /\/svcore\/|\/svcore/i
        response = true
      end

      if path =~ /\/simpleviewer.swf/i
        response = true
      end

      if path == /\/Print-PDFs\/|\/Print-PDFs/i
        response = true
      end

      if path == /\/menunav\/|\/menunav/i
        response = true
      end

      if path == /\/thumbs\/|\/thumbs/i
        response = true
      end

      if path == /\/images\/|\/images/i
        response = true
      end

      # if path.gsub(CONFIG['directories']['input'], '') =~ /^index(\-\w+(\-\w+)?)?\.html?$/
      #   response = true
      # end

      # if path =~ /\/images\/?/i || path =~ /\/resources\/?/i
      #   response = true
      # end

      response
    end


    def self.regex_list
      tailed_urls = [
        'interview.htm', 'tdl.html', 'about.htm', 'index-teachers.htm', 'google.htm',
        'index-wide.htm', 'index-student-wide.htm',
        'copyright popups.html', 'AAS.htm',
        'latest-TS.htm', 'index-teachers-wide.htm', 'subscribe.htm', 'Event.htm', 'Item.htm',
        'accessibility.htm',
        'Teacher_Education/In-service/Ask-an-expert', 'career.htm', 'contact.htm',
        'copyright popups.html',
        'disclaimer.htm', 'error.htm', 'feedback.htm', 'glossary.htm', 'glossaryItem.htm',
        'glossarylist-enhanced.htm',
        'glossarylist.htm', 'sitemap.htm', 'subscribe.htm', 'tbd-assessment.html',
      ]

      bucket_urls = [
        'ts', 'tki', 'styles',
        'people-in-technology', 'parents', 'latest-news', 'images', 'gallery-images', 'TPP',
        'Right-links',
        'Resources', 'RSS', 'PTTER-framework', 'Navigation', 'Media', 'scholarship',
        'Teacher_Education/Research',
        'Teacher_Education/Publications'
      ]

      escaped_urls = []

      tailed_urls.map do |str|
        escaped_urls << Regexp.escape(CONFIG['directories']['input'] + str) + '$'
      end

      bucket_urls.map do |str|
        escaped_urls << Regexp.escape(CONFIG['directories']['input'] + str)
      end

      /#{escaped_urls.join('|')}/i
    end


    def self.store(path)
      Logger.warning path, 'ignored-by-ignorable-handler', 'shhh'
    end
  end
end
