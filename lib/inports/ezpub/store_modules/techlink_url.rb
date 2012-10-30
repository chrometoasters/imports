module TechlinkUrl
  def techlink_url(path)
    path.gsub(CONFIG['directories']['input'], 'http://techlink.org.nz/')
  end
end
