# encoding: UTF-8
module AideGeneraleCommandeSet
MANUEL = <<-EOT
#{'AIDE DE LA COMMANDE `scriv set`'.gras}
===============================

  #{'scriv set[ path/to/proj.scriv][ <options>] <param>[="<valeur>"]'.jaune}

  Description
  -----------

    La commande `scriv set` permet de définir un grand nombre de
    données du projet Scrivener courant.

    Par exemple, on remarquera que définir le titre ou l'auteur
    d'un projet Scrivener est assez malaisé et bizarre : il faut
    passer par la compilation, ouvrir l'onglet des métadonnées et
    définir ces données dans cette partie. Et encore, si on fait
    « Annuler », les données seront perdues…

    La commande `scriv set auteur="Prénom Nom" titre="Le titre"`
    permet de remédier à ce problème.

  ATTENTION
  ---------

  Pour utiliser cette commande, il faut impérativement que le pro-
  jet soit fermé. S'il est ouvert, tous les réglages seront perdus
  pour la plupart. Cela tient au fait que Scrivener réenregistre
  toutes ses données en quittant le projet et que la commande `set`
  travaille sur les fichiers du projet (sur le disque), pas dans
  l'application ouverte elle-même.


EOT
end #/ module
