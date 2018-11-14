# encoding: UTF-8
=begin

  Commande/module permettant d'afficher la proximité des mots.


=end
if CLI.options[:help]
  aide = <<-EOT
#{' Aide à la commande `proximites` (ou `prox`) '.underlined.gras}

Usage :    #{'scriv prox[imites][ vers/mon/projet.scriv][ <options>]'.jaune}

#{'Description'.underlined}

    Permet d'afficher la proximités des mots identiques et de four-
    nir un rapport détaillé de ces proximités.


    Si on se trouve dans le dossier contenant le projet Scrivener,
    on n'a pas besoin de préciser son path (sauf s'il y a plusieurs
    projets Scrivener).

#{'Options'.underlined}

    -S    Produit un nouveau dossier avec tous les fichiers indiquant
          en couleur la proximité des mots.

    -f/--force
          Forcer le recalcul complet, relève des mots et calcul des
          proximités.
    -fc/--force_calcul
          Forcer le recalcul des proximités, sans relève des mots.

    --mot="<le mot>"
          Permet de ne checker que la proximité du mot fourni.

    -doc/--document="<titre du document">
          Permet de ne checker que les proximités dans le document
          fourni.

    --justify
          Pour justifier l'affichage des extraits à l'écran. Plus
          propre, mais pose un problème si on veut faire des copiés-
          collés pour rechercher le segment.

    --in_file
          Pour créer le fichier qui montrera les proximités au lieu
          de les afficher avec le terminal.

    DÉVELOPPEMENT
    -------------

    --only_calculs
          Pour ne faire qu'afficher les calculs (les listes) dans le
          terminal. Il faut alors préciser :
          --segments    Pour afficher la table des segments
          --proximites  Pour afficher la table des proximités
  EOT

  Scrivener::help(aide)
  exit 0
end

Scrivener.require_module('proximites')
project.exec_proximites
