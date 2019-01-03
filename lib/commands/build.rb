# encoding: UTF-8
=begin
  Command 'build' pour voir les infos générales du projet courant

  C'est l'aide générale du site
=end

if CLI.options[:help]
  aide = <<-EOT
  #{'AIDE DE LA COMMANDE `scriv build`  '.underlined('-','  ').gras}

  Note préliminaire
  -----------------

  La commande `update` correspond à `scriv build --update`. Elle per-
  met d'actualiser des données construites avec `scriv build`.
  Avec l'option `-i/--interactive`, on peut confirmer chaque modifi-
  cation. Dans le cas contraire, toutes les modifications sont
  opérées sans demande.

  #{'Description'.underlined('-', '  ')}

  La commande `scriv build` permet de construire des éléments
  dans le projet scrivener courant. Cette commande ne peut pas
  s'appeler seule. Il lui faut obligatoirement un premier para-
  mètre en argument pour indiquer ce qui doit être construit :

  `documents`   Construit la hiérarchie des documents à partir
                d'un fichier CSV (fichier tableur). Peut définir
                toutes les données telles que les objectifs à at-
                teindre ou autres métadonnées.

  EOT
  Scrivener.help(aide)
  # On peut ajouter une aide si l'objet à construire est déjà
  # déterminé (par exemple `scriv build metadata -h`)
case CLI.params[1]
when 'documents'
Scrivener.help(<<-SOUSAIDE)

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
when 'metadatas'
Scrivener.help(<<-SOUSAIDE)

  AIDE PROPRE À LA COMMANDE `scriv build metadata`
  ================================================

  On peut construire des métadonnées de deux façons avec la commande
  `build metadata` (au pluriel ou singulier) :

      1. en définissant la métadonnée en ligne de commande,
      2. en définissant la ou les métadonnées dans un fichier YAML.

  La première méthode est à privilégier si on ne doit créer qu'une
  seule métadonnée, la seconde est à privilégier lorsque l'on doit
  créer plusieurs métadonnées ou que ces métadonnées peuvent être
  utilisées d'un projet à l'autre.

  #{'Créer la métadonnée en ligne de commande'.underlined('-', '  ')}

  On peut créer la métadonnée tout simplement en tapant `scriv build
  metadata` et en répondant aux questions posées. La métadonnée est
  créée de façon interactive.

  On peut également définir tous les paramètres dans la commande. Par
  exemple :

    #{'scriv build metadata --type=Text --name="Ma donnée"
          --align=Rigth --wraps=No'.jaune}

  Chaque type de métadonnée ayant ses propres paramètres, il convient
  de définir les bonnes données pour chaque paramètre. On trouvera
  bas la liste de ces types et de ces paramètres.

  Enfin, on peut utiliser un mix des deux : quelques paramètres défi-
  nis dans la commande et la commande demande de définir les autres
  de façon interactive.

  #{'Créer les métadonnées à l’aide d’un fichier YAML'.underlined('-', '  ')}

  Cette méthode est particulièrement pratique lorsque l'on doit uti-
  liser les mêmes métadonnées dans plusieurs projets. Au lieu d'avoir
  à les recréer chaque fois, il suffit d'injecter le fichier pour les
  définir grâce à la commande :

    #{'scriv build metadatas --from=mon/fichier.yaml'.jaune}

  #{'Aperçu du fichier YAML'.underlined('-', '  ')}

  Ce fichier YAML doit lui aussi contenir toutes les données en fonc-
  tion du type de la donnée. Voici un fichier qui contient tous les
  types et tous les paramètres de chaque type.

  Note : les messages après les "#" sont des commentaires qui ne sont
  pas pris en compte dans le fichier

  #{'# === Métadonnée de type Texte ===

  identifiant_donnée:       # Sert seulement pour le fichier
                            # Noter qu’il n’y a pas d’espace avant
                            # les ":"
    name:  "Nom de la métadonnée"
    type:  Text
    align:  Left    # (aligné à gauche) ou Right (droite)     [optionnel]
    wraps:  No      # (Texte en rougé) ou No (pas enroulé)    [optionnel]

  # === Métadonnée de type Liste ===

  donnée_liste:     # Identifiant
    name:     "Ma liste personnalisée"
    type:     List
    default:  None  # ou item sélectionné   [optionnel]
    options:
      - Premier item
      - Deuxième item
      - Troisième item
      - Nième item

  # === Métadonnée de type case à cocher ===

  macaseàcocher:
    name:     "Ma case à cochée"
    type:     Checkbox
    checked:  true # (cochée par défaut) ou false (décoché) [optionnel]

  # === Métadonnée de type date ===

  madatepersonnelle:
    name:     "Date personnalisée"
    type:     Date
    format:   Short # Voir ci-dessous les formats de date

  madateformatée:
    name:     "Date dans un format personnalisé"
    type:     date
    format:   EEE kk:mm'.bleu}

  #{'Formats de date'.underlined('-', '  ')}

      Short           03/01/2019
      Short+Time      03/01/2019 06:15
      Medium          3 janv. 2019
      Medium+TIme     3 janv. 2019 06:16
      Long            3 janvier 2019
      Long+Time       3 janvier 2019 06:16
      TimeOnly        06:17
      Custom          <format personnel, au format UNICODE>

  #{'Données par type'.underlined('-', '  ')}

    Text        Métadonnée de type texte. Par exemple pour définir
                l'auteur du document, si plusieurs auteurs.
        name    Le nom de la métadonnée, qui apparaitra dans l'ins-
                pecteur, par exemple.
        align   L'alignement dans l'inspecteur, à droite (Right) ou
                à gauche (Left)
        wraps   Si 'Yes' (défaut), le texte sera enroulé. Si 'No', il
                ne le sera pas.

    Checkbox    Une case à cocher.
        name    Son nom, le texte qui apparaitra dans l'inspecteur à
                côté de la case à cocher proprement dite.
        checked   Si true/Yes, elle sera cochée par défaut. Si false/
                No, elle ne le sera pas.

    List        Une liste de choix.
        name    Nom de la métadonnée.
        options Les items de la liste. Il peuvent être définis en les
                séparant par des ";": "Item 1;Item 2;...;Item N".
        default L'item sélectionné par défaut. Par exemple "Item 4"

    Date        Une date.
        name    Nom de la métadonnée.
        format  Le format à utiliser (cf. ci-dessus). Pour un format
                tout à fait personnalisé, on peut voir l'adresse :
                [Unicode Date Format Pattern](http://www.unicode.org/reports/tr35/tr35-dates.html#Date_Format_Patterns)

SOUSAIDE
  end

else
  class Scrivener
ERRORS.merge!(
  build_thing_required: 'Il faut définir la chose à construire en deuxième argument. P.e. `scriv build documents ...`',
  build_invalid_thing:  '"%s" est une chose à construire invalide (choisir parmi %s).'
)
  class Project
    THINGS = {
    documents:  {hname: 'documents'},
    tdm:        {hname: 'table des matières'},
    metadatas:  {hname: 'metadatas'}
    }
  class << self
    def exec_build_thing thing
      # Cette "thing" est-elle valide
      thing || raise_thing_required
      thing = thing.strip.downcase.to_sym
      is_thing?(thing)  || raise_invalid_thing

      # On peut lancer l'opération
      Scrivener.require_module('Scrivener')
      Scrivener.require_module('build/%s' % thing)
      Scrivener::Project.exec_build
    end
    # Return true si +thing+ est une chose constructible
    def is_thing?(thing)
      THINGS.key?(thing)
    end
    def raise_thing_required
      raise(ERRORS[:build_thing_required])
    end
    def raise_invalid_thing(thing)
      raise(ERRORS[:build_invalid_thing] % thing)
    end

  end #/<< self
  end #/Project
  end #/Scrivener
  Scrivener::Project.exec_build_thing(CLI.params[1])
end
