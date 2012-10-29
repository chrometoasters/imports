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

      response
    end


    def self.regex_list
      escaped_urls = [
        'interview.htm', 'tdl.html', 'google.htm', 'index-wide.htm', 'copyright popups.html',
        'latest-TS.htm', 'index-teachers-wide.htm', 'scholarship', 'scholarship/index-2009.htm',
        'scholarship/index.htm',
      ]

      escaped_urls.each do |str|
        str = Regexp.escape(CONFIG['directories']['input'] + str)
      end

      /#{escaped_urls.join('$|\.')}$/i
    end


    def self.store(path)
      Logger.warning path, 'ignored-by-ignorable-handler', 'shhh'
    end
  end
end
