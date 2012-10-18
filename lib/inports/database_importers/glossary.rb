module DatabaseImporters
  DatabaseImporters::Importers::All << self

  class Glossary
    def self.get_data
      FasterCSV.read(CONFIG['directories']['dbs'] + "/Glossary.csv")
    end


    def self.priority
      1
    end


    def self.run
      get_data.each do |item|
        store(item)
      end
    end


    def self.store(a)
      path = "database:generated:./glossary/#{a[1]}"

      $r.log_key(path)

      $r.hset path, 'id', $r.get_id

      $r.hset path, 'parent', CONFIG['ids']['glossary']

      $r.hset path, 'priority', '0'

      $r.hset path, 'type', 'glossary_item'

      $r.hset path, 'fields', 'body:ezxmltext,title:ezstring'

      $r.hset path, 'field_title', a[1]
      $r.hset path, 'field_body', a[0]

      # Register general content for post_processing.
      PostProcessor.register path
    end
  end
end
