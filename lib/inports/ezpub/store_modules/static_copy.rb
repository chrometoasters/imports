module StaticCopy

  # Helper mixin for copying static files.

  def move_to_files(path)
    move_to(path, CONFIG['directories']['output']['files'])
  end


  def move_to_images(path)
    move_to(path, CONFIG['directories']['output']['images'])
  end


  def move_to(path, dest)
    name = flatten(path)
    dest = dest + '/' + name

    if File.exists? dest
      Logger.warning path, 'Duplicate filename', 'shh'
      dest = make_unique(dest)
    end

    if Dir.glob(path, File::FNM_CASEFOLD).first
      FileUtils.cp(Dir.glob(path, File::FNM_CASEFOLD).first, dest)
    end
    dest
  end


  # Goes from ./thing/folder/hello.jpg => hello.jpg

  def flatten(path)
    /([^\/]+\.\w+)$/.match(path)[0]
  end


  # When a filename needs uniquifying,
  # Adds current timestamp at end of filename.

  def make_unique(path)
    path.gsub(/(\.\w+$)/, "-#{$r.incr('unique-file-id')}" + '\1')
  end
end
