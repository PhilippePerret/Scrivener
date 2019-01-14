# encoding: UTF-8
class TextAnalyzer
class Analyse


  def yaml_data_file
    @yaml_data_file ||= File.join(hidden_folder,'data.yaml')
  end

  def yaml_analyse_file
    @yaml_analyse_file ||= File.join(hidden_folder,'analyse.yaml')
  end


  def data_path
    @data_path ||= File.join(hidden_folder, 'analyse.msh')
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
