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

      if path =~ /\/print.htm$/
        response = true
      end

      if path =~ /teaching-snapshot\/Audio_Snapshots/
        response = true
      end

      if path.gsub(CONFIG['directories']['input'], '') =~ /^index(\-\w+(\-\w+)?)?\.html?$/
        response = true
      end

      # REMOVE ME!!!
      if path =~ /gallery\.htm/i || path =~ /\/gallery-(\w|-|_)+\.htm$/i
        response = true
      end

      response
    end


    def self.regex_list
      tailed_urls = [
        'interview.htm', 'tdl.html', 'about.htm', 'google.htm', 'index-wide.htm', 'copyright popups.html',
        'latest-TS.htm', 'index-teachers-wide.htm', 'subscribe.htm', 'Event.htm', 'Item.htm', 'accessibility.htm',
        'Teacher_Education/In-service/Ask-an-expert', 'career.htm', 'contact.htm', 'copyright popups.html',
        'disclaimer.htm', 'error.htm', 'feedback.htm', 'glossary.htm', 'glossaryItem.htm', 'glossarylist-enhanced.htm',
        'glossarylist.htm', 'sitemap.htm', 'subscribe.htm', 'tbd-assessment.html',
      ]

      bucket_urls = [
        'ts', 'tki', 'styles',
        'people-in-technology', 'parents', 'latest-news', 'images', 'gallery-images', 'TPP', 'Right-links',
        'Resources', 'RSS', 'PTTER-framework', 'Navigation', 'Media', 'scholarship', 'Teacher_Education/Research',
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
