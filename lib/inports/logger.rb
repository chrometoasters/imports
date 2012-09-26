module Logger
  def warning(path, type)
    log_file = './log/' + type + '.log'

    puts $term.color("Logging item as #{type} => #{log_file}", :yellow)

    File.open(log_file, 'a') {|f| f.write(path + '\n') }
  end
end
