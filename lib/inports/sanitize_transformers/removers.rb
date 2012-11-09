# Remove title (rm <title>)
RemoveTitle = lambda do |env|
  node = env[:node]
  name = env[:node_name]
  return if env[:is_whitelisted] || !node.element?

  if name == 'title'
    node.remove
  end
end


# Remove header (rm <p class="header">)
RemoveHeader = lambda do |env|
  node = env[:node]
  name = env[:node_name]
  return if env[:is_whitelisted] || !node.element?

  if node[:class] == 'header' && name == 'p'
    node.remove
  end

  if node[:class] == 'header-dk-blue' && name == 'p'
    node.remove
  end
end


#<div id="footer-brown-papernav">Introduction | <a href="page2.htm">Technological Practice </a><br />
#<a href="page3.htm">Nature of Technology</a> | <a href="page4.htm">Technological Knowledge</a></div>
#</div>

RemoveFooterNav = lambda do |env|
  node = env[:node]
  name = env[:node_name]
  return if env[:is_whitelisted] || !node.element?

  if node.name == 'div' && node[:id] == 'footer-brown-papernav'
    node.remove
  end

  if node.name == 'div' && node[:id] == 'footer-brown'
    node.remove
  end
end


# Kill if style="display:none;"
RemoveHiddenElements = lambda do |env|
  node = env[:node]
  name = env[:node_name]
  return if env[:is_whitelisted] || !node.element?

  if node[:style] == 'display:none;'
    node.remove
  end
end

RemoveNoScript = lambda do |env|
  node = env[:node]
  name = env[:node_name]
  return if env[:is_whitelisted] || !node.element?

  if node.name == 'noscript'
    node.remove
  end
end

# cfquery <cfquery name="get_id" datasource="techlink">
# select * from careers where name = '#get_careers.name#' </cfquery>
RemoveQueries = lambda do |env|
  node = env[:node]
  name = env[:node_name]
  return if env[:is_whitelisted] || !node.element?

  if name == 'cfquery'
    node.remove
  end
end



Removers = [RemoveFooterNav, RemoveTitle, RemoveNoScript, RemoveHeader, RemoveHiddenElements, RemoveQueries]

