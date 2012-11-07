module DatabaseImporters
  class Question

    DatabaseImporters::Importers::All << self


    def self.get_data
      FasterCSV.read(CONFIG['directories']['dbs'] + "/TE_Questions.csv")[1..-1]
    end


    def self.priority
      4
    end


    def self.run
      get_data.each do |item|
        if item[1] == '1'
          store(item)
        end
      end
    end


    def self.store(a)
      path = "DBIMPORT:/Question?GID=#{a[0]}"

      $r.log_key(path)

      $r.hset path, 'id', $r.get_id(path)

      $r.hset path, 'parent', CONFIG['ids']['question']

      $r.hset path, 'priority', '0'

      $r.hset path, 'type', 'ask_an_expert'

      $r.hset path, 'fields', 'question:eztext,name:ezstring,email:ezemail,answered_by:ezstring,answer:ezxmltext,make_public:ezboolean'

      $r.hset path, 'field_question', a[2]
      $r.hset path, 'field_name', a[5] || 'Anonymous'
      $r.hset path, 'field_email', a[6] || 'anonymous@example.com'
      $r.hset path, 'field_answered_by', a[8] || 'Unknown'
      $r.hset path, 'field_answer', a[3]
      $r.hset path, 'field_make_public', '1'

      # Register general content for post_processing.
      PostProcessor.register path
    end
  end
end
