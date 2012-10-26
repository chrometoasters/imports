module ImportPathHelper
  def trim_for_ezp(path)
    path.gsub(/^\.\/output\//, '')
  end
end
