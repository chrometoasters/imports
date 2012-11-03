module ActsAsIndex
  include IsARedirect

  def acts_as_index?(path)
    redirect = redirect? path._parentize + 'index.htm'
    if redirect
      link = LinkHelpers.parse(redirect, path)

      if link.key.downcase == path.downcase
        true
      end
    else
      false
    end
  end


  def has_remote_index?(path)
    redirect = redirect? path + 'index.htm'

    if redirect
      link = LinkHelpers.parse(redirect, path)

      if link.key._parentize.downcase != path.downcase && !$r.exists(link.key)
        return false
      end

      if link.key != /index\.htm$/i && link.key != /\/$/
        return link.key
      end

    else
      return false
    end

  end
end
