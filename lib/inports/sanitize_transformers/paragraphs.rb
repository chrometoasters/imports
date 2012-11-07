# Convert <p class="subhead"> => <heading level="2">
PToParagraph = lambda do |env|
  node = env[:node]
  name = env[:node_name]
  return if env[:is_whitelisted] || !node.element?

  if name == 'p'
    node.name = 'paragraph'
  end
end


RemoveEmptyParagraphs = lambda do |env|
  node = env[:node]
  name = env[:node_name]
  return if env[:is_whitelisted] || !node.element?

  if name == 'paragraph'
    node.remove unless node.text =~ /\d|\w/
  end
end

# Keep the certain p classes.
KeepParagraphClasses = lambda do |env|
    node = env[:node]
    name = env[:node_name]
    return if env[:is_whitelisted] || !node.element?

    classesToKeep = ["small", "Red", "gallery-head"]

    if ( name == 'paragraph' || name == 'p')  && node[:class]
        classes = node[:class].split(' ')
        node.remove_attribute 'class'

        valid = classesToKeep & classes

        unless valid == []
            valid.sort! {|a,b| a <=> b}
            valid_class = valid.join(' ')
            node[:class] = valid_class.downcase
        end

        if valid.length > 1
            Logger.warning "#{valid_class}", "Multiple p classes being added"
        end
    end
end

Paragraphs = [KeepParagraphClasses, PToParagraph, RemoveEmptyParagraphs]
