module Convert
  def to_ezp(html, opts = {})
    config = opts[:config] || Sanitize::InportConfig::EZXML

    strip Sanitize.clean(html, config)
  end


  # Convert weirdly handled carriage returns to newlines.
  def strip(str)
    str.gsub('&#13;', "\n")
  end
end
