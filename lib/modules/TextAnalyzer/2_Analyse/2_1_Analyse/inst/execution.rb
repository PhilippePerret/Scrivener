# encoding: UTF-8
class TextAnalyzer
class Analyse

  # = main =
  #
  # Exécute l'analyse.
  #
  # La méthode rassemble tous les textes en un seul texte puis l'analyse.
  # Puis elle enregistre les résultats dans un fichier caché.
  #
  # Noter qu'il vaut mieux utiliser la méthode `reload` si tous les calculs
  # n'ont pas besoin d'être refaits
  #
  # +paths+ Liste des chemins d'accès aux fichiers à traiter. Elles peuvent
  #         être définies ici ou à l'instanciation de l'analyse.
  #
  def exec given_paths = nil
    CLI.debug_entry
    given_paths && self.paths = given_paths
    data_valid? || raise(ERRORS[:no_files_to_analyze])
    init_analyse
    assemble_texts_of_paths
    texte_entier.proceed_analyse
    table_resultats.calcule_proximites
    save_all
  end

  def save
    Marshal.dump(self, File.open(data_path, 'wb'))
  end

  def save_all
    table_resultats.save
    texte_entier.save
    data.ended_at = Time.now
    data.save
    self.save
  end
  # /save_all

  def data_path
    @data_path ||= File.join(hidden_folder, 'analyse.msh')
  end
  # = main =
  #
  # Analyse des paths transmises
  #
  def assemble_texts_of_paths
    CLI.debug_entry
    self.files = Hash.new
    nombre_traited = 0
    paths_count = paths.count
    paths.each_with_index do |path, path_index|
      CLI.dbg('  * Traitement du fichier %s' % path)
      afile = TextAnalyzer::AnalyzedFile.new(path, self)
      afile.index   = path_index
      afile.id      = path_index + 1
      afile.offset  = self.texte_entier.length
      self.files.merge!(afile.id => afile)
      self.texte_entier << afile.texte + String::RC * 2
      nombre_traited += 1
      CLI.dbg('    OK')
    end
    CLI.dbg('  Nombre de fichier à traiter : %i' % paths_count)
    CLI.dbg('  Nombre fichiers traités : %i' % nombre_traited)
    CLI.dbg('  Longueur du texte entier : %i' % self.texte_entier.length)
    paths_count == nombre_traited || raise(ERRORS[:nb_doc2treate_unmatch] % [paths_count, nombre_traited])
    CLI.debug_exit
  end
  # /assemble_texts_of_paths

end #/Analyse
end #/TextAnalyzer
