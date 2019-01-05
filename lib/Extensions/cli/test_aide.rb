module CLITestHelp
def self.aide_test_cmd
  <<-EOT
#{'COMMANDE `scriv test`  '.underlined('-', '  ').gras}

  #{'Description'.underlined('-', '  ')}

    La commande `test` est une commande de programmation qui permet
    de lancer les tests de l'application.

  #{'Paramètres'.underlined('-', '  ')}

    On peut définir en paramètre les dossiers ou les fichiers dont
    il faut lancer les tests. Ils doivent se trouver dans le dossier
    `test`. On mentionne les paths à partir de ce dossier.

  #{'Options'.underlined('-', '  ')}

    -v/--verbose    Mode verbeux.

    -- --line=LINE  Permet de ne jouer que le test qui se trouve à
                    la ligne LINE. Noter qu'il est impératif d'avoir
                    la marque d'Uncaught Option ("--") avant.

  #{'Exemples'.underlined('-', '  ')}

    #{'scriv test'.jaune}
      Lance l'intégralité des tests du dossier `test`. Donc tous les
      fichiers "ts_*.rb".

    #{'scriv test mon/dossier'.jaune}
      Lance l'intégralité des tests du dossier `./test/mon/dossier`.
      Donc tous les fichiers "ts_*.rb" de ce dossier.

    #{'scriv test mon/ts_test.rb'.jaune}
      Lance seulement le test `./test/mon/ts_test.rb`

    #{'scriv test ^<expression régulière>$'.jaune}
      Lance tous les tests du dossier `./test` qui répondent à l'ex-
      pression régulière "<expression régulière>".
      Par exemple, la commande #{'`scriv test "^nom.\.rb$"`'.jaune} filtra
      les fichiers `nom1.rb`, `nom2.rb` etc. Noter l'utilisation des
      guillemets autour de l'expression régulière pour conserver la
      balance arrière ("\").


EOT
end
# /aide_test_cmd
end
