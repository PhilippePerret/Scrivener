# encoding: UTF-8
module AideGeneraleCommandePagination
MANUEL = <<-EOT
#{'AIDE DE LA COMMANDE `pagination`'.gras}
================================

  Usage :    #{'scriv pagination[ vers/mon/projet.scriv][ <options>]'.jaune}
  Alias :    #{'scriv tdm'.jaune}

  Description
  -----------

    Permet de calculer la pagination du projet spécifié.

    Deux paginations différentes sont affichées :

    * La pagination s'appuyant sur la longueur de texte de chaque
      document. C'est la pagination normale d'une table des matières.
    * La pagination s'appuyant sur la définition des objectifs de
      chaque document. Cette pagination permet de construire les pro-
      portions du roman ou du texte en général.

    La table des matières peut être produite dans le terminal, dans
    un fichier HTML ou un fichier simple texte.


  Options
  -------

    -o/--output=[console|html|file]

        Définit la sortie de la table des matières produite. L'option
        `console` sort la table des matières en console. L'option
        `html` produit un fichier HTML et l'option `file` la sort
        dans un fichier texte simple.

    --open

          Si présent en option, et que le format (output) HTML ou
          FILE est choisi, le fichier est ouvert après sa création.

    -N    Par défaut, le nombre de caractères, de mots et de pages est
          indiqué au bout de chaque titre de fichier dans la table des
          matière produite. Avec cette option, ces nombres ne sont pas
          indiqués

          Exemple : #{'scriv pagination mon_projet.scriv -N'.jaune}

    -fdc/--final-draft-coefficient=<nombre>

          Indique à la commande que les objectifs définis sont des
          objectifs de premier jet (c'est-à-dire des nombres supé-
          rieurs aux nombres finaux).
          On peut indiquer à la place de <nombre> le coefficient uti-
          lisé. Par défaut, c'est 1.5.
          Noter qu’il faut mettre un point pour la virgule.

          Si ce coefficient est fourni, la pagination définitive sera
          ajoutée à la table des matières produite.

          Exemple : #{'scriv pagination mon_projet.scriv -fdc=1.2'.jaune}

  Explication des colonnes
  ------------------------

      Une table des matières produite par la commande `pagination` ou
      `tdm` se présente sous cette forme :

                             _ _ _ _ Numéro de la page en fonction du
                            |        texte écrit.
      ...                   v
      Titre du document.... 10 | 24        5010 4080 #{'*'.vert}#{'*'.rouge} #{'+590'.rouge} (**)
      ...                         ^
      ...                         | _ _ _ _ Numéro de la page en fonction
      ...                                   des objectifs définis.
      ...
      ... (avec l'option `-N`, seuls les deux numéros ci-dessus sont
      ...  affichés)
      ...
      ...    Nombre de signes écrits _ _ _ _      _ _ _ Nombre de signes à
      ...                                   |    |      écrire (objectif)
      ...                                   v    v
      Autre document....... 23 | 54        2457 2500 #{'*'.vert}#{'*'.vert} #{'-43'.vert}
      ...                                                ^
      ...              Différence (raisonnable) entre _ _|
      ...              nombre de signes et objectif
      ...
      Troisième document... 92 | 110        280 300  #{'*'.rouge}#{'*'.vert} #{'-240'.rouge}
      ...                                            ^^   ^
      ...        Indicateurs d'atteinte de           ||   |
      ...        cible et de dépassement (*) _ _ _ _ _    |_ _  Nombre
      ...                                                     de signes
      ...                                                     manquants

      (*) Indicateurs d'atteinte de cible et de dépassement
      -------------------------------------------------
        La première étoile indique si l'objectif est atteint  ou non.
        Si elle est verte, l'objectif est atteint, si elle est rouge,
        l'objectif défini (colonne précédente) reste à atteindre.
        Lorsque l'objectif n'est pas encore atteint (première  étoile
        de couleur rouge, la seconde étoile indique  qu'on est proche
        de l'atteindre (étoile  verte)  ou  qu'on  est  loin  (étoile
        rouge). Lorsque l'objectif  est atteint (première étoile ver-
        te), la seconde indique s'il y a dépassement (rouge) ou bonne
        longueur (vert).
        (**) Noter que pour  calculer les  dépassements, la commande
        ne se sert pas des définitions de dépassements dans le projet
        mais de la valeur 1/12. Ainsi, si l'objectif est de 4000 si-
        gnes, la tolérance sera de +/- 4080/12, c'est-à-dire 340.
        L'excès (dépassement) ou le manque sera calculé par rapport à
        cette valeur, c'est-à-dire par rapport à 4080-340 pour le
        manque (3749) et par rapport à 4080 + 340 pour le dépassement
        (4420).

      Les lignes grisées sont des dossiers, c'est-à-dire des chapi-
      tres ou des parties. Elles cumulent les nombres de leurs élé-
      ments.

      Noter que vous pouvez définir les objectifs de chaque document soit
      avec un fichier CSV (#{'`scriv csv --help`'.jaune}) soit en indiquant
      l'objectif de chaque document avec la commande :
        #{'`scriv set objectif=<objectif> --document="Autre docum"`'.jaune}

EOT
end #/ module
