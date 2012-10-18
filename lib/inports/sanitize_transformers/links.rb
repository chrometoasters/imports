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


# <a href="/somehwere/internal.htm"></a> => <link href="eznode://0f2d5c080f60022be272ff2fd911cbca"></link>
InternalAbsoluteLink = lambda do |env|
  node = env[:node]
  name = env[:node_name]
  return if env[:is_whitelisted] || !node.element?

  if name == 'a' && node[:href] =~  /^\//
    node.name = 'link'

    path = node[:href]

    # unless path is in array of forbidden paths....

    path.gsub!(/#\w+$/, '')

    key = CONFIG['directories']['input'] + path

    new_href = $r.hget(key, 'id')

    if new_href
      new_href = 'eznode://' + new_href

      puts new_href
      puts node[:href]

      node[:href] = new_href
    else
      raise UnresolvedInternalLink, "Couldn't resolve #{node[:href]}"
    end
  end
end


Links = [AnchorEndPoint, AnchorLink, Mail, InternalAbsoluteLink, ExternalLink]
