module ActsAsIndex
  include IsARedirect

  def acts_as_index?(path)
    redirect = redirect? path._parentize + 'index.htm'
    if redirect
      link = LinkHelpers.new(redirect)

      if link.key == path
        true
      end
    else
      false
    end
  end


  def has_remote_index?(path)
    redirect = redirect? path + 'index.htm'

    if redirect
      link = LinkHelpers.new(redirect)

      if link.key != /index\.htm$/ && link.key != /\/$/
        link.key
      end

    else
      false
    end

  end
end
