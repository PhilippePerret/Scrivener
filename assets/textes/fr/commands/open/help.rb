# encoding: UTF-8
module AideGeneraleCommandeOpen
MANUEL = <<-EOT
#{'COMMANDE `scriv open`'.gras}

  Description
  -----------

       La commande `scriv open` permet d’ouvrir des éléments du pro-
       jet à commencer par le projet lui-même (lorsque la commande
       est utilisée sans argument).

   OBJETS OUVRABLES
   ----------------

     #{'scriv open'.jaune}

         Ouvre le projet dans Scrivener lui-même.

     #{'scriv open folder'.jaune}

         Ouvre le dossier contenant le projet, dans le Finder.

     #{'scriv open config[ --name=NAME]'.jaune}

         Ouvre le fichier de configuration par défaut (config.yaml) ou
         de nom NAME.

     #{'scriv open folder-scriv'.jaune}

         Ouvre le dossier caché `.scriv` qui contient tous les fi-
         chiers créés pour l'analyse du texte.

     #{'scriv open prox[imites][ <options>]'.jaune}

         Ouvrir la liste des proximités de mots propres au projet cou-
         rant, si elle existe.
         Si elle n'existe pas et que l'option `--create`, est définie,
         crée le fichier et l'ouvre pour ajouter les proximités pro-
         pres au projet.

     #{'scriv open lemma'.jaune}

         Ouvre la liste de lemmatisation des mots qui a permis de cal-
         culer les proximités et autres fréquences.

     #{'scriv open abbr[s|eviations][ <options>]'.jaune}

         Ouvre le fichier contenant les abbréviations de TreeTagger,
         pour en ajouter de nouvelles, mais en toute connaissance de
         cause.
         NOTE : il vaut mieux, cependant, utiliser la commande
         `scriv lemma` qui crée une copie du fichier original avant
         toute modification.

  OPTIONS
  -------

    --vim
        Pour ouvrir le fichier avec Vim plutôt qu'avec l'éditeur par
        défaut.

    --create
        Quand c'est possible, crée le fichier qui n'existe pas.


EOT
end #/ module
