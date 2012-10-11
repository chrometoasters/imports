# Remove title (rm <title>)
EmToEmphasize = lambda do |env|
  node = env[:node]
  name = env[:node_name]
  return if env[:is_whitelisted] || !node.element?

  if name == 'em'
    node.name = 'emphasize'
  end
end

Styles = [EmToEmphasize]
