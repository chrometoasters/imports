class Sanitize
  module InportConfig

    EZXML = {
      :elements => %w[
        heading paragraph emphasize link
      ],

      :attributes => {
        'heading' => ['level'],
        'link' => ['href', 'title']
      },

      :add_attributes => {
        #'a' => {'rel' => 'nofollow'}
      },

      :protocols => {
        #'a'          => {'href' => ['ftp', 'http', 'https', 'mailto', :relative]},
      },

      :output => :xhtml,

      # Order is important.
      :transformers => Links + Removers + Headings + Paragraphs + Styles
    }

  end
end
