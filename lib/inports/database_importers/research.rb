module DatabaseImporters
  class Research

    DatabaseImporters::Importers::All << self


    def self.get_data
      FasterCSV.read(CONFIG['directories']['dbs'] + "/TE_Research.csv")
    end


    def self.priority
      3
    end


    def self.run
      get_data.each do |item|
        if item[0] == '1'
          store(item)
        end
      end
    end


    def self.store(a)
      path = "DBIMPORT:/Research?GID=#{a[4]}"

      $r.log_key(path)

      $r.hset path, 'id', $r.get_id

      $r.hset path, 'parent', CONFIG['ids']['research']

      $r.hset path, 'priority', '0'

      $r.hset path, 'type', 'research'

      $r.hset path, 'fields', 'title:ezstring,researcher:ezstring,description:eztext,name:ezstring,email:ezemail,make_public:ezboolean'

      $r.hset path, 'field_title', a[3]
      $r.hset path, 'field_researcher', a[5]
      $r.hset path, 'field_description', a[1]
      $r.hset path, 'field_name', a[6] || 'Anonymous'
      $r.hset path, 'field_email', a[7] || 'anonymous@example.com'
      $r.hset path, 'field_make_public', '1'

      # Register general content for post_processing.
      PostProcessor.register path
    end
  end
end
