=begin

  Fichier définissant les constants utiles.

=end
class Scrivener

  # ---------------------------------------------------------------------
  # Liste des commandes qui ne s'appliquent pas à un projet et qui, donc,
  # n'entrainent pas le contrôle de la validité du projet scrivener
  #
  # Note : seulement pour le programme (les :hname ne servent qu'à
  # expliquer les choses ici)
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

  # ---------------------------------------------------------------------
  # Liste des commandes qui fonctionnent toujours avec deux paramètres, c'est-
  # à-dire elle-même et un autre paramètre. Comme la commande 'build' qui
  # utilise toujours en deuxième paramètre le paramètre de la chose à construire.
  # Dans le cas de ces commandes, on cherche le path en CLI.params[2]
  TWO_PARAMS_COMMANDS = ['build', 'set']

end
