# Convert nonsense table into ezboot bordered table.
SimpleTable = lambda do |env|
  node = env[:node]
  name = env[:node_name]
  return if env[:is_whitelisted] || !node.element?

  if name == 'table'
    node[:class] = 'table-bordered'
    node[:width] = '100%'
  end
end


# Case studies table whitelisting as these will be handled by CSS as is.
CaseStudiesTable = lambda do |env|
  node = env[:node]
  name = env[:node_name]
  return if env[:is_whitelisted] || !node.element?

  if name == 'table' && node[:class] == 'cover-table'
    {:node_whitelist => [node]}
  end
end


Tables = [CaseStudiesTable, SimpleTable]
