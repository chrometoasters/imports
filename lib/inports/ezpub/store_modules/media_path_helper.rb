module MediaPathHelper
  # Media paths are special paths for the file structure of the
  # ezp media library folders (Media/images and Media/files).
  #
  # This module provides methods for storing in this locations, and creating
  # appropriate folder heirarchies (handled by MediaFolder::store).


  # Tests if a path has a corresponding media folder parent.
  # Does not sanity check, so passing something stupid in to here
  # will result in nil rather than an exception.

  def has_media_path?(path, type)
    $r.exists mediaize_path(path._parentize, type)
  end


  # Recursively creates parent media folders for path.
  #
  # Leaves alone pre-existing folders.

  def create_media_path(path, type)
    folders = path.split('/')[1..-2]

    str = mediaize_path('', type) + '.'

    folders.each do |f|
      str = str + '/' + f

      unless $r.exists str
        EzPub::MediaFolder.store str
      end
    end
  end


  # Format a regular path as a media path.
  #
  # This is a useful wrapper when calling #parent_id in handlers.

  def mediaize_path(path, type)
    "media:#{type}:" + path
  end
end
