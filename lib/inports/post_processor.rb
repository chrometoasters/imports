module PostProcessor
  # PostProcessor handles the sanitization and conversion of ezpublish content
  # after the initial ingest. It takes stored field content from $r and
  # performs actions sucgh as tag substitution and link resolution.

  # PostProcessor is used as a mixin for the main Processor class.


  # Register a key for post processing.
  # This should be done in ::store for any class which has an ezxml field.
  # PostProcessor.register 'some/path'

  def self.register(path)
    $r.rpush 'post_process', path
  end

  # Main post processing loop. Checks all keys in the post_process
  # list for ezxmltext fields, which are run through a custom Sanitize
  # config.

  # See ./lib/sanitize_configs and ./lib/sanitize_transformers

  def post_process(opts={})
    # Post processor currently runs through all keys in the
    # post_process list, for which they have to be manually registered
    # in their ::store method.

    # Could possibly change this to run though the entire keys list, if
    # it is decided that we want to post process EVERY ezxmltext field.

    keys = opts[:keys] || $r.lrange('post_process', 0, -1)

    keys.each do |k|

      fields = $r.hget(k, 'fields')._explode_fields

      fields.each do |field|
        field.each do |name, type|

          # We only post process ezxmltext fields.

          if type == 'ezxmltext'

            html = $r.hget(k, 'field_' + name)

            ezpxml = to_ezp(html, :path => k)

            $r.hset k, 'field_' + name, ezpxml

            Logger.warning k, "Postprocessed field #{name}", 'shh'

          elsif type == 'eztext'

            text = $r.hget(k, 'field_' + name)

            clean_text = Sanitize.clean(text)

            $r.hset k, 'field_' + name, clean_text

            Logger.warning k, "Postprocessed field #{name}", 'shh'

          end # type check
        end # field
      end # fields
    end # keys
  end


  def to_ezp(html, opts = {})
    config = opts[:config] || Sanitize::InportConfig::EZXML

    config[:path] = opts[:path] if opts[:path]

    strip Sanitize.clean(html, config)
  end


  # Convert weirdly handled carriage returns to newlines.

  def strip(str)
    str.gsub!('&#13;', "\n")
    str.gsub(/\n\n/, "\n")
  end
end
