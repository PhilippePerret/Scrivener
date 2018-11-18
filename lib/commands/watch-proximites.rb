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
    On lance cette commande `watch-prox` sur le projet.
    On corrige les proximités dans le projet.
    Chaque fois que le projet est enregistré (de façon volontaire ou
    par sauvegarde automatique), la commande fait l'état des proximi-
    tés et signale celles qui ont été corrigées ou ajoutées.

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

#{'Affichage du suivi'.underlined}

    La fenêtre de résultat (Terminal) peut être placée en bas de l'écran,
    pour pouvoir être visible tout en travaillant son texte.

    Elle affiche une première ligne :
      * le titre du document surveillé,
      * le nombre de proximités provoquées par ce document,

    Sur la ligne suivante se trouve la liste de tous les mots canoniques
    en trop grande proximité avec, entre parenthèses, la distance en
    signes entre les mots (et donc, implicitement, le nombre de proximités
    sur le même mot).


    DÉVELOPPEMENT
    -------------

  EOT

  Scrivener::help(aide)
  exit 0
end

Scrivener.require_module('proximites-watcher')
project.exec_watch_proximites
