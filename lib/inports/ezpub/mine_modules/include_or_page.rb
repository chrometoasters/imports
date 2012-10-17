module IncludeOrPage
  def page?(path)
    if path =~ /.(htm|html)$/
      if path !~ /index\.(htm|html)$/
        true
      else
        false
      end
    else
      if ::File.exists?(path + '/index.htm')
        true
      else
        false
      end
    end
  end


  def include?(path)
    path =~ /.cfm$/ ? true : false
  end
end
