# encoding: UTF-8
=begin

  Commande/module permettant d'afficher la proximité des mots.


=end
if CLI.options[:help]
  aide = <<-EOT
#{' Aide à la commande `proximites` (ou `prox`) '.underlined.gras}

Usage :    #{'scriv prox[imites][ vers/mon/projet.scriv][ <parametres>][ <options>]'.jaune}

#{'Description'.underlined}

    Permet d'afficher la proximités des mots identiques et de four-
    nir un rapport détaillé de ces proximités.

    Plusieurs modes d'utilisation sont possibles :

      * Les proximités sont affichées les unes à la suite des autres
        dans le Terminal. C'est le mode par défaut.

      * Un fichier est créé dans le projet Scrivener, présentant toutes
        les proximités en colorisant les mots.
        Ajouter l'option `--in-file` pour créer ce fichier.

      * Un mot est donné, dans un document (ou non) et la commande
        affiche ses proximités dans le texte.
        Ajouter le paramètre `mot=LeMotAVoir` à la commande pour passer
        dans ce mode. Par exemple, si un projet a déjà été analysé,
        on peut faire directement :

          #{'scriv prox mot="peut-être"'.jaune}

        … qui va afficher les proximités du mot "peut-être".

      * Un titre de document est donné, le programme affiche seulement
        les proximités de ce document, en les indiquant en couleur.

          #{'scriv prox doc="Titre du document dans Scrivener"'.jaune}

        Note : la commande ci-dessus ne peut fonctionner que si le
        projet a été précédemment utilisé (car la commande `scriv`
        utilise toujours par défaut le dernier projet utilisé).

      * Un indice de document est donné, le programme affiche seulement
        les proximités de ce document, comme ci-dessu.

          #{'scriv prox[ path/to/proj.scriv] idoc=3'.jaune}

        La commande ci-dessus affiche les proximités du 3ème document.

#{'Utilisation'.underlined}

    Quand on se trouve dans le dossier contenant le projet Scrivener,
    on n'a pas besoin de préciser son path (sauf s'il y a plusieurs
    projets Scrivener). On peut donc utiliser simplement :

        #{'scriv prox'.jaune}

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

        #{'scriv prox -f --in-file'.jaune}

    Cela produit un nouveau fichier (dans le dossier « Proximités » du
    projet), portant la date et l'heure courante, avec les proximités
    restantes.

    Noter qu'une fois qu'on a utilisé la commande `scriv` sur un
    projet, c'est ce projet qui sera utilisé par défaut. Sauf si
    le projet est défini autrement et, notamment, qu'on se trouve
    dans un dossier contenant un projet .scriv.
    Note : c’est toujours en dernier recours que le dernier projet
    est utilisé.

    AFFICHAGE DES RÉSULTATS SEULEMENT
    ---------------------------------

    Avec l'option `--data`, on n'affiche seulement le résultat des
    proximités. C'est un tableau affichant toutes les informations
    qu'on peut tirer sur les proximités, à commencer par leur
    nombre dans le texte.
    Si le path du projet n'est pas fourni, c'est le dernier qui est
    utilisé.

        #{'scriv prox -f --data'.jaune}
        # => force le calcul est affiche les données

    AFFICHAGE DES PROXIMITÉS D'UN DOCUMENT
    --------------------------------------

        #{'scriv prox[ path/to/proj.scriv] doc="Titre du document"'.jaune}

    Cette commande ne va afficher que les proximités du document de
    titre donné. En mettant chaque proximité en couleur.
    Si le path du projet n'est pas fourni, c'est le dernier qui est utilisé.

        #{'scriv prox[ path/to/proj.scriv] idoc=3'.jaune}

    Affiche en console les proximités du 3ème document en les mettant
    en couleur.
    Si le path du projet n'est pas fourni, c'est le dernier qui est utilisé.

    AFFICHAGE DES PROXIMITÉS D'UN MOT
    ---------------------------------

        #{'scriv prox[ path/to/proj.scriv] mot="LeMotCherché"[ doc="Titre document"]'.jaune}

    Cette commande n'affiche que les proximités du mot spécifié dans
    le document spécifié.
    Si le document n'est pas spécifié, il est demandé à l'utilisateur.

    TRAITEMENT PROPRE DE MOTS
    -------------------------

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

else
  Scrivener.require_module('proximites')
  project.exec_proximites
end
