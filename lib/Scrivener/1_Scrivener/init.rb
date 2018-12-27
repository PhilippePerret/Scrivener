=begin

  Module de démarrage de la commance `scriv`
=end
class Scrivener

  # Liste des commandes qui ne s'appliquent pas à un projet et qui, donc,
  # n'entrainent pas le contrôle de la validité du projet scrivener
  NOT_ON_PROJECT_COMMANDS = [
    'help'      , # => affichage de l'aide
    'last'      , # => Pour voir les derniers projets et en choisir un
    'commands'  , # => affichage de la liste des commandes
    'lemma'     , # => Définition des abbréviations
                  #  Peut quand même nécessiter parfois un projet
    'run'       , # Pour jouer du code
    'test'      , # pour lancer les tests
  ]

  class << self

    # Initialisation de l'application
    def init
      Debug.init
      CLI.analyse_command_line || (return false)# pour 'todo'
      self.command = CLI.command || 'help'
      command_exist?(self.command) || raise(ERRORS_MSGS[:unknown_command] % self.command)
      self.project_path = Project.define_project_path_from_command
      test_project_if_command_on_project
      save_current_informations
      return true
    rescue Exception => e
      raise_by_mode(e, Scrivener.mode)
    end

  end #/<< self
end #/Scriver
