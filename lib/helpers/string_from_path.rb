module StringFromPath
  def self.get_case_insensitive(path)
    # Case insensitive file lookup. Will not work on all linuxs.

    if Dir.glob(path, File::FNM_CASEFOLD).first
      StringFromPath.get(Dir.glob(path, File::FNM_CASEFOLD).first)
    else
      nil
    end
  end


  def self.get(path)
    # Check for the file, and ensure it isn't a directory.
    #
    # If it is a directory we will check for an index.htm file.

    if File.exists?(path) && !File.directory?(path)
      file = File.open(path)
      str = file.read
      file.close
      str
    else

      # Checking for index.htm file.

      if File.exists?(path + '/index.htm')
        file = File.open(path + '/index.htm')
        str = file.read
        file.close
        str
      else
        nil
      end
    end

  end
end
