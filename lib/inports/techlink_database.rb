class TechlinkDatabase

  def glossary
    FasterCSV.read(CONFIG['directories']['dbs'] + "/Glossary.csv")
  end

end
