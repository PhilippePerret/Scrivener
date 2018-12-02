=begin

  Module de démarrage de la commance `scriv`
=end
class Scrivener

  # Liste des commandes qui ne s'appliquent pas à un projet et qui, donc,
  # n'entrainent pas le contrôle de la validité du projet scrivener
  NOT_ON_PROJECT_COMMANDS = [
    'help',             # => affichage de l'aide
    'commands',         # => affichage de la liste des commandes
    'lemma',            # => Définition des abbréviations
                        #  Peut quand même nécessiter parfois un projet
  ]

  class << self

    # Initialisation de l'application
    def init
      CLI.analyse_command_line || (return false)# pour 'todo'
      self.command = CLI.command || 'help'
      command_exist?(self.command) || raise("La commande `#{self.command}` est inconnue (utilisez la commande `commands' pour obtenir la liste de toutes les commandes).")
      self.project_path = Project.define_project_path_from_command
      test_project_if_command_on_project
      # On sauvegarde ces informations pour une utilisation ultérieure
      save_current_informations
      return true
    rescue Exception => e
      puts e.message.rouge_gras
    end

  end #/<< self
end #/Scriver
