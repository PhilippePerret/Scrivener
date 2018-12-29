class Scrivener
class Project
class << self

  # Vérifie que le path +path+ définit bien un projet scrivener valide
  # Dans le cas contraire, raise une erreur
  # Cette méthode est appelée à l'initialisation de la commande.
  def must_exist ppath
    ppath || raise(ERRORS[:project_path_required] % [Dir.home])
    File.extname(ppath) == '.scriv'  || raise(ERRORS[:bad_project_extension] % File.extname(ppath))
    File.exist?(ppath) || raise(ERRORS[:unfound_project] % ppath)
  end

  # Définit la path du projet courant en fonction de la commande
  # et/ou des dernières données enregistrées
  def define_project_path_from_command
    index_param = Scrivener::TWO_PARAMS_COMMANDS.include?(CLI.command) ? 2 : 1
    path_param = CLI.params[index_param]
    if (path_param||'').end_with?('.scriv')
      path_param
    elsif path_param && File.directory?(path_param)
      dossier = path_param
      dossier = dossier[0...-1] if dossier.end_with?('/')
      Dir['%s/*.scriv' % dossier].first
    else
      Dir['./*.scriv'].first || Scrivener.last_project_data[:path]
    end
  end

end #/<< self
end #/Project
end #/Scrivener
