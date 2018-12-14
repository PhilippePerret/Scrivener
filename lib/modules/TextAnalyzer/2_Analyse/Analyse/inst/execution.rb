# encoding: UTF-8
class TextAnalyzer
class Analyse

  # = main =
  #
  # Exécute l'analyse.
  #
  # La méthode rassemble tous les textes en un seul texte puis l'analyse.
  #
  def exec
    CLI.debug_entry
    (paths.nil? || paths.empty?) && raise(ERRORS[:no_files_to_analyze])
    init_analyse
    assemble_texts_of_paths
    texte_entier.proceed_analyse
    table_resultats.calcule_proximites
  end

  # = main =
  # Analyse des paths transmises
  #
  def assemble_texts_of_paths
    CLI.debug_entry
    self.files = Hash.new
    paths.each_with_index do |path, path_index|
      afile = TextAnalyzer::AnalyzedFile.new(path, self)
      afile.index   = path_index
      afile.id      = path_index + 1
      afile.offset  = self.texte_entier.length
      self.files.merge!(afile.id => afile)
      self.texte_entier << afile.texte + String::RC * 2
    end
  end
  # /assemble_texts_of_paths


end #/Analyse
end #/TextAnalyzer
