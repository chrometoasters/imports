# Convert <p class="subhead"> => <heading level="2">
SubheadToHeading = lambda do |env|
  node = env[:node]
  name = env[:node_name]
  return if env[:is_whitelisted] || !node.element?

  if node[:class] == 'subhead' && name == 'p'
    node.name = 'heading'
    node[:level] = '2'
  end
end

Headings = [SubheadToHeading]

