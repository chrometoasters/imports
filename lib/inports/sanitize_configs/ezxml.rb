class Sanitize
  module InportConfigs




    EZXML = {
      :elements => %w[
        a abbr b blockquote br cite code dd dfn dl dt em i kbd li mark ol p pre
        q s samp small strike strong sub sup time u ul var
      ],

      :attributes => {
        'a'          => ['href'],
        'abbr'       => ['title'],
        'blockquote' => ['cite'],
        'dfn'        => ['title'],
        'q'          => ['cite'],
        'time'       => ['datetime', 'pubdate']
      },

      :add_attributes => {
        'a' => {'rel' => 'nofollow'}
      },

      :protocols => {
        'a'          => {'href' => ['ftp', 'http', 'https', 'mailto', :relative]},
        'blockquote' => {'cite' => ['http', 'https', :relative]},
        'q'          => {'cite' => ['http', 'https', :relative]}
      },

      :transformers => []
    }
  end
end
