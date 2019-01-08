=begin

  Module de démarrage de la commance `scriv`
=end
class Scrivener
class << self

  attr_accessor :command
  attr_accessor :project_path

  # ---------------------------------------------------------------------
  #   Méthodes accessoire

  def save_current_informations
    save_project_data(
      title:          project && project.title,
      last_command:   self.command,
      path:           project && self.project_path,
      options:        CLI.options,
      created_at:     Time.now
      )
  end

  # ---------------------------------------------------------------------
  #   Méthodes de check

  def test_project_if_command_on_project
    command_on_project?(self.command) || return
    Project.must_exist(self.project_path)
    # On peut écrire le path du projet
    puts 'Projet : %s' % project_path
  end

  # Retourne true si la commande est une commande qui s'applique
  # à un projet.
  # Une commande qui s'applique à un projet a toujours besoin d'un
  # projet.
  def command_on_project?(cmd = nil)
    @is_command_on_project ||= begin
      cmd ||= self.command
      !(help_wanted || cmd_without_project(cmd))
    end
    # # puts "=== @is_command_on_project: #{@is_command_on_project.inspect}"
    # @is_command_on_project
  end

  def help_wanted
    !!CLI.options[:help]
  end
  private :help_wanted
  def cmd_without_project(cmd)
    if NOT_ON_PROJECT_COMMANDS.key?(cmd)
      # Si cette commande est connue, il faut voir si elle n'est évitable
      # qu'avec certaines sous commandes (comme 'set lang' par exemple, qui
      # a besoin d'un projet pour la plupart de ses valeurs)
      if NOT_ON_PROJECT_COMMANDS[cmd].key?(:only_if)
        return subcmd_without_project(cmd)
      else
        true
      end
    else
      false
    end
  end
  private :cmd_without_project

  # Retourne true s'il n'y a pas de sous-commande qui définissent
  # une commande sans projet.
  def subcmd_without_project(cmd)
    dnoton = NOT_ON_PROJECT_COMMANDS[cmd]
    # Si la donnée n'a pas de :only_if, on peut s'arrêter là
    if dnoton[:only_if].key?(:params)
      dnoton[:only_if][:params].each do |param|
        if CLI.params.key?(param)
          return true
        end
      end
    end
    return false
  end
  #/subcmd_without_project
  private :subcmd_without_project

  # Retourne true si la commande +commande+ existe.
  def command_exist?(commande)
    File.exist?(File.join(APPFOLDER,'lib','commands',"#{commande}.rb"))
  end
end #/<< self
end #/Scriver
