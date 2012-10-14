module Formatter
  class XML
    def namespace
      {
        'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
        'xsi:noNamespaceSchemaLocation' => 'file:'
      }
    end


    def output(keys, opts = {})
      dir = opts[:dir] || CONFIG['directories']['output']['xml']
      name = opts[:name] || 'import'

      generate(keys)

      output_path = dir + "/#{name}.xml"

      file = File.new(output_path, "w")
      file.write(@builder.to_xml.to_s)
      file.close

      output_path
    end


    def generate(keys)
      @builder = Nokogiri::XML::Builder.new do |xml|
        xml.ezpublish(namespace) do

          xml.send('AdministrativeMetadata') do
            xml.name 'Techlink import'
            xml.export_date Time.now
            xml.country 'New Zealand'
          end

          # Start main loop through all keys.

          keys.each do |k|

            xml.objects do

              # Get all properties for this object.

              h = $r.hgetall k

              obj_props = {
                :parent_remote_id => h['parent'],
                :priority => h['priority'],
                :remote_id => h['id'],
              }

              # Get field info.

              fields = h['fields']._explode_fields

              # Declare object.

              xml.send h['type'], obj_props do

                # Add all field data.
                fields.each do |field|
                  field.each do |k,v|

                    xml.send k, {:datatype => v} do
                      xml.cdata h['field_' + k]
                    end

                  end # field hash
                end # fields array
              end # object
            end # objects
          end # key loop
        end # ezpublish
      end # builder
    end
  end
end
