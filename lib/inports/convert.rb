module Convert
  def to_ezp(html, opts = {})
    config = opts[:config] || Sanitize::InportConfigs::EZXML

    Sanitize.clean(html, config)
  end
end
