# encoding: UTF-8
class TextAnalyzer
class Analyse
class TableResultats
class Segments < Array # <= Array !
  attr_accessor :analyse

  # Pour l'enregistrement des segments dans les fichiers YAML
  include ModuleForFromYaml


  def initialize ianalyse
    self.analyse = ianalyse
  end

  def yaml_properties
    {
      datas: {
        items:    {type: :method}
      }
    }
  end

  def items_for_yaml
    self.collect.to_a# { |seg| seg }
  end
  def items_from_yaml(adata)
    self.replace(adata)
  end

end #/Segments
end #/TableResultats
end #/Analyse
end #/TextAnalyzer
