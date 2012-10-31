module Formatter
  class XML
    def namespace
      {
        'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
        'xsi:schemaLocation' => 'http://technology.tki.org.nz techlink.xsd'
      }
    end


    def output(keys, opts = {})
      dir = opts[:dir] || CONFIG['directories']['output']['xml']
      name = opts[:name] || 'import'

      generate(keys)

      output_path = dir + "/#{name}.xml"

      file = File.new(output_path, "w")
      file.write(@builder.to_xml.to_s._force_utf8)
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

          xml.objects do

            keys.each do |k|

              # Get all properties for this object.

              h = $r.hgetall k

              obj_props = {
                :parent_remote_id => h['parent'],
                :priority => h['priority'],
                :remote_id => h['id'],
                :name => h['type'],
              }

              # Declare object.

              xml.object obj_props do

                # Get field info.

                fields = h['fields']._explode_fields

                # Add all field data.

                fields.each do |field|
                  field.each do |k,v|

                    xml.attribute(:name => k, :datatype => v) do

                      # Field keys are always prefixed with 'field_'

                      xml.cdata h['field_' + k]
                    end

                  end # field hash
                end # fields array
              end # object
            end # keys loop
          end # objects
        end # ezpublish
      end # builder
    end
  end
end
