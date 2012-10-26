class Sanitize
  module InportConfig

    EZXML = {
      :elements => %w[
        heading paragraph emphasize link strong anchor custom
        li ul br
        table tr th td
        embed embed-inline
      ],

      :attributes => {
        'header' => ['level'],
        'link' => ['href', 'title'],
        'anchor' => ['name'],
        'custom' => ['name'],
        'table' => ['class', 'width', 'border'],
        'tr' => ['class'],
        'td' => ['colspan', 'class'],
        'embed' => [''],
        'embed-inline' => ['view', 'size', 'object_id'],
      },

      :add_attributes => {
        #'a' => {'rel' => 'nofollow'}
      },

      :protocols => {
        'link' => {'href' => ['#', 'mailto', 'http', 'https', 'eznode', 'importmedia', :relative]},
      },

      :output => :xhtml,

      # Order is important.
      :transformers => Links + Removers + Headings + Paragraphs + Styles + Tables
    }

  end
end
