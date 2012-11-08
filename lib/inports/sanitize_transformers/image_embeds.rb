# <embed size="original" object_id="bb850ec7d5a6d66b82d56bbafed0565e"/>

BasicImage = lambda do |env|
  node = env[:node]
  name = env[:node_name]
  context_path = env[:config][:path]

  return if env[:is_whitelisted] || !node.element?

  if name == 'img'
    include MediaPathHelper

    node.name = 'embed'
    node[:size] = 'original'

    src = node[:src]

    link = LinkHelpers.parse(src, context_path)

    object_id = $r.hget(mediaize_path(link.key, 'images'), 'id')

    if node.parent[:rel]
      if node.parent[:rel] =~ /lightbox/
        larger_src = node.parent[:href] if node.parent[:href]

        link = LinkHelpers.parse(larger_src, context_path)

        id = $r.hget(mediaize_path(link.key, 'images'), 'id')

        if id
          object_id = id
        end
      end
    end

    if object_id
      node[:object_id] = object_id
    end

    node.remove_attribute 'src'
  end
end

# Add align="right" to embeds based on certain criteria
# By default, images are aligned left in ezpub so we're just adding rules for aligning images to the right.
# <embed size="original" object_id="bb850ec7d5a6d66b82d56bbafed0565e" alignt="right" />
AddRightAlignment = lambda do |env|
    node = env[:node]
    name = env[:node_name]
    return if env[:is_whitelisted] || !node.element?

    if name == 'embed'
        classesToAlignRight = ["Float-image-right", "FloatRight"]

        # determine alignment from grandparent class
        if node.parent.parent && node.parent.parent[:class]
            classes = node.parent.parent[:class].split(' ')
            valid = classesToAlignRight & classes
            unless valid == []
                node[:align] = 'right'
            end
        end

        # determine alignment from parent class
        if node.parent && node.parent[:class]
            classes = node.parent[:class].split(' ')
            valid = classesToAlignRight & classes
            unless valid == []
                node[:align] = 'right'
            end
        end

        # determine alignment from image class
        if node[:class]
            classes = node[:class].split(' ')
            valid = classesToAlignRight & classes
            unless valid == []
                node[:align] = 'right'
            end
        end
    end
end

# <a title="Screenshot from the Spektrym site." rel="lightbox a" href="images/Spektrym/Spektrym-3.jpg"><img width="200" height="114" alt="Screenshot from the Spektrym site." src="images/Spektrym/Th-Spektrym-3.jpg"> Screenshot from the Spektrym site. <br>(Click image to enlarge.)</a> => <embed size="original" custom:lightbox="yes" href="ezobject://13196" />
AddLightboxMarkup = lambda do |env|
    node = env[:node]
    name = env[:node_name]
    return if env[:is_whitelisted] || !node.element?

    if name == 'embed' && node.parent && node.parent[:rel] && node.parent[:rel] =~ /lightbox/
        node.set_attribute("custom:lightbox", 'yes')
        node[:size] = 'medium'
        node.parent.replace node.parent.children
    end
end

ImageEmbeds = [BasicImage, AddRightAlignment, AddLightboxMarkup]

