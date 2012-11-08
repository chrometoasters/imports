module Descriptions
  include IsARedirect
  def get_db_description(path)
    link = LinkHelpers.parse(path, './input/')
    search_table = FasterCSV.read(CONFIG['directories']['dbs'] + "/TechSearch.csv")

    search_table.each do |table_row|
      table_path = './input' + table_row[7]
      redirect = redirect? table_path

      if table_path == path || redirect == path
        description = table_row[8]

        return description

      else
        return nil
      end
    end
  end
end
