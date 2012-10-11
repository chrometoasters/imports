class Sanitize
  module InportConfig

    EZXML = {
      :elements => %w[
        heading paragraph emphasize link strong anchor custom
        li ul br
        table tr th td
      ],

      :attributes => {
        'heading' => ['level'],
        'link' => ['href', 'title'],
        'anchor' => ['name'],
        'custom' => ['name'],
        'table' => ['class', 'width', 'border'],
        'td' => ['colspan'],
      },

      :add_attributes => {
        #'a' => {'rel' => 'nofollow'}
      },

      :protocols => {
        'link' => {'href' => ['#', 'mailto', 'http', 'https', :relative]},
      },

      :output => :xhtml,

      # Order is important.
      :transformers => Links + Removers + Headings + Paragraphs + Styles + Tables
    }

  end
end
