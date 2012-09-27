module Logger

  # Logs and prints a warning message.
  # Requires a type (which is the name of the log file the
  # warning will be stored as.

  def self.warning(path, type)
    log_file = './log/' + type + '.log'

    puts $term.color("Logging item as #{type} => #{log_file}", :yellow)

    File.open(log_file, 'a') {|f| f.write(path + '\n') }
  end
end
