# encoding: UTF-8
=begin
  Command 'help' ou quand on fait simplement `scriv`

  C'est l'aide générale du site
=end
aide = <<-EOT
#{'  MANUEL DU PROGRAMME `scriv`  '.underlined('-').gras}

  #{'Description'.underlined('-', '  ')}

      La commande `scriv` permet d’interagir avec un projet Scrivener.

      Elle permet, par exemple, de construire la hiérarchie d'un pro-
      jet de roman à partir d'un fichier CSV (feuille de calcul) ou de
      calculer la pagination d'un dossier manuscrit.

  #{'Liste des commandes'.underlined('-', '  ')}

      On peut obtenir une liste complète des commandes en tapant :

          #{'scriv commands'.jaune}

  #{'Aide sur les commandes'.underlined('-', '  ')}

      Pour obtenir de l’aide sur une commande particulière,
      il suffit de l'appeler avec l'option « -h ».

      Par exemple, on obtient l'aide de la commande `pagination` en
      tapant :

          #{'scriv pagination -h'.jaune}

  #{'Third-party'.underlined('-', '  ')}

      Pour pouvoir utiliser la recherche de proximité, il faut charger la
      commande TreeTagger (http://www.cis.uni-muenchen.de/~schmid/tools/TreeTagger/#parfiles).
      Voir dans le fichier requirements.md la démarche.

  #{'Auteurs'.underlined('-', '  ')}

      La commande `scriv` a été mise au point par Philippe Perret
      (philippe.perret@yahoo.fr) pour son utilisation personnelle.

EOT
Scrivener.help(aide)
