# encoding: UTF-8
=begin

=end
class TextAnalyzer
class Analyse
class TableResultats
class Mot

  # Pour la gestion des données YAML
  include ModuleForFromYaml

  attr_accessor :real, :downcase
  # Valeur pour pouvoir le trier
  attr_accessor :sortish
  attr_accessor :data

  # Liste des index du mot
  attr_accessor :indexes

  def yaml_properties
    {
      dispatched: {
        real:       {type: YAPROP},
        downcase:   {type: YAPROP},
        sortish:    {type: YAPROP},
        indexes:    {type: YAPROP},
        data:       {type: YAPROP},
        count:      {type: YIVAR}
      }
    }
  end


  def count
    @count ||= indexes.count
  end

end #/Mot
end #/TableResultats
end #/Analyse
end #/TextAnalyzer
