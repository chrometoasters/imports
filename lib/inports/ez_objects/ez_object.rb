class EzObject
  @@descendants = []

  def self.inherited(subclass)
    @@descendants << subclass
  end


  def self.handle(path)
    handled = @@descendants.each do |type|
      if type.mine? path
        type.store path
        return true
      end
    end

    handled == true ? true : false
  end


  def self.mine?(path)
    puts "#{self}.mine? is not defined."
  end


  def self.store(path)
    "#{self}.store is not defined."
  end
end
