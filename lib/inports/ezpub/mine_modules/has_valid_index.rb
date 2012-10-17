module HasValidIndex
  include IsARedirect

  def has_valid_index?(path)
    response = false

    if ::File.exists?(path + '/index.htm') || ::File.exists?(path + '/index.html')
      unless redirect?(path + '/index.htm') || redirect?(path + '/index.html')
        response = true
      end
    end

    response
  end
end
