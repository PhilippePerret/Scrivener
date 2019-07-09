# encoding: UTF-8
module BuildConfigFileCommandHelp
AIDE = <<-SOUSAIDE

  AIDE PROPRE À LA COMMANDE `scriv build config-file`
  ===================================================

  Permet de construire un fichier dit « de configuation » qui permet
  de définir de nombreuses propriétés de l'application Scrivener pour
  le projet courant, comme les parties de l'interface visible, les
  zooms appliqués, les éléments sélectionnés, etc.

  Cf. l'aide de la commande `set` pour le détail des propriétés qui
  peuvent être définies : #{'scriv set -h'.jaune}

  Pour charger ce fichier, il suffira de faire :

          #{'scriv set --from=le/fichier'.jaune}

  … pour définir tous les paramètres précisés dans ce fichier de confi-
  guration.

  #{'Syntaxe de la commande'.underlined('-', INDENT)}

    #{'scriv build[ mon/projet.scriv] config-file[ --nom=<NAME>][ --lang=<LANG>]'.jaune}

  #{'Options'.underlined('-', INDENT)}

  --name/--nom=NOM    Pour donner le nom NOM au fichier de configura-
                      tion à créer.
                      Par défaut, ce sera `config.yaml`. Inutile de
                      préciser l'extension, elle sera ajoute au be-
                      soin.

  --lang=LANG         Pour changer la langue définie dans
                      ENV['SCRIV_LANG'] dans le fichier de configura-
                      tion.

  --readable          Si cette option est présente, les valeurs se-
                      ront bien alignées dans le fichier produit (ce
                      qui signifie en contrepartie que le fichier se-
                      ra plus clair mais plus lourd).

  --open[=EDITOR]     Si cette option est ajoutée, le fichier est im-
                      médiatement ouvert dans l'éditeur défini dans
                      le fichier de configuration de Scrivener dans
                      ENV['SCRIV_EDITOR'] ou dans l'éditeur spécifié
                      par EDITOR. Exemple :
                      #{'scriv build config-file --open=TextMate'}


SOUSAIDE
end
