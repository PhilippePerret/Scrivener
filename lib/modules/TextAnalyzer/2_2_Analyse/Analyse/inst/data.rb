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

  # Retourne l'instance TextAnalyzer::File du fichier de l'analyse
  # courante d'identifiant +object_id+
  def get_file object_id
    files[object_id]
  end

end #/Analyse
end #/TextAnalyzer
