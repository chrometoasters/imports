class String
  # Helper the cuts a path string down
  # a level from /hello/world => /hello

  def _parentize
    if self =~ /\/$/
      str = self
    else
      str = self.gsub(/\/$/, '')
      match = /(.+|.?)\/[^\/]+$/.match(str)

      if match
        str = match[1] + '/'
      else
        raise "Problem with _parentize - no match made."
      end
    end

    str
  end


  def _explode_fields
    field_info = []
    fields = self.split(',')
    fields.each do |field|
      a = field.split(':')
      field_info << {a[0] => a[1]}
    end
    field_info
  end
end
