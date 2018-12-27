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

  # Retourne true si la commande est une vraie commande, c'est-à-dire autre
  # chose que l'aide ou la liste des commandes demandées
  # En d'autres termes, une command sur projet a besoin d'un projet
  def command_on_project?(commande)
    @is_command_on_project ||= begin
      !(NOT_ON_PROJECT_COMMANDS.include?(commande) || CLI.options[:help])
    end
  end

  # Retourne true si la commande +commande+ existe.
  def command_exist?(commande)
    File.exist?(File.join(APPFOLDER,'lib','commands',"#{commande}.rb"))
  end
end #/<< self
end #/Scriver
