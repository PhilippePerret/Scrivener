class Scrivener
class Project

  # Analyse du projet
  #
  # Soit elle est rechargée, soit elle est (re)produite
  #
  # +paths+ est un Array des fichiers de texte de chaque
  # binder-item, simplifié (sans style, etc.)
  def analyse paths = nil
    @analyse ||= begin
      TextAnalyzer::Analyse.new(folder: folder, paths: paths, title: title)
    end
  end

end #/Project
end #/Scrivener
