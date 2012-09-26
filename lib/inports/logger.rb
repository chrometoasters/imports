module Logger
  def warn(path, type)
    File.open('./log/' + type + '.log', 'a') {|f| f.write(path + '\n') }
  end
end
