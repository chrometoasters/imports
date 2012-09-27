class String
  # Helper the cuts a path string down
  # a level from /hello/world => /hello

  def _parentize
    match = /(.+)\/[^\/]+$/.match(self)
    match ? match[1] : self
  end
end
