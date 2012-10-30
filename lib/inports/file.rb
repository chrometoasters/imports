# Making File.exists? case insensitive.

class ::File

  class << self
    alias_method :orig_exists?, :exists?
    alias_method :orig_directory?, :directory?
    alias_method :orig_open, :open
  end

  def self.exists?(path)
    file = ::Dir.glob(path, File::FNM_CASEFOLD).first
    if file
      orig_exists? file
    else
      false
    end
  end


  def self.directory?(path)
    file = ::Dir.glob(path, File::FNM_CASEFOLD).first
    if file
      orig_directory? file
    else
      false
    end
  end


  def self.open(path, mode = nil)
    file = ::Dir.glob(path, File::FNM_CASEFOLD).first

    file = path unless file

    if mode
      orig_open file, mode # Let it raise up if file doesn't exist.
    else
      orig_open file # Let it raise up if file doesn't exist.
    end
  end
end
