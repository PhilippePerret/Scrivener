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

    Deux modes sont possibles :

      * Les proximités sont affichées les unes à la suite des autres
        dans le Terminal. C'est le mode par défaut.

      * Un fichier est créé dans le projet Scrivener, présentant toutes
        les proximités en colorisant les mots.
        Ajouter l'option `--in-file` pour créer ce fichier.

#{'Utilisation'.underlined}

    Quand on se trouve dans le dossier contenant le projet Scrivener,
    on n'a pas besoin de préciser son path (sauf s'il y a plusieurs
    projets Scrivener). On peut donc utiliser simplement :

        `scriv prox`

    Donc, le plus simple :

      * Ouvrir le Terminal (/Applications/Utilitaires/),
      * Taper `cd path/to/projet` pour rejoindre le dossier du projet
        Scrivener,
      * Taper `scriv prox` pour lancer l'analyse de la proximité,
      * ou `scriv prox --in-file` pour créer un fichier dans le projet.

    L'option `-f` permet de forcer la relève des mots, quand le texte
    du projet a été modifié.
    L'option `-fc` (sous-entendue quand `-f` est ajouté) permet de recal-
    culer les proximités.

    Donc, par exemple, lorsque l'on veut relancer un check après avoir
    corriger le texte au niveau des proximités, on peut faire :

        `scriv prox -f --in-file`

    Cela produit un nouveau fichier (dans le dossier « Proximités » du
    projet), portant la date et l'heure courante, avec les proximités
    restantes.

    AFFICHAGE DES RÉSULTATS SEULEMENT
    ---------------------------------

    Avec l'option `--data`, on n'affiche seulement le résultat des
    proximités. C'est un tableau affichant toutes les informations
    qu'on peut tirer sur les proximités, à commencer par leur
    nombre dans le texte.

        `scriv prox -f --data`
        # => force le calcul est affiche les données

    AJOUT DE MOTS
    -------------

    On peut, dans un fichier `proximites.txt` se trouvant au même
    niveau que le projet Scrivener, définir des listes propres de
    mots qui devont être traités différemment pour le projet consi-
    dérés.

    Ce fichier doit être constitué d'une liste de mots, les uns au-
    dessus des autres, avec des nombres définissant à partir de quel
    moment ils doivent être considérés en trop grande proximité.

    Pour commencer, on peut mettre sous le nombre `0` la liste des
    mots qui doivent être exclus, par exemple les noms des person-
    nages si leur fréquence importe peu. D'autres mots devront être
    considérés trop proches seulement si leur écartement est infé-
    rieur au nombre spécifié par le nombre qui précède.

    Note : les commentaires sont des lignes entières précédés de '# '
    Note 2 : la proximité « normale » est de 1500 signes.

      0
      François
      # François sera donc ignoré, tout comme Christine et
      # Guillaume.
      Christine
      Guillaume

      300
      route
      vélo
      # On supportera les mots « route » et « vélo » qui sont entre
      # 300 et plus caractères.
      # Noter que « route » concerne « routes » et « ROUTE » puis-
      # qu'il y a lemmatisation du texte.

    On peut définir ensuite que

#{'Options'.underlined}

    -f/--force
          Forcer le recalcul complet, relève des mots et calcul des
          proximités.
    -fc/--force_calcul/--force-calcul
          Forcer le recalcul des proximités, sans relève des mots.

    --in_file/--in-file
          Pour créer le fichier qui montrera les proximités au lieu
          de les afficher avec le terminal.

    --data
          Affichage seulement des données du dernier calcul de
          proximités.

    --strict
          Si true, quand l'option --in-file est choisie, les mots
          qui sont en proximité avec un mot avant et en même temps
          un mot après ne sont pas doublés pour afficher les deux
          couleurs différentes. Le mot est splité en deux, chaque
          moitié prenant la couleur du mot précédent et suivant.

    --mot="<le mot>" TODO
          Permet de ne checker que la proximité du mot fourni.
          Sortie en console uniquement.

    -doc/--document="<titre du document"> TODO
          Permet de ne checker que les proximités dans le document
          fourni.

    --justify
          Pour justifier l'affichage des extraits à l'écran. Plus
          propre, mais pose un problème si on veut faire des copiés-
          collés pour rechercher le segment.

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
if CLI.options[:data] || project.ask_for_fermeture
  project.exec_proximites
else
  puts "  Je renonce."
end
