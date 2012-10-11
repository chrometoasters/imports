# Convert <p class="subhead"> => <heading level="2">
Mail = lambda do |env|
  node = env[:node]
  name = env[:node_name]
  return if env[:is_whitelisted] || !node.element?

  if name == 'a' && node[:href] =~  /^mailto:/
    node.name = 'link'
  end
end


# <a name="thing"></a> => <anchor name="registering"></anchor>
AnchorEndPoint = lambda do |env|
  node = env[:node]
  name = env[:node_name]
  return if env[:is_whitelisted] || !node.element?

  if name == 'a' && node[:name]
    node.name = 'anchor'
  end
end


# <a href="#thing"></a> => <link href="#thing"></link>
AnchorLink = lambda do |env|
  node = env[:node]
  name = env[:node_name]
  return if env[:is_whitelisted] || !node.element?

  if name == 'a' && node[:href] =~ /^#\S+/
    node.name = 'link'
  end
end


# <a href="http://thing.com"></a> => <link href="http://thing.com"></link>
ExternalLink = lambda do |env|
  node = env[:node]
  name = env[:node_name]
  return if env[:is_whitelisted] || !node.element?

  if name == 'a' && node[:href] =~  /https?\:\/\/\S+/
    node.name = 'link'
  end
end


Links = [AnchorEndPoint, AnchorLink, Mail, ExternalLink]
