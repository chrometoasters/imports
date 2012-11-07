module DatabaseImporters
  class CourseOutlines

    DatabaseImporters::Importers::All << self

    extend MediaPathHelper


    def self.get_data
      FasterCSV.read(CONFIG['directories']['dbs'] + "/CourseOutlines.csv")[1..-1]
    end


    def self.priority
      1
    end


    def self.run
      get_data.each do |item|
        store(item)
      end
    end


    def self.get_parent(section)
      case section
      when 'DT'
        $r.hget CONFIG['directories']['input'] + 'teaching-snapshot/Course-Outlines/Digital-Technology/y11.htm', 'id'

      when 'DVC'
        $r.hget CONFIG['directories']['input'] + 'teaching-snapshot/Course-Outlines/Design-and-Visual-Communication/y11.htm', 'id'

      when 'PT'
        $r.hget CONFIG['directories']['input'] + 'teaching-snapshot/Course-Outlines/Process-Technology/y11.htm', 'id'

      when 'CMT'
        $r.hget CONFIG['directories']['input'] + 'teaching-snapshot/Course-Outlines/Construction-and-Mechanical-Technology/', 'id'
      end
    end


    def self.store(a)
      path = "DBIMPORT:/CourseOutline.htm?GID=#{a[5]}"

      $r.log_key(path)

      $r.hset path, 'id', $r.get_id(path)

      $r.hset path, 'parent', get_parent(a[3])

      $r.hset path, 'priority', '0'

      $r.hset path, 'type', 'course_outline'

      $r.hset path, 'fields', 'download_pdf:ezbinaryfile,body:ezxmltext,course_description:ezxmltext,year:ezstring,school:ezstring,title:ezstring,level:ezstring,curriculum_level:ezstring'

      $r.hset path, 'field_title', a[0]
      $r.hset path, 'field_school', a[7]
      $r.hset path, 'field_year', a[11]
      $r.hset path, 'field_level', a[10]
      $r.hset path, 'field_curriculum_level', a[9]
      $r.hset path, 'field_course_description', a[4]
      $r.hset path, 'field_body', a[6]

      file_link = LinkHelpers.parse(a[8], './input/teaching-snapshot/Course-Outlines/PDF-download/')

      file_path = $r.hget(mediaize_path(file_link.key, 'files'), 'field_file')

      if file_path
        $r.hset path, 'field_download_pdf', file_path
      end

      # Register general content for post_processing.
      PostProcessor.register path
    end
  end
end
