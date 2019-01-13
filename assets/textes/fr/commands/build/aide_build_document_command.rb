# encoding: UTF-8
module BuildDocumentCommandHelp
AIDE = <<-SOUSAIDE
    AIDE PROPRE À LA COMMANDE `scriv build documents`
    =================================================


    Aperçu de la commande
    ---------------------

    #{'scriv build documents --from=fichier.csv --depth=3 '.jaune}

    Construit les dossiers et documents à partir d'un fichier csv défi-
    ni avec l'option `--from` (ou `--depuis`).
    Si `--from` (ou `--depuis`) n'est pas défini, il est impératif que
    le fichier s'appelle `tdm.csv` et qu'il se trouve à la racine du
    projet.

    Options
    -------

    Les options permettent de définir comment le fichier devra être
    compris et donc traité.

    --from=NAME     Le chemin d'accès au fichier contenant les données.
    (--depuis)      NAME doit être absolu ou relatif au fichier du
                    projet.
                    Par exemple : --from="mon/fichier.csv"
                    Par défaut  : "tdm.csv"

    --delimitor=CHAR      permet de définir le délimiteur entre chaque
                    cellule, dans une rangée. Veiller à ce que ce déli-
                    miteur ne soit pas utilisé dans les textes.
                    CHAR doit être un ou plusieurs caractères.
                    Par exemple :  --delimitor=";;;"
                    Par défaut  :  ";"

    --depth=DEPTH   Définit la profondeur des dossiers/documents.
    (profondeur)    Les DEPTH premières colonnes du fichier CSV doivent
                    contenir les noms des dossiers et fichiers. Cf. les
                    exemple plus bas.
                    Par exemple : --depth=3
                    Par défaut  : 1

    --no-heading    Indique qu'il n'y a pas de rangée (ligne) définis-
                    sant le label des colonnes. Cette utilisation est
                    déconseillée, car elle ne permet pas d'utiliser des
                    métadonnées avec assurance.
                    Par défaut   : false

    --target_unit=UNIT     Permet de définir l'utité des objectifs,
                    quand une colonne 'Cible', 'Objectif' ou 'Target'
                    est utilisée avec seulement des nombres. La valeur
                    de UNIT peut être 'm' ou 'w' pour 'mots', 'p' pour
                    'pages' ou 's' ou 'c' pour 'signes.'
                    Par exemple  : --target_unit="m" (mots)
                    Par défaut   : "p" (page)

  #{'Aperçu d’un fichier CSV pour la création de documents'.underlined('-', '  ')}

    # On peut préciser en commentaire ce que contient le fichier, quand
    # il a été exécuté, etc.
    dossier[TAB]sous-dossier[TAB]document[TAB]cible[TAB]
    # Un commentaire possible, après un dièse. La ligne vide ci-dessous
    # ne sera pas prise en compte.

    # La "depth" (profondeur) de mon fichier est de 3, c'est-à-dire
    # que j'utilise une imbrication dossier > sous-dossier > document
    # pour ranger mes éléments.
    # Par exemple :
    #   > Dossier "Exposition"
    #      > Dossier "Préambule" (dans dossier "Exposition")
    #          Document "Introduction de l'histoire" (dans "Préambule")
    #          Document "Deuxième document" (dans "Préambule")
    Exposition[TAB][TAB][TAB][TAB]
    [TAB]     Préambule [TAB][TAB][TAB]
    [TAB]     [TAB]     Introduction de l'histoire en 4 pages[TAB]4p[TAB]
    [TAB]     [TAB]     Deuxième document de 100 mots [TAB]100m[TAB]
    [TAB]     Inc.Pert. [TAB][TAB][TAB]
    [TAB]     [TAB]     Incident pertubateur    [TAB] 1p  [TAB]
    [TAB]     [TAB]     Incident déclencheur    [TAB] 4p  [TAB]

    Développement[TAB][TAB][TAB][TAB]
    [TAB]     Première action[TAB][TAB][TAB]
    [TAB]     [TAB]     La toute première action [TAB]10000s[TAB]
    #/ fin du document

    À noter
    -------
    * La première ligne définit les entêtes. Si elle n'est pas donnée
      il convient d'ajouter l'option `--no-heading`
    * on peut laisser des lignes vides. Elles ne seront pas traitées,
    * les lignes de commentaires doivent commencer par un dièse,
    * chaque ligne contient le même nombre de délimiteurs, même si
      seule la première cellule est définie. Dans le cas contraire, une
      erreur sera générée.
    * l'imbrication ici est de trois niveaux, il faudra donc ajouter
      l'option `--depth=3` (ou `--profondeur=3`) à la commande.
      Note : si la profonceur est de 1 (profondeur par défaut), la pre-
      mière colonne doit impérativement comprendre le titre du document
      à créer,
    * les objectifs (cible) peuvent être définis en pages (avec "p"),
      en mot (avec "m") ou en nombre de signes (avec "s"),
    * la commande a deux moyens de savoir qu'une colonne particulière
      définit les objectifs : soit elle porte le titre 'cible' (ou
      'target', 'objectif'), soit elle est composée uniquement de va-
      leurs nulles ou pouvant être des objectifs (vide compris).

SOUSAIDE
end#/module
