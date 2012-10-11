# Convert nonsense table into ezboot boredered table.
SimpleTable = lambda do |env|
  node = env[:node]
  name = env[:node_name]
  return if env[:is_whitelisted] || !node.element?

  if name == 'table'
    node[:class] = 'table-bordered'
    node[:width] = '100%'
  end
end


Tables = [SimpleTable]
