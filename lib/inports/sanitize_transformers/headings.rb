# Convert <p class="subhead"> => <header level="2">
SubheadToHeading2 = lambda do |env|
  node = env[:node]
  name = env[:node_name]
  return if env[:is_whitelisted] || !node.element?

  if node[:class] == 'subhead' && name == 'p'
    node.name = 'header'
    node[:level] = '2'
  end
end


# Convert <p class="subsubhead"> => <header level="3">
SubsubheadToHeading3 = lambda do |env|
  node = env[:node]
  name = env[:node_name]
  return if env[:is_whitelisted] || !node.element?

  if node[:class] == 'subsubhead' && name == 'p'
    node.name = 'header'
    node[:level] = '3'
  end
end

# Convert <p class="sub3 head"> => <header level="4">
Sub3ToHeading4 = lambda do |env|
    node = env[:node]
    name = env[:node_name]
    return if env[:is_whitelisted] || !node.element?

    if node[:class] == 'sub3 head' && name == 'p'
        node.name = 'header'
        node[:level] = '4'
    end
end

# Convert <p class="bold"> => <header level="5">
BoldToHeading5 = lambda do |env|
    node = env[:node]
    name = env[:node_name]
    return if env[:is_whitelisted] || !node.element?

    if node[:class] == 'bold' && name == 'p'
        node.name = 'header'
        node[:level] = '5'
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


Headings = [SubheadToHeading2, SubsubheadToHeading3, Sub3ToHeading4, BoldToHeading5, RemoveRedundantStrongs]

