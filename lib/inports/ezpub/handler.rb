module EzPub
  class Handler
    class << self

      def priority
        raise 'All children of EzObject need ::priority to return an integer.'
      end


      def mine?(path)
        puts "#{self}.mine? is not defined."
      end


      def store(path)
        "#{self}.store is not defined."
      end


      # Finds parent id for an item, using the _parentize
      # method we've added to string (shortens path down a level).
      #
      # Overide in child classes if necessary.

      def parent_id(path)
        if path._parentize == path
          # hard parentize
        else
          parent = $r.hget path._parentize, 'id'
        end

        if parent
          parent
        else
          raise Orphanity, "#{path} failed to find id of parent #{parent}"
        end
      end

    end
  end
end
