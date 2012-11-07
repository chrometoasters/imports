module Descriptions
  include IsARedirect
  def get_db_description(path)


    link = LinkHelpers.parse(path, './input/')
    search_table = FasterCSV.read(CONFIG['directories']['dbs'] + "/TechSearch.csv")

    search_table.each do |table_row|
      table_path = './input' + table_row[7]
      redirect = redirect? table_path

      if table_path == path || redirect == path
        return table_row[8]
      else
        return nil
      end
    end
  end
end
