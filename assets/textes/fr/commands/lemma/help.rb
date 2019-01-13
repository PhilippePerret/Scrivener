# encoding: UTF-8
module AideGeneraleCommandeLemma
MANUEL = <<-EOT
#{'AIDE DE LA COMMANDE `lemma`'.gras}
===========================

Usage :    #{'scriv lemma[ vers/mon/projet.scriv][ <operation>][ <options>]'.jaune}

  Description
  -----------

    La commande `lemma` permet de définir certaines valeurs de
    lemmatisation, à commencer par les listes de mots propres
    à un projet scrivener.

  Opération
  ---------

    #{'scriv lemma abbreviations'.jaune}

        Permet de modifier la liste des abbréviations de Tree-
        Tagger.

    #{'scriv lemma abbreviations --original'.jaune}

        Permet de récupérer le fichier original fourni avec
        la commande. À utiliser en cas d'erreur.

    #{'scriv lemma[ path/to/proj.scriv] mots'.jaune}

        Permet de définir les mots propres au projet spécifié
        en définissant les distances minimum.
        Cf. ci-dessous les notes sur la définition de cette
        liste.


  LISTE DES MOTS PROPRES AU PROJET
  --------------------------------

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


  Options
  -------

    --original

        Avec l'opération `abbreviations`, permet de récupérer le
        fichier original des abbréviations.


EOT
end #/ module
