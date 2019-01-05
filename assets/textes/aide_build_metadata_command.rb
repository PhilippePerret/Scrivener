module BuildMetadataCommandHelp
AIDE = <<-SOUSAIDE

    AIDE PROPRE À LA COMMANDE `scriv build metadata`
    ================================================

    On peut construire des métadonnées de 3 façons avec la commande
    `build metadata` (au pluriel ou singulier) :

        1. en définissant la métadonnée en ligne de commande,
        2. en définissant la métadonnée de façon interactive,
        2. en définissant la ou les métadonnées dans un fichier YAML.

    Les deux premières méthode sont à privilégier si on ne doit créer
    qu'une seule métadonnée. La deuxième est parfaite pour ne pas ou-
    blier de paramètres. La troisième méthode est à privilégier lors-
    que l'on doit créer plusieurs métadonnées ou que ces métadonnées
    peuvent être partagées par plusieurs projets.

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
