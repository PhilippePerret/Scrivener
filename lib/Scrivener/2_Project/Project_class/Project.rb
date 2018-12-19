class Scrivener
class Project
  class << self

    # Vérifie que le path +path+ définit bien un projet scrivener valide
    # Dans le cas contraire, raise une erreur
    # Cette méthode est appelée à l'initialisation de la commande.
    def must_exist ppath
      ppath || raise(ERRORS_MSGS[:project_path_required] % [Dir.home])
      File.extname(ppath) == '.scriv'  || raise(ERRORS_MSGS[:bad_project_extension] % File.extname(ppath))
      File.exist?(ppath) || raise(ERRORS_MSGS[:unfound_project] % ppath)
    end

    # Définit la path du projet courant en fonction de la commande
    # et/ou des dernières données enregistrées
    def define_project_path_from_command
      param1 = CLI.params[1]
      if (param1||'').end_with?('.scriv')
        param1
      elsif param1 && File.directory?(param1)
        dossier = param1
        dossier = dossier[0...-1] if dossier.end_with?('/')
        Dir['%s/*.scriv' % dossier].first
      else
        Dir['./*.scriv'].first || Scrivener.last_project_data[:path]
      end
    end

  end #/<< self
end #/Project
end #/Scrivener
