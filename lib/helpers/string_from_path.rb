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
    if File.exists?(path)
      file = File.open(path)
      str = file.read
      file.close
      str
    else
      nil
    end
  end
end
