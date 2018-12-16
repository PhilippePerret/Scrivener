# encoding: UTF-8
=begin
  Module pour les méthodes d'entrée/sortie des résultats, c'est-à-dire
  d'écriture et de lecture des données enregistrées.
=end
class TextAnalyzer
class Analyse
class TableResultats

  # Méthode qui retourne la table des résultats, soit prise dans le fichier
  # s'il existe, soit calculé
  def self.load(analyse)
    analyse.table_resultats.exist? || raise(ERRORS[:no_table_resultats])
    File.open(analyse.table_resultats.file_path,'rb') { |f| Marshal.load(f) }
  end

  # Méthode qui sauve la table de résultats dans son fichier
  def save
    self.created_at || self.created_at = Time.now
    self.updated_at = Time.now
    File.open(file_path,'wb') { |f| Marshal.dump(self, f) }
  end

  # Retourne true si le fichier des résultats enregistrés existe
  def exist?
    File.exist?(file_path)
  end

  # Chemin d'accès au fichier des résultats de l'analyse dans le
  # dossier caché
  def file_path
    @file_path ||= File.join(analyse.hidden_folder, 'table_resultats.msh')
  end
end #/TableResultats
end #/Analyse
end #/TextAnalyzer
