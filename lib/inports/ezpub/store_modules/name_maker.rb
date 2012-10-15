module NameMaker
  def pretify_filename(path)
    # Get just the filename.
    path = /([^\/]+\.\w+)$/.match(path)[0]

    # Remove extension
    path.gsub!(/\.\w+$/, '')

    # Replace characters with spaces.
    path.gsub!(/-|_|\./, ' ')

    # Sentence case
    path.downcase!
    path.slice(0,1).capitalize + path.slice(1..-1)
  end


  def pretify_foldername(path)
    # Get just foldername
    path = /[^\/]+$/.match(path)[0]

    # Replace characters with spaces.
    path.gsub!(/-|_|\./, ' ')

    # Sentence case
    path.downcase!
    path.slice(0,1).capitalize + path.slice(1..-1)
  end
end
