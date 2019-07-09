class Scrivener
class << self

  # = main =
  #
  # On exécute la commande
  # dans le contexte du dossier où on se trouve, c'est-à-dire le dossier
  # du projet Scrivener.
  # ---------------------------------------------------------------------
  def run
    # # Pour faire des tests sans lancer l'application
    # puts '-- CLI.params: %s' % CLI.params.inspect
    # return
    Dir.chdir(command_on_project?(self.command) ? project.folder : File.expand_path('.')) do
      require fpath('lib','commands',command)
    end
    # Space between end script and invite
    puts String::RC * 3

  rescue Exception => e
    raise_by_mode(e, Scrivener.mode)
  end

  # Initialisation de l'application (avant le run)
  # Principalement, l'initialisation consiste à :
  #   - analyser la ligne de commande
  #   - déterminer et analyser le projet pour savoir si l'on peut
  #     faire quelque chose avec.
  def init
    Debug.init
    CLI.analyse_command_line || (return false) # 'todo', 'test', etc
    begin
      self.command = CLI.command || 'help'
      command_exist?(self.command) || rt('commands.errors.unknown_command', {command_name: self.command})
      self.project_path = Project.get_project_path_from_command
      test_project_if_command_on_project
      save_current_informations
      return true
    rescue Exception => e
      raise_by_mode(e, Scrivener.mode)
    end
  end



  # Return le mode actuel
  # Pour savoir si on est en mode développement, test ou production.
  def mode
    if CLI.mode_test?
      :test
    elsif defined?(MODE_DEVELOPPEMENT) && MODE_DEVELOPPEMENT
      :development
    else
      :production
    end
  end

  # L'éditeur à utiliser pour éditer un texte. Soit c'est l'éditeur par
  # défaut, soit c'est l'éditeur précisé avec l'option --option="<éditeur>"
  def editor
    @editor ||= CLI.options[:open] === true ? ENV['SCRIV_EDITOR'] : CLI.options[:open]
  end

end #/<< self
end #/Scrivener
