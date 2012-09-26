class XML
  def output(keys)
    generate(keys)
    @builder.to_xml.to_s

    output_path = CONFIG['directories']['output'] + '/content.xml'
    file = File.new(output_path, "w")
    file.write(@builder.to_xml.to_s)
    file.close

    output_path
  end

  def generate(keys)
    @builder = Nokogiri::XML::Builder.new do |xml|
      xml.all {
        keys.each do |k|

          h = $r.hgetall k

          xml.entry(:type => h['type'], :id => h['id'], :parent_id => h['parent']){
            xml.field(h['title'], :name => 'title')
            xml.field(:name => 'body'){
              xml.cdata h['body']
            }
          }
        end
      }
    end
  end
end
