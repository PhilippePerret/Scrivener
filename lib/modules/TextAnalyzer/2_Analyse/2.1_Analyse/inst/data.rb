# encoding: UTF-8
class TextAnalyzer
class Analyse

  # {Array} des paths de fichier (String) à analyser et
  # {Array} des fichiers (instances TextAnalyzer::File) à analyser
  attr_accessor :paths, :files

  # L'instance contenant tous les résultats de l'analyse
  # Note : pour charger les données qui sont enregistrées dans le fichier,
  # pour le moment, on doit faire `<analyse>.table_resultats.get`
  def table_resultats
    @table_resultats ||= TextAnalyzer::Analyse::TableResultats.new(self)
  end


  # Le texte entier de l'analyse
  def texte_entier
    @texte_entier ||= TextAnalyzer::Analyse::WholeText.new(self)
  end
  
  def mots
    table_resultats.mots
  end

  def all_mots
    texte_entier.mots
  end

  def canons
    table_resultats.canons
  end

  def proximites
    table_resultats.proximites
  end

  # Retourne l'instance TextAnalyzer::File du fichier de l'analyse
  # courante d'identifiant +object_id+
  # Question : est-ce que ça sert encore ?
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
