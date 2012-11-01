class SanityCheck
  def self.summary(file)
    file = File.open(file)
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

    warnings classes

    puts

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

    if i < 100
      puts $term.color("Only #{i} showcases", [:red])
    end
  end
end
