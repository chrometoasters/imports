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

    type = matched(path)

    if type == :page
      doc = Nokogiri::HTML(open(path))

    elsif type == :folder

      index = path + '/index.htm'

      if File.exist?(index)
        doc = Nokogiri::HTML(open(index))
      else
        Logger.warning "#{path} doesn't have an index.htm.", 'just-a-folder'
        doc = Nokogiri::HTML('<div id="content>PLACEHOLDER</div>')
      end
    else
      raise Unmatched, "#{path} seems to be neither a folder or a file."
    end

    $r.hset path, 'body', process_body(doc)

    if doc.xpath("//p[@class='header']").first
      $r.hset path, 'title', doc.xpath("//p[@class='header']").first.content
    else
      $r.hset path, 'title', 'TITLE UNKNOWN'
      Logger.warning "Couldn't work out a title, setting TITLE UNKNOWN", 'unknown-titles'
    end
  end



  def self.process_body(doc)
    str = doc.xpath("//div[@id='content']").first.to_s

    Sanitize.clean(str, Sanitize::Config::RELAXED)
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
