class String
  def _parentize
    match = /(.+)\/[^\/]+$/.match(self)
    match ? match[1] : self
  end
end
