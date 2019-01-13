# encoding: UTF-8
module AideGeneraleCommandeCheck
MANUEL = <<-EOT
#{'  COMMANDE `scriv check[ chose]`  '.underlined('-', '  ').gras}

#{'  Description'.underlined('-', '  ')}

    La commande check permet de checker différentes choses, à commen-
    cer par la validité de l'installation.

#{'  Choses checkables'.underlined('-','  ')}

  #{'scriv check install[ation]'.jaune}

      Check l'installation de la commande scriv. En général, on
      appelle plutôt cette commande par le biais du script ruby lui-
      même, c'est-à-dire : `ruby ./bin/scriv.rb scriv check install`

  #{'scriv check projet'.jaune}

      Vérifie le projet. Mais plutôt qu'une vérification, c'est ici
      plutôt un état des lieux qui auquel on procède, qui indique
      les documents qui ont été produits pour le projet, les analyses
      etc.

EOT
end #/module
