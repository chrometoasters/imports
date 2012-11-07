module EzPub
  class DBLargeGallery < EzPub::Handler
    EzPub::HandlerSets::All << self
    EzPub::HandlerSets::Content << self

    extend NameMaker
    extend IncludeResolver
    extend IncludeOrPage
    extend TechlinkUrl
    extend MediaPathHelper


    def self.priority
      21
    end


    def self.mine?(path)
      response = false

      if page?(path)
        str = resolve_includes(path, :return => :string)

        if /#{Regexp.escape('select * from LargeGallery where CaseStudyID')}/.match(str)
          response = true
        end
      else
        response = false
      end
      response
    end



    def self.store(path)
      # if has_valid_index? path
      #   path = path + '/' unless path =~ /\/$/
      # end

      # Extract id for gallery lookup.
      doc = resolve_includes(path, :return => :doc)

      case_study_id = doc.xpath("//cfparam").first[:default]

      # Get images.
      images = []

      FasterCSV.read(CONFIG['directories']['dbs'] + "/LargeGallery.csv").each do |row|
        if row[0] == case_study_id
          images << row
        end
      end

      # Sort images.
      images.sort! {|a,b| a[1] <=> b[1]}


      # create gallery
      $r.log_key(path)
      $r.hset path, 'parent', parent_id(path)

      gallery_id = $r.get_id(path)

      $r.hset path, 'id', gallery_id
      $r.hset path, 'priority', '0'
      $r.hset path, 'type', 'image_gallery'
      $r.hset path, 'fields', 'title:ezstring'

      gallery_title = resolve_includes(path, :return => :doc).css('title').first.content

      $r.hset path, 'field_title', gallery_title

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
      $r.hset collection_path, 'field_title', gallery_title

      PostProcessor.register collection_path

      # Create images
      priority = 0

      images.each do |image|
        priority += 1

        image_path = LinkHelpers.parse("/images/gallery/#{image[2]}", path)

        file_path = $r.hget(mediaize_path(image_path.key, 'images'), 'field_image')

        image_path = image_path.key + '::' + collection_id

        if file_path
          $r.log_key(image_path)

          $r.hset image_path, 'parent', collection_id

          $r.hset image_path, 'id', $r.get_id(image_path)

          $r.hset image_path, 'priority', priority

          $r.hset image_path, 'type', 'image'

          $r.hset image_path, 'fields', 'image:ezimage,name:ezstring,caption:ezxmltext'

          $r.hset image_path, 'field_image', file_path

          title = image[3]

          unless title =~ /\w/
            title = pretify_filename(file_path)
          end

          $r.hset image_path, 'field_name', title

          $r.hset image_path, 'field_caption', title

          PostProcessor.register image_path
        end
      end
    end

  end
end
