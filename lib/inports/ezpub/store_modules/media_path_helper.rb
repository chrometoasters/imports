module MediaPathHelper
  def has_media_path?(path, type)
    $r.exists "media:#{type}:" + path._parentize
  end


  def create_media_path(path, type)
    folders = path.split('/')[1..-2]

    str = "media:#{type}:."

    folders.each do |f|
      str = str + '/' + f

      unless $r.exists str
        EzPub::MediaFolder.store str
      end
    end
  end


  def mediaize_path(path, type)
    "media:#{type}:" + path
  end
end
