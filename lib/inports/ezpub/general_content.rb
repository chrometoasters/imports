module EzPub
  class GeneralContent < EzPub::Handler
    EzPub::Handlers::All << self
    EzPub::Handlers::Static << self

    extend NameMaker


    def self.priority
      50
    end


    def self.mine?(path)
      false
    end


    def self.store(path)
      dest = move_to_images path

      $r.log_key(path)

      $r.hset path, 'id', $r.get_id

      # Pass in a "media:files:./xyz" path, rather than a standard path.
      # (Since we want to match against the various Media locations).

      $r.hset path, 'parent', parent_id(mediaize_path(path, 'images'))

      $r.hset path, 'priority', '0'

      $r.hset path, 'type', 'image'

      $r.hset path, 'fields', 'image:ezimage,name:ezstring'

      $r.hset path, 'field_image', dest
      $r.hset path, 'field_name', pretify_filename(dest)
    end
  end
end
