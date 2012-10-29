module IncludeOrPage
  include IsARedirect
  include HasValidIndex

  # Treats directory paths containing valid index.htm(l)? files as
  # pages.

  def page?(path)
    response = false

    # Check this is a page path.
    if path =~ /.(htm|html)$/

      # Check it's not an index,
      # as these are handled in their ./path/ form.

      if path !~ /index\.(htm|html)$/
        response = true
      end

    else
      if has_valid_index?(path)
        response = true
      end
    end

    response
  end


  def include?(path)
    path =~ /.cfm$/ ? true : false
  end
end
