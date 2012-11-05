module Logger

  # Logs and prints a warning message.
  # Requires a type (which is the name of the log file the
  # warning will be stored as.
  #
  # Logger.warning(path, 'No heading')
  #
  # $ tail ./log/no-heading.log
  # $ ./curriculum/index.htm

  def self.warning(path, type, quiet = nil)
    log_file = './log/' + type.gsub(/\s|:/, '-').downcase + '.log'

    unless quiet
      puts $term.color("#{type} => ", :cyan) + $term.color("#{path}", [:white, :on_magenta])
    end

    f = File.open(log_file, 'a')
    f.write(path + "\n")
    f.close
  end
end
