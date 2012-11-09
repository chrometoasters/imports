module EzPub
  class InTreeFile < EzPub::Handler
    EzPub::HandlerSets::All << self
    EzPub::HandlerSets::Content << self

    extend NameMaker
    extend MediaPathHelper
    extend ImportPathHelper

    def self.priority
      # I should run nearly last,
      # to keep my ::mine? check simple.
      51
    end


    def self.mine?(path)
      response = false
      # Stops ptools throwing an exception in the unlikely event
      # of a previously unhandled directory.

      unless ::File.directory? path

        exts = /\.#{EZP_ICON_BINARY_EXTENSIONS.join('$|\.')}$/i

        if exts.match(path.downcase)
          if path =~ /\/Case-studies\/Classroom-practice\/|\/teaching-snapshot\/|\/student-showcase\/|\/Case-studies\/Technological-practice\//
            response = true
            puts 'inline-file!'
            Logger.warning path, 'creating inline file'
          end
        end
      end

      response
    end


    def self.store(path)
      file_path = $r.hget(mediaize_path(path, 'files'), 'field_file')

      if file_path
        $r.log_key(path)

        $r.hset path, 'id', $r.get_id(path)

        # Pass in a "media:files:./xyz" path, rather than a standard path.
        # (Since we want to match against the various Media locations).

        $r.hset path, 'parent', parent_id(path)

        $r.hset path, 'priority', '0'

        $r.hset path, 'type', 'file'

        $r.hset path, 'fields', 'file:ezbinaryfile,name:ezstring'

        $r.hset path, 'field_file', file_path
        $r.hset path, 'field_name', pretify_filename(file_path)
      else
        Logger.warning path, 'Failed to resolve binary link for inline file' unless path =~ /\/Thumbs\.db$/
      end
    end
  end
end
