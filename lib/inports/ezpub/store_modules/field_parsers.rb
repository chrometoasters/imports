module FieldParsers
  include IsARedirect
  # Module for extracting fields from page bodies.

  #$r.hset path, 'field_title', get_title @doc
  #$r.hset path, 'field_body', store_body @doc


  def get_body(doc, path)
    if doc.css('div#content').first
      doc.css('div#content').first.to_s

    elsif doc.css('div#noright-content').first
      doc.css('div#noright-content').first.to_s

    else
      nil
    end
  end


  # Parsing titles is extremely difficult given the wide variety of nonsense
  # used as page headings (including redundant headings reflecting parent sections).
  #
  # Rather than attempting to parse out every premutation of headings and validating
  # against parent pages to decide if it is a redundant section heading or not,
  # we're primarily sourcing page titles from the left hand navigation.
  #
  # This is a compromise, but it will do.

  def get_title(doc, path)
    # Try to obtain a title from the left-hand navigation.
    title = get_title_via_navigation(doc, path)

    if title
      title


    elsif doc.css('p.header').first

      # Remove nested little headings.
      if doc.css('p.header').first.children
        head = doc.css('p.header').first.children

        if head.css('span.header-above-10px').first
          head.css('span.header-above-10px').first.remove
        end
      end

      doc.css('p.header').first.content.to_s


    elsif doc.css('p.header-dk-blue').first
      doc.css('p.header-dk-blue').first.content.to_s

    # Example => ./input/curriculum-support/Teacher-Education/PTTER-framework/E1/E1A2.htm
    elsif doc.css('p.subhead.PTTER-element').first
      if doc.css('p.PTTER-element').children
        children = doc.css('p.PTTER-element').children
        if children.css('span.subhead').first
          children.css('span.subhead').first.content.to_s
        end
      else
        nil
      end

    else
      nil
    end
  end


# Make absolute, make non index, make downase.


  # Try and parse a page title from the left-hand navigation box.
  #
  # This has been selected as the most consistently successful strategy for
  # deciding page titles.

  def get_title_via_navigation(doc, path)
    path = path.gsub(CONFIG['directories']['input'], '')
    title = nil

    nodes = Nokogiri::XML::NodeSet.new(Nokogiri::XML::Document.new)

    if doc.css('div.MenuLeft').first
      nodes = nodes + doc.css('div.MenuLeft').first.css('a')
    end

    if doc.css('div.rightnews').first
      nodes = nodes + doc.css('div.rightnews').first.css('a')
    end

    nodes.each do |anchor|

      # Checking all nav paths against page path.
      # Also normalizing out index.htm

      link = anchor[:href]

      next unless link

      # Painful absoluting of link.

      if link && link !~ /^\//
        if path =~ /.htm$|.html$/
          link = path._parentize + '/' + link
        else
          link = path + '/' + link
        end
      end


      if link.gsub('/index.htm', '').downcase == path.gsub('/index.htm', '').downcase
        title = anchor.content


        # Some basic tidyup.

        title.gsub!("\r\n", ' ')          # Remove returns created in nokogiri conversion of <br>
        title.gsub!("\342\200\223", '')   # Remove dashes
        title.gsub!(/^\W/, '')            # Removing leading space
        break
      end
    end
    title
  end



  def get_case_study_title(doc, path)
    title = nil

    if doc.css('table.cover-table').first
      tables = doc.css('table.cover-table')

      if tables.css('td.cover-table-subhead').first
        title = tables.css('td.cover-table-subhead').first.content
      end
    end

    title
  end


  def get_case_study_details(doc, path)
    h = {}

    if doc.xpath("//td[@bgcolor='#6D2C91']").first
      h[:date] = doc.xpath("//td[@bgcolor='#6D2C91']")[1].content

    elsif doc.xpath("//td[@bgcolor='#AED13C']").first
      h[:date] = doc.xpath("//td[@bgcolor='#AED13C']")[1].content

    end

    h[:category] = doc.xpath("//td[@bgcolor='#D2222A']")[0].content
    h[:level] = doc.xpath("//td[@bgcolor='#D2222A']")[1].content

    h
  end


  def get_case_study_image_path(doc, path)
    extend ::MediaPathHelper
    if doc.xpath('//p[@style]').first
      img = doc.xpath('//p[@style]').first.css('img').first

      url = img['src']

      link = LinkHelpers.parse(url, path)

      link.key
    end
  end


  def get_abstract_title(doc, path)
     title = nil

    if doc.css('strong').first
      doc.css('strong').each do |strong|
        if strong.content =~ /Title:/
          title = strong.next_sibling.to_s
        end
      end
    end
    title
  end


  def get_abstract_reference(doc, path)
    reference = nil

    if doc.css('strong')
      doc.css('strong').each do |strong|
        if strong.content =~ /Reference:/
          reference = strong.next_sibling.to_s
        end
      end
    end
    reference
  end
end



