# encoding: UTF-8
module AideGeneraleCommandeHelp
MANUEL = <<EOT
#{'`scriv` MANUAL'.gras}
============================

  Note
  ----
      To read this manual in french, or in another language, use
      `scriv set lang=fr` puis retaper la commande `scriv help`

  Description
  -----------

      `scriv` command lets you interact with a Scrivener project.

      Elle permet, par exemple, de construire la hiérarchie d'un pro-
      jet de roman à partir d'un fichier CSV (feuille de calcul) ou de
      calculer la pagination d'un dossier manuscrit.

  Command list
  ------------

      You can get a full command list in writing:

          #{'scriv commands'.jaune}

  Command help
  ------------

      To get a help about a particular command, add `-h` calling it.
      For instance, you can get the "pagination" command help with:

          #{'scriv pagination -h'.jaune}

  Special operations
  ------------------

    Redéfinir les objectifs des fichiers d'un roman
    -----------------------------------------------
    Définir les objectifs dans Scrivener peut être assez fastidieux
    et, surtout, contreproductif cas on travaille à l'aveugle, sans
    voir ce que les modifications produisent en direct.
    Pour procéder souplement à cette opération, il est préférable
    d'utiliser une autre application, Calc ou Numbers (sur Mac).
    Procédure :
      1. Exporter la table des matières du projet courant grâce
         à la commande : #{'`scriv tdm -o=csv --open`'.jaune}
      2. Grâce à l'option `--open` (ci-dessus), le fichier s'ouvre
         aussitôt fabriqué dans Numbers (sur Mac).
      3. Modifier les valeurs `Objectif` (5ème colonne) en utilisant
         des unités réduites, 'p', 'm' ou 'c' respectivement pour
         page (p), mot (m) ou caractère (c). Par exemple '4p' pour 4
         pages ou '20m' pour "20 mots".
      4. Jouer la commande inverse #{'`scriv tdm --input=tdm.csv`'.jaune}
         Cette commande recharge la table des matières en définissant
         les objectifs définis.

  Third-party
  -----------

      Pour pouvoir utiliser la recherche de proximité, il faut charger la
      commande TreeTagger (http://www.cis.uni-muenchen.de/~schmid/tools/TreeTagger/#parfiles).
      Voir dans le fichier requirements.md la démarche.

  Auteurs
  -------

      La commande `scriv` a été mise au point par Philippe Perret
      (philippe.perret@yahoo.fr) pour son utilisation personnelle.
      Elle est fournie « as is » (telle quelle), sans aucune garantie
      ni de fonctionnement ni d’efficacité. Vous l’utilisez à vos
      propres risques et périls ;-).


EOT
end #/module
