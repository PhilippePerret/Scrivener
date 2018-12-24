# encoding: UTF-8
=begin

  Commande/module permettant de calculer la pagination du roman actuellement
  édité en fonction des objectifs définis.

  TODO
    * pouvoir fournir l'option -N qui va dire de ne pas afficher les nombres
    * pouvoir donner le coefficient de premier jet (fdc — first-draft-coeff)
      qui va permettre de ramener les nombres au projet final. Cette valeur
      doit être le coefficient employé, 1.5 par défaut
      pagination mon/projet.scriv -fdc=1.5
      Produire une nouvelle colonne avec les valeurs.

=end
if CLI.options[:help]
  aide = <<-EOT
#{' Aide à la commande `pagination` '.underlined.gras}

Usage :    #{'scriv pagination[ vers/mon/projet.scriv][ <options>]'.jaune}

#{'Description'.underlined}

    Permet de calculer la pagination du projet spécifié.

    Deux paginations différentes sont affichées :

    * La pagination s'appuyant sur la longueur de texte de chaque
      document. C'est la pagination normale d'une table des matières.
    * La pagination s'appuyant sur la définition des objectifs de
      chaque document. Cette pagination permet de construire les pro-
      portions du roman ou du texte en général.

    La table des matières peut être produite dans le terminal, dans
    un fichier HTML ou un fichier simple texte.


#{'Options'.underlined}

    -o/--output=[console|html|file]

        Définit la sortie de la table des matières produite. L'option
        `console` sort la table des matières en console. L'option
        `html` produit un fichier HTML et l'option `file` la sort
        dans un fichier texte simple.

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
  EOT

  Scrivener::help(aide)
else

  Scrivener.require_module('pagination')
  project.exec_pagination

end
