# Convert <p class="subhead"> => <heading level="2">
Mail = lambda do |env|
  node = env[:node]
  name = env[:node_name]
  return if env[:is_whitelisted] || !node.element?

  if name == 'a' && node[:href] =~  /^mailto:/
    node.name = 'link'
  end
end

Links = [Mail]
