# <em> => <emphasize>
EmToEmphasize = lambda do |env|
  node = env[:node]
  name = env[:node_name]
  return if env[:is_whitelisted] || !node.element?

  if name == 'em'
    node.name = 'emphasize'
  end
end


# <div class="glossarybox> => <custom name="glossarybox"
GlossaryBoxToCustomTag = lambda do |env|
  node = env[:node]
  name = env[:node_name]
  return if env[:is_whitelisted] || !node.element?

  if name == 'div' && node[:class] == 'glossarybox'
    node.name = 'custom'
    node[:name] = 'glossarybox'
  end
end


# http://www.techlink.org.nz/info-for-parents/index.htm
# <div class="round-box"> => <custom name="round-box"
RoundBoxToCustomTag = lambda do |env|
  node = env[:node]
  name = env[:node_name]
  return if env[:is_whitelisted] || !node.element?

  if name == 'div' && node[:class] == 'round-box'
    node.name = 'custom'
    node[:name] = 'round-box'
  end
end



Styles = [EmToEmphasize, GlossaryBoxToCustomTag, RoundBoxToCustomTag]
