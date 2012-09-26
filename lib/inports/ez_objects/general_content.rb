class GeneralContent < EzObject

  def self.mine?(path)
    if path =~ /\.htm$/
      true
    else
      false
    end
  end

  def self.store(path)
    $r.log_key path

    $r.hset path, 'id', $r.get_id
    $r.hset path, 'parent', path
  end


  def self.parent_id(path)

  end
end
