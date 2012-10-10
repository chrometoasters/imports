class EzObject
  class << self
    attr_accessor :descendants

    # When a class inherits from EzObject
    # it is stored in the @@descendants class var.

    def inherited(subclass)
      @descendants << subclass
    end

    # Iterates through the child classes of EzObject
    # calling ::mine? on each.
    #
    # If a class accepts the item, its ::store method is called.

    def handle(path)
      handled = @descendants.each do |type|
        if type.mine? path
          type.store path
          return true
        end
      end

      handled == true ? true : false
    end


    def priority
      raise 'All children of EzObject need an int returning ::priority'
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
      parent = $r.hget path._parentize, 'id'
      if parent
        parent
      else
        raise Orphanity, "#{path} failed to find id of parent #{parent}"
      end
    end
  end
end
