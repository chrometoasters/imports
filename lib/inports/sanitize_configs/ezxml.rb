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
        'heading' => ['level'],
        'link' => ['href', 'title'],
        'anchor' => ['name'],
        'custom' => ['name'],
        'table' => ['class', 'width', 'border'],
        'td' => ['colspan'],
        'embed' => [''],
        'embed-inline' => ['view', 'size', 'object_id'],
      },

      :add_attributes => {
        #'a' => {'rel' => 'nofollow'}
      },

      :protocols => {
        'link' => {'href' => ['#', 'mailto', 'http', 'https', 'eznode', :relative]},
      },

      :output => :xhtml,

      # Order is important.
      :transformers => Links + Removers + Headings + Paragraphs + Styles + Tables
    }

  end
end
