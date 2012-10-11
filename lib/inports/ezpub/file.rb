module EzPub
  class File < EzPub::Handler
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
    end
  end
end
