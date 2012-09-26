class String
  def _parentize
    match = /(.+)\/.+\.htm$/.match(self)
    match ? match[1] : self
  end
end
