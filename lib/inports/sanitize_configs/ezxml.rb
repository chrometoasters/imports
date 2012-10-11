class Sanitize
  module InportConfig

    EZXML = {
      :elements => %w[
        heading paragraph emphasize link strong anchor custom ul li
      ],

      :attributes => {
        'heading' => ['level'],
        'link' => ['href', 'title'],
        'anchor' => ['name'],
        'custom' => ['name'],
      },

      :add_attributes => {
        #'a' => {'rel' => 'nofollow'}
      },

      :protocols => {
        'link' => {'href' => ['#', 'mailto', 'http', 'https', :relative]},
      },

      :output => :xhtml,

      # Order is important.
      :transformers => Links + Removers + Headings + Paragraphs + Styles
    }

  end
end
