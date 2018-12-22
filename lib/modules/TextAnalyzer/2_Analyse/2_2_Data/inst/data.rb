# encoding: UTF-8
=begin

=end
class TextAnalyzer
class Analyse
class Data

  # Temps de démarrage et de fin de l'analyse
  attr_accessor :started_at, :ended_at

  # Version courante de l'application `TextAnalyzer`

  # {Array} Liste des paths qui vont constituer le fichier final, if any.
  # C'est une liste de paths relatifs
  attr_reader :paths
  def paths= arr_paths
    @paths = arr_paths.collect do |path|
      path.relative_path(analyse.folder)
    end
  end

end #/Data
end #/Analyse
end #/TextAnalyzer
