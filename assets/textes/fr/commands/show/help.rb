# encoding: UTF-8
module AideGeneraleCommandeShow
MANUEL = <<-EOT
#{'AIDE DE LA COMMANDE `scriv show`'.gras}
================================

  Usage
  -----

    #{"`scriv show <choses:clé classement>`".jaune}


  Description
  -----------

    La commande #{'`scriv show`'.jaune} permet d’afficher les données
    voulues du projet Scrivener courant. C'est cette commande qui
    peut afficher par exemple les mots et leur forme dans l’analyse.

  Clés de classement
  ------------------

    Les clés de classement se placent après les éléments à voir et
    deux points. Par exemple `mots:alpha`.

    On peut utiliser :

      * alpha     Classement alphabétique
      * -alpha    Classement alphabétique inverse
      * count     Classement par nombre d'occurences
      * prox      Classement par nombre de proximités
      * dist      Classement par distance (proximités). De la plus
                  proche à la plus éloignée.
      * -dist     Inverse de précédente, des proximités les plus
                  éloignées aux proximités les plus proches.

  Exemple
  -------

    #{'`scriv show mots:alpha mots:prox`'.jaune}

    La commande ci-dessus va afficher la liste de tous les mots,
    d'abord en classement alphabétique, puis ensuite en classement
    par nombre de proximités.


  Éléments affichages
  -------------------

    mots, words  (p.e. : #{'scriv show mots'.jaune})

      Affichage des mots du texte, avec leur forme canonique, minus-
      cule, lemmatique, etc.

    prox, proximites  (p.e. : #{'scriv show prox:count'.jaune})

      Affichage de toutes les proximités, dans l'ordre voulu.

    dist, distances (p.e. : #{'scriv show dist:alpha'.jaune})

      Affiche de toutes les distances minimales (ou maximales) des
      mots du projet courant. Dans l'exem

EOT
end #/ module
