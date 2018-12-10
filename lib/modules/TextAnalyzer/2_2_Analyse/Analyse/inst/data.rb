# encoding: UTF-8
class TextAnalyzer
class Analyse

  # {Array} des paths de fichier (String) à analyser et
  # {Array} des fichiers (instances TextAnalyzer::File) à analyser
  attr_accessor :paths, :files

  # L'instance contenant tous les résultats de l'analyse
  def table_resultats
    @table_resultats ||= TextAnalyzer::Analyse::TableResultats.new(self)
  end

end #/Analyse
end #/TextAnalyzer
