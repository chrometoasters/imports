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
    title = nil

    # Try to obtain a title from the left-hand navigation.
    nav_title = get_title_via_navigation(doc, path)

    if nav_title
      title = nav_title
    end

    if doc.css('p.header').first

      # Remove nested little headings.
      if doc.css('p.header').first.children
        head = doc.css('p.header').first.children

        if head.css('span.header-above-10px').first
          head.css('span.header-above-10px').first.remove
        end
      end

      title = doc.css('p.header').first.content.to_s

    end

    if doc.css('p.header-dk-blue').first
      title = doc.css('p.header-dk-blue').first.content.to_s
    end

    if doc.css('title').first
      title = doc.css('title').first.content.to_s
    end

    if title
      title = title._sentence_case
    end

    title = title.gsub('Teaching Snapshot: ', '')

    title
  end


  def generate_short_title(title, path)
    if title =~ /:/
      title = /:([^:]+)$/.match(title)[0]
      title = title.gsub(/^\s|^\s:|^:|^\s:\s|^:\s/, '')
    end
    title
  end

  # Make absolute, make non index, make downase.


  # Try and parse a page title from the left-hand navigation box.
  #
  # This has been selected as the most consistently successful strategy for
  # deciding page titles.

  def get_title_via_navigation(doc, path)
    path = path.gsub(CONFIG['directories']['input'], '/')
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

      url = anchor[:href]

      next unless url

      # Painful absoluting of link.

      if url && url !~ /^\//
        if path =~ /.htm$|.html$/
          url = path._parentize + '/' + url
        else
          url = path + '/' + url
        end
      end

      # puts url.gsub('index.htm', '').downcase
      # puts path.gsub('index.htm', '').downcase

      if url.gsub('index.htm', '').downcase == path.gsub('index.htm', '').downcase
        title = anchor.content

        # Some basic tidyup.

        title.gsub!("\r\n", ' ')          # Remove returns created in nokogiri conversion of <br>
        title.gsub!("\342\200\223", '')   # Remove dashes
        title.gsub!(/^\W/, '')            # Removing leading space
        break
      end
    end

    if title
      title = title._sentence_case
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

    if title
      title = title._sentence_case
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


  def get_showcase_image_path(doc, path)
    extend ::MediaPathHelper
    if doc.css('div#content').css('img').first
      img = doc.css('div#content').css('img').first

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

    if title
      title = title._sentence_case
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


  def get_case_study_landing_page_title(doc, path)
    if doc.css('title').first
      doc.css('title').first.content.to_s
    end
  end


  def get_review_title(doc,path)
    if doc.css('p.header').first
      title = doc.css('p.header').first.content.to_s
      title.gsub!("\r\n", ' ')
      title.gsub("\342\200\223", '')
    end
  end


  def get_review_image_path(doc, path)
    extend ::MediaPathHelper
    if doc.css('div#content').first
      img = doc.css('div#content').first.css('img').first

      if img
        url = img['src']

        link = LinkHelpers.parse(url, path)

        link.key
      end
    end
  end


  def get_review_element(doc, regex)
    nodes = Nokogiri::XML::NodeSet.new(Nokogiri::XML::Document.new)


    if doc.css('p.subsubhead').first || doc.css('strong')
      set = doc.css('p.subsubhead') + doc.css('strong')

      set.each do |node|
        node = node.parent if node.name == 'strong'

        if node.child.content.downcase.gsub('  ', '') =~ regex || node.content.downcase.gsub('  ', '') =~ regex

          # reset "until" conditions
          node.remove_attribute 'class'
          strong_comming = false

          until node.next_sibling[:class] == 'subsubhead' || node.next_sibling.name == 'cfinclude' || strong_comming
            nodes.push node.next_sibling

            if node.next_sibling.next_sibling
              node = node.next_sibling
            else
              break
            end

            if node.next_sibling.children.first
              if node.next_sibling.children.first.name == 'strong'
                strong_comming = true
              end
            end
          end
        end
      end
    end

    if nodes.empty?
      nil
    else
      nodes.to_s
    end
  end
end
