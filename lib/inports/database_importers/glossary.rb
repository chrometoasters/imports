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
      puts get_data.first

      get_data.each do |item|
        puts item[1]
      end
    end


    def self.store(a)
      $r.log_key(path)

      $r.hset path, 'id', $r.get_id

      # Pass in a "media:files:./xyz" path, rather than a standard path.
      # (Since we want to match against the various Media locations).

      $r.hset path, 'parent', CONFIG['ids']['glossary']

      $r.hset path, 'priority', '0'

      $r.hset path, 'type', 'glossary_item'

      $r.hset path, 'fields', 'image:ezimage,name:ezstring'

      $r.hset path, 'field_image', trim_for_ezp(dest)
      $r.hset path, 'field_name', pretify_filename(dest)
    end

  end
end
