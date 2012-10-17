module IsARedirect
  def redirect?(path)
    str = StringFromPath.get_case_insensitive(path)
    doc = Nokogiri::HTML(str)

    if doc.xpath("//cfheader[@statuscode='301']")
      # Return the destination.
      doc.xpath("//cfheader[@name='Location']").first[:value]
    else
      false
    end
  end
end
