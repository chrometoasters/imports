module EzPub
  class SimpleGallery < EzPub::Handler
    # EzPub::HandlerSets::All << self
    # EzPub::HandlerSets::Content << self

    extend NameMaker
    extend IncludeResolver
    extend IncludeOrPage
    extend TechlinkUrl
    extend MediaPathHelper


    def self.priority
      40
    end


    def self.mine?(path)
      response = false

      if page?(path)
        str = resolve_includes(path, :return => :string)

        if /flashvars\.galleryURL/.match(str)
          response = true
        end
      else
        response = false
      end
      response
    end


    def self.store(path)
      # Extract path for gallery manifest.

      str = resolve_includes(path, :return => :string)
      gallery_path = %r{flashvars\.galleryURL[^"]+([^;]+)}.match(str)[1]
      gallery_path.gsub!('"', '')

      gallery_path = LinkHelpers.parse(gallery_path, path).key

      # parse gallery manifest
      manifest = resolve_includes(gallery_path, :return => :doc)


      # create gallery
      $r.log_key(path)
      $r.hset path, 'parent', parent_id(path)

      gallery_id = $r.get_id(path)

      $r.hset path, 'id', gallery_id
      $r.hset path, 'priority', '0'
      $r.hset path, 'type', 'image_gallery'
      $r.hset path, 'fields', 'title:ezstring'
      $r.hset path, 'field_title', resolve_includes(path, :return => :doc).css('title').first.content

      PostProcessor.register path

      # make collection
      collection_path = path + '::collection'

      $r.log_key(collection_path)

      collection_id = $r.get_id(collection_path)

      $r.hset collection_path, 'parent', gallery_id

      $r.hset collection_path, 'id', collection_id
      $r.hset collection_path, 'priority', '0'
      $r.hset collection_path, 'type', 'image_collection'
      $r.hset collection_path, 'fields', 'title:ezstring'

      PostProcessor.register collection_path

      # Create images
      priority = 0

      manifest.css('image').each do |image|
        priority += 1

        image_path = LinkHelpers.parse(image[:imageurl], path)
        puts $r.hget mediaize_path(image_path.key, 'images'), 'field_image'

        $r.log_key 'keys', image_path.key

        $r.hset image_path.key, 'id', $r.get_id(image_path.key)
        $r.hset image_path.key, 'parent', collection_id

        $r.hset image_path.key, 'priority', priority

        $r.hset image_path.key, 'type', 'image'

        $r.hset image_path.key, 'fields', 'image:ezimage,name:ezstring,caption:ezxmltext'

        $r.hset image_path.key, 'field_image', $r.hget(mediaize_path(image_path.key, 'images'), 'field_image')

        # make this conditional and if not found, use the normal namemaker helper.
        $r.hset image_path.key, 'field_name', image.css('caption').first.content

        $r.hset image_path.key, 'field_caption', image.css('caption').first.content

        PostProcessor.register image_path.key
      end
    end

  end
end
