module FieldParsers
  # Module for extracting fields from page bodies.

  #$r.hset path, 'field_title', get_title @doc
  #$r.hset path, 'field_body', store_body @doc

  def get_title(doc)
    if doc.css('p.header').first
      doc.css('p.header').first.content.to_s
    else
      nil
    end
  end


  def get_body(doc)
    if doc.css('div#content').first
      doc.css('div#content').first.to_s

    elsif doc.css('div#noright-content').first
      doc.css('div#noright-content').first.to_s

    else
      nil
    end
  end
end
