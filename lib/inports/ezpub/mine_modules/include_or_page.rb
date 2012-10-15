module IncludeOrPage
  def page?(path)
    if path =~ /.html$/
      raise UnexpectedPagelikeFile, 'Encountered an .html path, but only expect .htm.'
    end

    path =~ /.htm$/ ? true : false
  end


  def include?(path)
    path =~ /.cfm$/ ? true : false
  end

end
