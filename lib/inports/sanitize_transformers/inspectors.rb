# Helpers for inspecting content.

# Example of use:

# Processor.new.list.each do |path|
#   puts path
#   str = StringFromPath.get_case_insensitive(path)
#   path.gsub!('./input', 'http://www.techlink.org.nz')
#   Sanitize.clean(str, :transformers => [ClassAttributeInspector], :path => path)
# end

# File.open('classes.txt', 'a') do |f|
#   $r.smembers('classes').each do |line|
#     f.write(line + "\n")
#   end
# end

# File.open('examples.txt', 'a') do |f|
#   $r.smembers('examples').each do |line|
#     f.write(line + "\n")
#   end
# end

ClassAttributeInspector = lambda do |env|
  node = env[:node]
  name = env[:node_name]
  return if env[:is_whitelisted] || !node.element?

  if node[:class]
    $r.sadd 'examples', "#{env[:config][:path]} => <#{node.name}>  =>  #{node[:class]}"
    $r.sadd 'classes', "<#{node.name}>  =>  #{node[:class]}"
  end
end

Inspectors = [ClassAttributeInspector]
