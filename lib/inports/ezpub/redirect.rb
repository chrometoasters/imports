module EzPub
  class Redirect < EzPub::Handler
    EzPub::HandlerSets::All << self
    EzPub::HandlerSets::Content << self

    extend IsARedirect

    # Identifying redirects, and then ignore them.
    # Runs before content classes so they don't have to deal
    # with this nonsense.

    def self.priority
      1
    end


    def self.mine?(path)
      # Check it's a page.
      if page?(path)
        # Check if it's a redirect.
        if redirect?(path)
          true
        else
          false
        end
      else
        false
      end
    end


    def self.store(path)
      Logger.warning path 'ignored redirect', 'shhh'
    end
  end
end
