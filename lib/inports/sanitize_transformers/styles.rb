# <em> => <emphasize>
EmToEmphasize = lambda do |env|
  node = env[:node]
  name = env[:node_name]
  return if env[:is_whitelisted] || !node.element?

  if name == 'em'
    node.name = 'emphasize'
  end
end


# <div class="glossarybox> or <p class="glossarybox"> => <custom name="glossarybox"
GlossaryBoxToCustomTag = lambda do |env|
  node = env[:node]
  name = env[:node_name]
  return if env[:is_whitelisted] || !node.element?

  if ( name == 'div' || name == 'paragraph') && node[:class] == 'glossarybox'
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

# http://www.techlink.org.nz/Case-studies/Classroom-practice/Food-and-Biological/CP909-saleable-lunches/background.htm
# <div class="round-box-275"> => <custom name="round-box-275"
RoundBox275ToCustomTag = lambda do |env|
    node = env[:node]
    name = env[:node_name]
    return if env[:is_whitelisted] || !node.element?

    if name == 'div' && node[:class] == 'round-box-275'
        node.name = 'custom'
        node[:name] = 'round-box-275'
    end
end

# <div class="splitright"> => <custom name="factbox"
SplitRightToCustomTag = lambda do |env|
    node = env[:node]
    name = env[:node_name]
    return if env[:is_whitelisted] || !node.element?

    if name == 'div' && node[:class] == 'splitright'
        node.name = 'custom'
        node[:name] = 'factbox'
    end
end

# <div class="TS-strategy"> => <custom name="ts-strategy"
TSStrategyToCustomTag = lambda do |env|
    node = env[:node]
    name = env[:node_name]
    return if env[:is_whitelisted] || !node.element?

    if name == 'div' && node[:class] == 'TS-strategy'
        node.name = 'custom'
        node[:name] = 'ts-strategy'
    end
end

# <div class="PDF-right"> => <custom name="pdf-right"
PDFRightToCustomTag = lambda do |env|
    node = env[:node]
    name = env[:node_name]
    return if env[:is_whitelisted] || !node.element?

    if name == 'div' && node[:class] == 'PDF-right'
        node.name = 'custom'
        node[:name] = 'pdf-right'
    end
end

# <div class="box-blue-low"> => <custom name="box-blue-low"
BlueBoxLowToCustomTag = lambda do |env|
    node = env[:node]
    name = env[:node_name]
    return if env[:is_whitelisted] || !node.element?

    if name == 'div' && node[:class] == 'box-blue-low'
        node.name = 'custom'
        node[:name] = 'box-blue-low'
    end
end

# <div class="bluebox3"> => <custom name="bluebox3"
BlueBox3ToCustomTag = lambda do |env|
    node = env[:node]
    name = env[:node_name]
    return if env[:is_whitelisted] || !node.element?

    if name == 'div' && node[:class] == 'bluebox3'
        node.name = 'custom'
        node[:name] = 'bluebox3'
    end
end

# class="Green" to class="green" for any element
GreenTogreen = lambda do |env|
    node = env[:node]
    name = env[:node_name]
    return if env[:is_whitelisted] || !node.element?

    if node[:class] == 'Green'
        node[:class] = 'green'
    end
end

#  <ul class="links"> to <custom name="linksbox"><ul class="links">{content}</ul></custom>
ULLinksToCustomTag = lambda do |env|
    node = env[:node]
    name = env[:node_name]
    return if env[:is_whitelisted] || !node.element?

    if name == 'ul' && node[:class] == 'links'
        previous_children = node.children
        node.name = 'custom'
        node[:name] = 'linksbox'
        node.add_child "<ul class='links'></ul>"
        node.children.css('ul.links').first.add_child previous_children
    end
end

# <hr> => <custom name="hr"
HRToCustomTag = lambda do |env|
    node = env[:node]
    name = env[:node_name]
    return if env[:is_whitelisted] || !node.element?

    if name == 'hr'
        node.name = 'custom'
        node[:name] = 'hr'
    end
end

Styles = [EmToEmphasize, GlossaryBoxToCustomTag, RoundBoxToCustomTag, RoundBox275ToCustomTag, SplitRightToCustomTag, TSStrategyToCustomTag, PDFRightToCustomTag, BlueBoxLowToCustomTag,BlueBox3ToCustomTag, GreenTogreen, ULLinksToCustomTag, HRToCustomTag]
