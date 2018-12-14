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

  # Raccourci de table_resultats.output qui gère la sortie des résultats
  def output ; table_resultats.output end

  # Le texte entier de l'analyse
  def texte_entier
    @texte_entier ||= TextAnalyzer::Analyse::WholeText.new(self)
  end

  # Retourne l'instance TextAnalyzer::File du fichier de l'analyse
  # courante d'identifiant +object_id+
  def get_file object_id
    files[object_id]
  end

  # Le dossier caché de l'analyse, pour mettre tous les fichiers utiles et
  # produits.
  # Pour le trouver, on utilise le premier path de texte à traiter. C'est
  # par exemple le projet Scrivener.
  # Note : on construit le dossier s'il n'existe pas (et toute sa hiérarchie).
  def hidden_folder
    @hidden_folder ||= begin
      d = File.join(File.expand_path(File.dirname(paths.first)), '.textanalyzer')
      `mkdir -p "#{d}"`
      d
    end
  end

end #/Analyse
end #/TextAnalyzer
