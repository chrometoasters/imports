module EzPub
  class Image < EzPub::Handler
    Handlers::All << self
    Handlers::Static << self
    Handlers::Images << self

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
