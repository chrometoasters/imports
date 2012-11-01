module StaticCopy

  # Helper mixin for copying static files.

  def move_to_files(path)
    move_to(path, CONFIG['directories']['output']['files'])
  end


  def move_to_images(path)
    move_to(path, CONFIG['directories']['output']['images'])
  end


  def move_to(path, dest)
    require 'shellwords'
    # nil for links with cf variables in them.
    if path =~ /#(\w|-|_)+#/i
      return nil
    end

    name = flatten(path)
    dest = dest + '/' + name

    if File.exists? dest
      Logger.warning path, 'Duplicate filename', 'shh'
      dest = make_unique(dest)
    end

    path = Dir.glob(path, File::FNM_CASEFOLD).first

    if path

      escaped_source = path.gsub(/^\.\//, '').shellescape
      escaped_dest = dest.gsub(/^\.\//, '').shellescape

      system("cp #{escaped_source} #{escaped_dest}")
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
