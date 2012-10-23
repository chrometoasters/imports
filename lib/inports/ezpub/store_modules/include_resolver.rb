module IncludeResolver
  # Module for resolving cfinclude tags within a string.

  def resolve_includes(path, opts={})
    return_type = opts[:return] || :string

    doc = get_nokogiridoc_from_path(path)

    if doc.xpath('//cfinclude[@template]').first

      doc.xpath('//cfinclude[@template]').each do |cfinclude|
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

    end
    # Sometimes it's much more efficient to return a doc (making further file loads
    # and parses unecessary).

    # Passing any :return => :whatever value will cause this method to return a
    # nokogiri doc.

    if return_type == :string
      doc.to_s
    else
      doc
    end
  end


  def make_path_absolute(template_path, path)
    unless template_path =~ /^\//
      path._parentize + template_path
    else
      CONFIG['directories']['input'] + template_path
    end
  end


  def get_nokogiridoc_from_path(path, for_insertion = nil)
    # We're checking for and retrieving files non-case-sentiviely, as this appears
    # to be how it was done originally.

    str = StringFromPath.get_case_insensitive(path)

    if str

      # Full Nokogiri documents can't be passed to node#add_child.
      # So we provide the option to return a fragment if the second
      # argument is anything but nil.

      if for_insertion
        parsed = Nokogiri::HTML.fragment(str)
      else
        parsed = Nokogiri::HTML(str)
      end

      parsed
    else
      Logger.warning path, 'Unresolved cfinclude'

      if for_insertion
        '<include_tag_that_could_not_be_resolved />'
      else
        nil
      end
    end
  end
end
