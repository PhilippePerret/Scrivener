# encoding: UTF-8
=begin

  Commande/module permettant d'afficher la proximité des mots.


=end
if CLI.options[:help]
  aide = <<-EOT
#{' Aide à la commande `watch-proximites` (ou `watch-prox`) '.underlined.gras}

Usage :    #{'scriv watch-prox[imites][ vers/mon/projet.scriv][ <options>]'.jaune}

#{'Description'.underlined}

    Permet de suivre en direct les corrections des proximités dans
    le texte d'un projet Scrivener.

    Concrètement : on ouvre un projet Scrivener pour corriger les
    proximités de mots (par exemple en s'appuyant sur le document
    'proximités' produit par `scriv prox --in-file`).
    On lance cette commande sur le projet.
    On corrige les proximités dans le projet.
    Chaque fois qu'on enregistre le projet, la commande regarde les
    proximités corrigée ou ajoutées et les signale.


#{'Utilisation'.underlined}

    Quand on se trouve dans le dossier contenant le projet Scrivener,
    on n'a pas besoin de préciser son path (sauf s'il y a plusieurs
    projets Scrivener). On peut donc utiliser simplement :

        `scriv watch-prox`

    Il est vivement conseillé, sur les longs texte, d'utiliser l'option
    `-doc/--document="<titre>"` pour concentrer la correction sur ce
    document. Dans le cas contraire, c'est tout le texte qui serait
    contrôlé, ce qui consomme beaucoup d'énergie.

    Donc, le plus simple :

      * ouvrir le Terminal (/Applications/Utilitaires/),
      * taper `cd path/to/projet` pour rejoindre le dossier du projet
        Scrivener,
      * taper `scriv watch-prox -doc="Mon document à corriger"` pour
        lancer le surveillant,
      * disposer les fenêtres — ou les écrans — pour pouvoir voir le
        texte et les résultats de la commande,
      * corriger le texte en surveillant les modifications.

#{'Options'.underlined}

    -doc/--document="<titre du document">
          Permet de ne surveiller que les proximités dans le document
          précisément.


    DÉVELOPPEMENT
    -------------

  EOT

  Scrivener::help(aide)
  exit 0
end

Scrivener.require_module('proximites-watcher')
project.exec_watch_proximites
