# encoding: UTF-8
=begin

=end
class TextAnalyzer
class Analyse
class Data

  include ModuleForFromYaml

  # Temps de démarrage et de fin de l'analyse
  attr_accessor :started_at, :ended_at

  # Version courante de l'application `TextAnalyzer`
  attr_accessor :text_analyzer_version

  # {Array} Liste des paths qui vont constituer le fichier final, if any.
  # C'est une liste de paths relatifs
  attr_reader :paths
  def paths= arr_paths
    @paths = arr_paths.collect do |path|
      path.relative_path(analyse.folder)
    end
  end

  # Définition des propriétés à sauver
  # Pour le module YAML
  def yaml_properties
    self.text_analyzer_version ||= TextAnalyzer.version
    {
      analyse_path: analyse.yaml_file_path,
      datas: {
        text_analyzer_version:  {type: YAPROP},
        paths:                  {type: YAPROP},
        started_at:             {type: YAPROP},
        ended_at:               {type: YAPROP}
      }
    }
  end

end #/Data
end #/Analyse
end #/TextAnalyzer
