class String
  # Helper the cuts a path string down
  # a level from /hello/world => /hello

  def _parentize
    str = self.gsub(/\/$/, '')
    match = /(.+|.?)\/[^\/]+$/.match(str)
    match ? match[1] : self
  end
end
