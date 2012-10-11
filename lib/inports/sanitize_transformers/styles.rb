# <em> => <emphasize>
EmToEmphasize = lambda do |env|
  node = env[:node]
  name = env[:node_name]
  return if env[:is_whitelisted] || !node.element?

  if name == 'em'
    node.name = 'emphasize'
  end
end


# <div class="glossarybox> => <custom name="factbox" custom:title="Title goes here" custom:heading-type="h4">
GlossaryBoxToCustomTag = lambda do |env|
  node = env[:node]
  name = env[:node_name]
  return if env[:is_whitelisted] || !node.element?

  if name == 'div' && node[:class] == 'glossarybox'
    node.name = 'custom'
    node[:name] = 'glossarybox'
  end
end


Styles = [EmToEmphasize, GlossaryBoxToCustomTag]
