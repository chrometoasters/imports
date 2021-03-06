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


InternaliseTechlinkLinks = lambda do |env|
  node = env[:node]
  name = env[:node_name]
  return if env[:is_whitelisted] || !node.element?

  if name == 'a' && node[:href] =~  /http:\/\/(www\.)?techlink\.org\.nz(.+)/i
    match = /http:\/\/(www\.)?techlink\.org\.nz(.+)/.match(node[:href])
    node[:href] = match[2] if match[2]
  end
end


# remove links to the glossary
RemoveGlossaryLink = lambda do |env|
  node = env[:node]
  name = env[:node_name]
  return if env[:is_whitelisted] || !node.element?

  if name == 'a' && node[:href] =~  /[^:]+glossaryitem\.htm/i
    node.replace node.text
  end
end


# remove links to the glossary
RemoveItemLink = lambda do |env|
  node = env[:node]
  name = env[:node_name]
  return if env[:is_whitelisted] || !node.element?

  if name == 'a' && node[:href] =~  /[^:]+item\.htm/i
    node.replace node.text
  end
end


# <a href="/somehwere/internal.htm"></a> => <link href="eznode://0f2d5c080f60022be272ff2fd911cbca"></link>
# <a href="internal.htm"></a> => <link href="eznode://0f2d5c080f60022be272ff2fd911cbca"></link>
InternalLink = lambda do |env|
  node = env[:node]
  name = env[:node_name]
  context_path = env[:config][:path]

  return if env[:is_whitelisted] || !node.element?

  if name == 'a' && node[:href] =~ /^[^:]{8}/
    node.name = 'link'

    link = LinkHelpers.parse node[:href], context_path

    # Look for a direct key match, or run through our special cases.
    new_href = $r.hget(link.key, 'id') || LinkHelpers.special_resolvers(link)

    if new_href
      # Add anchor back to link now that we're matched.
      new_href = new_href + link.anchor if link.anchor

      new_href = 'eznode://' + new_href

      node[:href] = new_href
    else
      Logger.warning "#{context_path} -> #{node[:href]}", 'unresolved internal links'
      #raise UnresolvedInternalLink, "Couldn't resolve #{node[:href]}"
    end
  end
end


#<a href="/thing.pdf"></a> => <link href="eznode://49827349872349"> <link/>
MediaLink = lambda do |env|
  include MediaPathHelper

  node = env[:node]
  name = env[:node_name]
  context_path = env[:config][:path]

  return if env[:is_whitelisted] || !node.element?

  if name == 'a' && node[:href] =~ /^[^:]{8}/

    exts = /\.#{EZP_FILE_EXTENSIONS.join('$|\.')}/i

    # Check this link goes to a media item.
    if node[:href] =~ exts

      link = LinkHelpers.parse node[:href], context_path

      node.name = 'link'

      unless node[:rel] =~ /lightbox/
        id = $r.hget(mediaize_path(link.key, 'files'), 'id')
      else
        id = $r.hget(mediaize_path(link.key, 'images'), 'id')
      end

      if id
        new_href = 'importmedia://' + id

        node[:href] = new_href
      else
        Logger.warning "#{context_path} -> #{node[:href]}", 'unresolved internal media links'
        #raise UnresolvedInternalLink, "Couldn't resolve media link #{node[:href]}"
      end
    end
  end
end


Links = [InternaliseTechlinkLinks, AnchorEndPoint, RemoveItemLink, RemoveGlossaryLink, AnchorLink, Mail, MediaLink, InternalLink, ExternalLink]
