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

    puts $term.color("Storing #{path} as #{@@type} with id #{id}", :green)


    $r.log_key path
    $r.hset path, 'type', @@type
    $r.hset path, 'id', id
    $r.hset path, 'parent', parent_id(path)

    doc = Nokogiri::HTML(open(path))

    $r.hset path, 'body', process_body(doc)
    $r.hset path, 'title', doc.xpath("//p[@class='header']").first.content
  end

  def process_body(path)
    str = doc.xpath("//div[@id='content']").first.to_s

    puts Sanitize.clean(str, Sanitize::Config::RELAXED)
  end


  def self.matched(path)
    if path =~ /\.htm$/
      :page
    elsif path =~ /.\/[^\.]+$/
      :folder
    else
      nil
    end
  end
end
