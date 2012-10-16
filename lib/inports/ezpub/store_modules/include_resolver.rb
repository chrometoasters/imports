module IncludeResolver
  # Module for resolving cfinclude tags within a string.

  def resolve_includes(path)
    doc = get_nokogiridoc_from_path(path)

    doc.xpath('//cfinclude[@template]').each do |cfinclude|
      puts cfinclude[:template]
      template_path = cfinclude[:template]

      # Sometimes template attributes have jibberish in them,
      # so we check it's a valid path.

      if template_path =~ /\.cfm$/

        # Template paths are a mix of relative and absolute paths.
        # In both cases we want to modify the template path to sit
        # in our input directory.

        template_path = make_path_absolute(template_path, path)

        include_nodes = get_nokogiridoc_from_path(template_path, 'fragment')

        # We insert the include nodes as a child of the cfinclude tag in order
        # as a means of handling the revolting nesting going on in the source,
        # and to provide traceability.

        cfinclude.add_child include_nodes
      end
    end
    doc.to_s
  end


  def make_path_absolute(template_path, path)
    unless template_path =~ /^\//
      path._parentize + '/' + template_path
    else
      CONFIG['directories']['input'] + template_path
    end
  end


  def get_nokogiridoc_from_path(path, for_insertion = nil)
    # Safety check. We log and return a unique tag if
    # the sepcified include file does not exist.

    if File.exists? path

      file = File.open(path)

      # Full Nokogiri documents can't be passed to node#add_child.
      # So we provide the option to return a fragment if the second
      # argument is anything but nil.

      if for_insertion
        parsed = Nokogiri::HTML.fragment(file.read)
      else
        parsed = Nokogiri::HTML(file.read)
      end

      parsed
    else
      Logger.warning path, 'Unresolved cfinclude'
      '<include_tag_that_could_not_be_resolved />'
    end
  end
end
