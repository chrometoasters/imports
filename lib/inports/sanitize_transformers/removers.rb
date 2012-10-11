# Remove title (rm <title>)
RemoveTitle = lambda do |env|
  node = env[:node]
  name = env[:node_name]
  return if env[:is_whitelisted] || !node.element?

  if name == 'title'
    node.remove
  end
end


# Remove header (rm <p class="header">)
RemoveHeader = lambda do |env|
  node = env[:node]
  name = env[:node_name]
  return if env[:is_whitelisted] || !node.element?

  if node[:class] == 'header' && name == 'p'
    node.remove
  end
end


Removers = [RemoveTitle, RemoveHeader]

