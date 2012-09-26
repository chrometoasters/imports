class EzObject
  @@descendants = []

  def self.register(klass)
    @@descendants << klass
  end


  def self.dispatch(path)
    @@descendants.each do |type|
      if type.mine? path
        type.store path
        return true
      end
    end
  end


  def self.mine?(path)
    puts "#{self}.me? is not defined."
  end


  def self.store(path)
    "#{self}.store is not defined."
  end
end
