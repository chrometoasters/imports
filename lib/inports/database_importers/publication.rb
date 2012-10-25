module DatabaseImporters
  class Publication

    DatabaseImporters::Importers::All << self


    def self.get_data
      FasterCSV.read(CONFIG['directories']['dbs'] + "/TE_Publications.csv")
    end


    def self.priority
      2
    end


    def self.run
      get_data.each do |item|
        if item[1] == '1'
          store(item)
        end
      end
    end


    def self.store(a)
      path = "DBIMPORT:/Publication?GID=#{a[0]}"

      puts path

      $r.log_key(path)

      $r.hset path, 'id', $r.get_id

      $r.hset path, 'parent', CONFIG['ids']['publication']

      $r.hset path, 'priority', '0'

      $r.hset path, 'type', 'publication'

      $r.hset path, 'fields', 'author:ezstring,year_published:ezstring,reference_details:eztext,abstract:eztext,name:ezstring,email:ezemail,make_public:ezboolean'

      $r.hset path, 'field_author', a[5]
      $r.hset path, 'field_year_published', a[6]
      $r.hset path, 'field_reference_details', a[2]
      $r.hset path, 'field_abstract', a[3]
      $r.hset path, 'field_name', a[7] || 'Anonymous'
      $r.hset path, 'field_email', a[8] || 'anonymous@example.com'
      $r.hset path, 'field_make_public', 'true'

      # Register general content for post_processing.
      PostProcessor.register path
    end
  end
end
