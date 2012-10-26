# Convert <p class="subhead"> => <heading level="2">
SubheadToHeading2 = lambda do |env|
  node = env[:node]
  name = env[:node_name]
  return if env[:is_whitelisted] || !node.element?

  if node[:class] == 'subhead' && name == 'p'
    node.name = 'header'
    node[:level] = '2'
  end
end


# Convert <p class="subsubhead"> => <heading level="2">
SubsubheadToHeading3 = lambda do |env|
  node = env[:node]
  name = env[:node_name]
  return if env[:is_whitelisted] || !node.element?

  if node[:class] == 'subsubhead' && name == 'p'
    node.name = 'header'
    node[:level] = '3'
  end
end


# Convert <heading><strong> => <heading>
RemoveRedundantStrongs = lambda do |env|
  node = env[:node]
  name = env[:node_name]
  return if env[:is_whitelisted] || !node.element?

  if name == 'header' && node.child && node.child.name == 'strong'
    node.child.swap(node.child.children)
  end
end


Headings = [SubheadToHeading2, SubsubheadToHeading3, RemoveRedundantStrongs]

