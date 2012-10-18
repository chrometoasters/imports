module DatabaseImporters
  class Glossary

    DatabaseImporters::Importers::All << self


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
      path = CONFIG['directories']['input'] + "/GlossaryItem.htm?GID=#{a[4]}"

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
