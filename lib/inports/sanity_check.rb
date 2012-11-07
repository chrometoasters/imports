class SanityCheck
  def self.summary(file_name, no_render = nil)
    file = File.open(file_name)
    str = file.read
    doc = Nokogiri::XML(str)

    classes = {}

    doc.css('object').each do |object|
      if classes[object[:name]]
        classes[object[:name]] += 1
      else
        classes[object[:name]] = 1
      end
    end

    puts

    classes.each do |obj,count|
      puts $term.color("#{obj} => ", [:green]) + $term.color("#{count}", [:red, :on_white])
    end

    puts

    warnings classes

    puts

    puts $term.color("Checking structure...", [:green])

    structure_check(file_name)

    puts $term.color("Structure valid.", [:green])

    path = render_as_list(file_name) unless no_render

  end


  def self.structure_check(file_name)
    file = File.open(file_name)
    str = file.read
    doc = Nokogiri::XML(str)

    valid_parents = []

    objects = []

    CONFIG['ids'].each do |k,v|
      valid_parents << v
    end

    doc.css('object').each do |o|
      unless valid_parents.member? o[:parent_remote_id]
        puts $term.color("remote id: #{o[:remote_id]}", [:red])
        puts $term.color("parent remote id: #{o[:parent_remote_id]}", [:red])
        puts $term.color(o[:name], :red)


        if o.xpath("//object[@remote_id='#{o[:remote_id]}']/attribute[@name='title']").first
          title = o.xpath("//object[@remote_id='#{o[:remote_id]}']/attribute[@name='title']").first.content
          puts $term.color(title, :red)
        end

        if o.xpath("//object[@remote_id='#{o[:remote_id]}']/attribute[@name='old_ste_url']").first
          title = o.xpath("//object[@remote_id='#{o[:remote_id]}']/attribute[@name='old_ste_url']").first.content
          puts $term.color(title, :red)
        end

        if o.xpath("//object[@remote_id='#{o[:remote_id]}']/attribute[@name='name']").first
          title = o.xpath("//object[@remote_id='#{o[:remote_id]}']/attribute[@name='name']").first.content
          puts $term.color(title, :red)
        end

        raise Orphanity, "Orphan found in xml output"
      end

      if objects.member? o[:remote_id]
        puts $term.color("remote id: #{o[:remote_id]}", [:red])
        puts $term.color("parent remote id: #{o[:parent_remote_id]}", [:red])
        puts $term.color(o[:name], :red)


        if o.xpath("//object[@remote_id='#{o[:remote_id]}']/attribute[@name='title']").first
          title = o.xpath("//object[@remote_id='#{o[:remote_id]}']/attribute[@name='title']").first.content
          puts $term.color(title, :red)
        end

        if o.xpath("//object[@remote_id='#{o[:remote_id]}']/attribute[@name='old_ste_url']").first
          title = o.xpath("//object[@remote_id='#{o[:remote_id]}']/attribute[@name='old_ste_url']").first.content
          puts $term.color(title, :red)
        end


        if o.xpath("//object[@remote_id='#{o[:remote_id]}']/attribute[@name='name']").first
          title = o.xpath("//object[@remote_id='#{o[:remote_id]}']/attribute[@name='name']").first.content
          puts $term.color(title, :red)
        end

        raise Redclaration, "Declaring a remote_id that was previously declared."
      end

      valid_parents << o[:remote_id]
      objects << o[:remote_id]
    end
  end


  def self.render_as_list(file_name)
    puts $term.color("Rendering as an html list.", [:green])

    file = File.open(file_name)
    str = file.read
    doc = Nokogiri::XML(str)

    list = Nokogiri::HTML.fragment('<div id="main"></div>')

    CONFIG['ids'].each do |k,v|
      list.css('div#main').first.add_child "<ul id='#{v}'><li>#{k}</li></ul>"
    end

    doc.css('object').each do |o|
      parent = o[:parent_remote_id]
      remote_id = o[:remote_id]

      if o.xpath("//object[@remote_id='#{remote_id}']/attribute[@name='title']").first
        title = o.xpath("//object[@remote_id='#{remote_id}']/attribute[@name='title']").first.content
      elsif o.xpath("//object[@remote_id='#{remote_id}']/attribute[@name='name']").first
        title = o.xpath("//object[@remote_id='#{remote_id}']/attribute[@name='name']").first.content
      else
        title = 'unknown title'
      end

      if o.xpath("//object[@remote_id='#{parent}']/attribute[@name='title']").first
        parent_title = o.xpath("//object[@remote_id='#{parent}']/attribute[@name='title']").first.content
      elsif o.xpath("//object[@remote_id='#{parent}']/attribute[@name='name']").first
        parent_title = o.xpath("//object[@remote_id='#{parent}']/attribute[@name='name']").first.content
      else
        parent_title = 'unknown title'
      end

      content_class = o[:name]

      list.css("##{parent}").first.add_child "<ul id='#{remote_id}'><li><a title='#{parent_title}' href='##{parent}'>#{title}</a> <strong>#{content_class}<strong></li></ul>"
    end

    list_file_path = CONFIG['directories']['output']['xml'] + '/list.html'

    f = File.open(list_file_path, 'w')
    f.write(list.to_s)
    f.close

    puts $term.color("List available at #{list_file_path}", [:green])

    list_file_path
  end


  def self.warnings(h)
    i = h['case_study_landing_page']
    i = 0 unless i

    if i < 13
      puts $term.color("Only #{i} case_study_landing_pages", [:red])
    end

    i = h['reviews_landing_page']
    i = 0 unless i

    if i < 1
      puts $term.color("No case_study_landing_pages", [:red])
    end

    i = h['review']
    i = 0 unless i

    if i < 40
      puts $term.color("Only #{i} reviews", [:red])
    end

    i = h['case_study']
    i = 0 unless i

    if i < 90
      puts $term.color("Only #{i} case_studys", [:red])
    end

    i = h['file']
    i = 0 unless i

    if i < 1400
      puts $term.color("Only #{i} files", [:red])
    end

    i = h['image']
    i = 0 unless i

    if i < 18000
      puts $term.color("Only #{i} images", [:red])
    end

    i = h['general_content']
    i = 0 unless i

    if i < 1000
      puts $term.color("Only #{i} general_contents", [:red])
    end

    i = h['glossary_item']
    i = 0 unless i

    if i < 100
      puts $term.color("Only #{i} glossary_items", [:red])
    end

    i = h['publication']
    i = 0 unless i

    if i < 20
      puts $term.color("Only #{i} publications", [:red])
    end

    i = h['research']
    i = 0 unless i

    if i < 20
      puts $term.color("Only #{i} reserachs", [:red])
    end

    i = h['abstract']
    i = 0 unless i

    if i < 10
      puts $term.color("Only #{i} abstracts", [:red])
    end

    i = h['ask_an_expert']
    i = 0 unless i

    if i < 30
      puts $term.color("Only #{i} abstracts", [:red])
    end


    i = h['showcases_landing_page']
    i = 0 unless i

    if i < 7
      puts $term.color("Only #{i} showcases_landing_pages", [:red])
    end


    i = h['showcase']
    i = 0 unless i

    if i < 170
      puts $term.color("Only #{i} showcases", [:red])
    end


    i = h['course_outline_landing_page']
    i = 0 unless i

    if i < 4
      puts $term.color("Only #{i} course_outline_landing_pages", [:red])
    end


    i = h['snapshots_landing_page']
    i = 0 unless i

    if i < 4
      puts $term.color("Only #{i} snapshots_landing_pages", [:red])
    end

    i = h['course_outline']
    i = 0 unless i

    if i < 20
      puts $term.color("Only #{i} course_outline", [:red])
    end
  end
end
