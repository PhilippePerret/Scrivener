# encoding: UTF-8
=begin
  Module pour les méthodes d'entrée/sortie des résultats, c'est-à-dire
  d'écriture et de lecture des données enregistrées.
=end
class TextAnalyzer
class Analyse
class TableResultats

  # Retourne true si le fichier des résultats enregistrés existe
  def exist?
    File.exist?(file_path)
  end

  # Chemin d'accès au fichier des résultats de l'analyse dans le
  # dossier caché
  def yaml_file_path
    @yaml_file_path ||= File.join(analyse.hidden_folder, 'table_resultats.yaml')
    # @file_path ||= File.join(analyse.hidden_folder, 'table_resultats.msh')
  end
  alias :file_path  :yaml_file_path
  alias :path       :yaml_file_path

end #/TableResultats
end #/Analyse
end #/TextAnalyzer
