class Scrivener
class Project
class << self

  # Vérifie que le path +path+ définit bien un projet scrivener valide
  # Dans le cas contraire, raise une erreur
  # Cette méthode est appelée à l'initialisation de la commande.
  def must_exist ppath
    ppath || rt('projects.errors.project_path_required', {home: Dir.home})
    File.extname(ppath) == '.scriv'  || rt('projects.errors.bad_project_extension')
    File.exist?(ppath) || rt('projects.errors.unfound_project', {project_path: ppath})
  end

  # Définit la path du projet courant en fonction de la commande
  # et/ou des dernières données enregistrées
  def define_project_path_from_command
    CLI.debug_entry
    # On cherche, dans les paramètres, le premier argument qui peut être
    # le path du projet.
    CLI.params.each do |k, prm|
      prm.is_a?(String) || next
      pth = is_a_project_path?(prm)
      pth.nil? || (return pth)
    end
    # En dernier recours, on prend le dernier projet utilisé par
    # la commande.
    Scrivener.last_project_data[:path]
  end

  # Retourne true si +pth+ peut être un path de projet scrivener.
  # +pth+ peut être le path explicite du projet, ou le nom dans le
  # dossier courant, ou le dossier contenant le projet, etc.
  def is_a_project_path? pth
    # Si pth est le fichier lui-même, avec ou sans extension
    full_path = File.expand_path(File.join('.', pth.with_extension('scriv')))
    return full_path if File.exist?(full_path)
    # Si pth est un dossier contenant un fichier .scriv
    dossier = String.new(pth)
    dossier = dossier[0...-1] if dossier.end_with?(File::Separator)
    dossier = File.expand_path('.',dossier)
    return first_scriv_file_in(dossier) if File.directory?(dossier)
  end

  # Retourne le premier fichier .scriv se trouvant dans le dossier +dossier+
  def first_scriv_file_in dossier
    Dir['%s/*.scriv' % dossier].first
  end

end #/<< self
end #/Project
end #/Scrivener
