# <embed size="original" object_id="bb850ec7d5a6d66b82d56bbafed0565e"/>

BasicImage = lambda do |env|
  node = env[:node]
  name = env[:node_name]
  return if env[:is_whitelisted] || !node.element?

  if name == 'img'
    node.name = 'embed'
    node[:size] = 'original'
    src = node[:src]

    link = LinkHelpers.new(src)

    include MediaPathHelper

    id = $r.hget(mediaize_path(link.key, 'images'), 'id')
    if id
      node[:object_id] = id
    end
  end
end

ImageEmbeds = [BasicImage]
