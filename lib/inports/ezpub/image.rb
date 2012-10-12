module EzPub
  class Image < EzPub::Handler
      EzPub::Handlers::All << self
      EzPub::Handlers::Static << self

      def self.priority
        99
      end


      def self.mine?(path)
        false
      end


      def self.store(path)
        "#{self}.store is not defined."
      end
    end
end
