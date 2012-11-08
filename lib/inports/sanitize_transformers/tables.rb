# Convert nonsense table into ezboot bordered table.
SimpleTable = lambda do |env|
  node = env[:node]
  name = env[:node_name]
  return if env[:is_whitelisted] || !node.element?

  if name == 'table'
      node[:class] = node[:class] + ' table-bordered'
    node[:width] = '100%'
  end
end


# Case studies table whitelisting as these will be handled by CSS as is.
CaseStudiesTable = lambda do |env|
  node = env[:node]
  name = env[:node_name]
  return if env[:is_whitelisted] || !node.element?

  if name == 'table' && node[:class] == 'cover-table'
    node.remove_attribute 'cellpadding'
    node.remove_attribute 'cellspacing'

    {:node_whitelist => [node]}
  end
end

# Keep the certain table classes.
KeepTableClasses = lambda do |env|
    node = env[:node]
    name = env[:node_name]
    return if env[:is_whitelisted] || !node.element?

    classesToKeep = ["table-bordered", "PCS-Table", "footertable2", "progressiontable", "TechEdASTable", "unit-plan-table", "unit-plan-table-borders"]

    if name == 'table' && node[:class]
        classes = node[:class].split(' ')
        node.remove_attribute 'class'

        valid = classesToKeep & classes

        unless valid == []
            valid.sort! {|a,b| a <=> b}
            valid_class = valid.join(' ')
            node[:class] = valid_class
        end

        if valid.length > 1
            Logger.warning "#{valid_class}", "Multiple table classes being added"
        end
    end
end

# Remove <tr>s with class hide
RemoveHiddenTableRows = lambda do |env|
    node = env[:node]
    name = env[:node_name]
    return if env[:is_whitelisted] || !node.element?

    if name == 'tr' && node[:class] == 'hide'
        node.remove
    end
end


# Keep the certain tr classes.
KeepTableRowClasses = lambda do |env|
    node = env[:node]
    name = env[:node_name]
    return if env[:is_whitelisted] || !node.element?

    classesToKeep = ["italics"]

    if name == 'tr' && node[:class]
        classes = node[:class].split(' ')
        node.remove_attribute 'class'

        valid = classesToKeep & classes

        unless valid == []
            valid.sort! {|a,b| a <=> b}
            valid_class = valid.join(' ')
            node[:class] = valid_class
        end

        if valid.length > 1
            Logger.warning "#{valid_class}", "Multiple tr classes being added"
        end
    end
end

# Keep the certain td classes.
KeepTableCellClasses = lambda do |env|
    node = env[:node]
    name = env[:node_name]
    return if env[:is_whitelisted] || !node.element?

    classesToKeep = ["cover-table-subsubhead"]

    if name == 'td' && node[:class]
        classes = node[:class].split(' ')
        node.remove_attribute 'class'

        valid = classesToKeep & classes

        unless valid == []
            valid.sort! {|a,b| a <=> b}
            valid_class = valid.join(' ')
            node[:class] = valid_class
        end

        if valid.length > 1
            Logger.warning "#{valid_class}", "Multiple td classes being added"
        end
    end
end

Tables = [CaseStudiesTable, KeepTableClasses, RemoveHiddenTableRows, KeepTableRowClasses, KeepTableRowClasses, KeepTableCellClasses]
