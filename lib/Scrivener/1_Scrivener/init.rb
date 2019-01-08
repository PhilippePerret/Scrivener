=begin

  Module de démarrage de la commance `scriv`
=end
class Scrivener

  # Liste des commandes qui ne s'appliquent pas à un projet et qui, donc,
  # n'entrainent pas le contrôle de la validité du projet scrivener
  NOT_ON_PROJECT_COMMANDS = {
    'check'       => {hname: 'Vérification de l’application'},
    'help'        => {hname: 'Aide'},
    'last'        => {hname: 'Derniers projets utilisés'},
    'commands'    => {hname: 'Liste des commandes'},
    'lemma'       => {hname: 'Données de lemmatisation'},
    'run'         => {hname: 'Jouer du code ruby'},
    'test'        => {hname: 'Lancer les tests'},
    'set'         => {hname: 'Pour définir des données de l’application ou du projet',
                      only_if: {params: [:lang]}
                    }
  }

  # Liste des commandes qui fonctionnent toujours avec deux paramètres, c'est-
  # à-dire elle-même et un autre paramètre. Comme la commande 'build' qui
  # utilise toujours en deuxième paramètre le paramètre de la chose à construire.
  # Dans le cas de ces commandes, on cherche le path en CLI.params[2]
  TWO_PARAMS_COMMANDS = ['build', 'set']

  class << self

    # Initialisation de l'application
    def init
      Debug.init
      CLI.analyse_command_line || (return false)# pour 'todo'
      begin
        self.command = CLI.command || 'help'
        command_exist?(self.command) || raise(ERRORS[:unknown_command] % self.command)
        self.project_path = Project.define_project_path_from_command
        test_project_if_command_on_project
        save_current_informations
        return true
      rescue Exception => e
        raise_by_mode(e, Scrivener.mode)
      end
    end

  end #/<< self
end #/Scriver
