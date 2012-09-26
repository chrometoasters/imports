class GeneralContent < EzObject

  @@type = 'general_content'

  def self.mine?(path)
    if matched(path)
      true
    else
      false
    end
  end

  def self.store(path)
    id = $r.get_id

    puts $term.color("Storing #{path} with id #{id}", :green)

    $r.log_key path
    $r.hset path, 'type', @@type

    $r.hset path, 'id', id

    $r.hset path, 'parent', parent_id(path)

    #$r.hset path, 'body'
    #$r.hset path, 'title'
  end


  def self.matched(path)
    path =~ /\.htm$/ || path =~ /.\/[^\.]+$/
  end
end
