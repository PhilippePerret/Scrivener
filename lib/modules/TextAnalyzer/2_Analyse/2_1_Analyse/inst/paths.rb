# encoding: UTF-8
class TextAnalyzer
class Analyse

  # Fichier pour enregistrer les données
  def yaml_file_path
    @yaml_file_path ||= File.join(hidden_folder,'analyse.yaml')
  end

  # Définit et retourne le dossier de l'analyse (le dossier du projet, en
  # réalité)
  # Noter qu'il a pu être défini à l'instanciation.
  def folder
    @folder ||= begin
      self.paths                    || raise
      self.paths.first              || raise
      File.exist?(self.paths.first) || raise
      File.expand_path(File.dirname(self.paths.first))
    rescue Exception
      rt('textanalyzer.errors.folder_uncalcable')
    end
  end

  # Le dossier caché de l'analyse, pour mettre tous les fichiers utiles et
  # produits.
  # Pour le trouver, on utilise le premier path de texte à traiter. C'est
  # par exemple le projet Scrivener.
  # Note : on construit le dossier s'il n'existe pas (et toute sa hiérarchie).
  def hidden_folder
    @hidden_folder ||= begin
      d = File.join(folder, '.textanalyzer')
      `mkdir -p "#{d}"`
      d
    end
  end

end #/Analyse
end #/TextAnalyzer
