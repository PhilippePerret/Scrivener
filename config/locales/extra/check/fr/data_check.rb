# frozen_string_literal: true
# encoding: UTF-8

DATA_CHECK_INSTALL = {
  scrivener_app: {
    success_msg:  'Présence de Scrivener (dossier /Applications)',
    failure_msg:  'L’application Scrivener est introuvable dans /Applications',
    value:        'File.exist?(File.join(scrivener_app_path))',
    evaluate:     'value == expected',
    expected:     'true',
    solve:        'Télécharger l’application Scrivener'
  },
  scrivener_version: {
    success_msg:  'Version suffisante de Scrivener (%{value}, minimum : %{expected})',
    failure_msg:  'Version insuffisante de Scrivener (minimum : %{expected}, actuelle : %{value})',
    evaluate:     'value >= expected',
    value:        'scrivener_app_version',
    expected:     '3.1',
    solve:        'Actualiser la version de Scrivener'
  },
  scriv_app: {
    success_msg:  'Application CLI `scriv` trouvée',
    failure_msg:  'L’application CLI `scriv` est introuvable…',
    value:        'File.exist?(File.join(APPFOLDER,\'bin\',\'scriv.rb\'))',
    expected:     'true',
    evaluate:     'value == expected',
    solve:        'Il faut charger la dernière version stable à l’adresse https://github.com/PhilippePerret/Scrivener'
  },
  scriv_builder_command: {
    success_msg:  'Le constructeur de la commande `scriv` existe',
    failure_msg:  'Le constructeur de la commande `scriv` est introuvable…',
    value:        'File.exist?(File.join(APPFOLDER,\'bin\',\'build_command.rb\'))',
    expected:     'true',
    evaluate:     'value == expected',
    solve:        'Il faut recharger une version stable de `scriv` à l’adresse https://github.com/PhilippePerret/Scrivener'
  },
  scriv_alias: {
    success_msg:  'Le lien symbolique pour utiliser la commande `scriv` existe',
    failure_msg:  'Le lien symbolique pour utiliser la commande `scriv` est introuvable',
    value:        'joue_commande_scriv_simple',
    expected:     'true',
    evaluate:     'value == expected',
    solve:        [
      'Se placer dans le dossier de l’application : `cd "%s"`)' % [APPFOLDER],
      'Jouer le script d’installation : `ruby ./bin/build_command.rb`'
    ]
  },
  ruby_version: {
    success_msg:  'Version de Ruby suffisante (%{value}, minimum : %{expected})',
    failure_msg:  'Version de Ruby insuffisante (minimum : %{expected}, actuelle : %{value})',
    value:        'RUBY_VERSION.to_f',
    evaluate:     'value >= expected',
    expected:     '2.3', # version ruby
    solve:        'Actualiser la version de Ruby'
  },
  required_gems: {
    success_msg:  'Tous les gems ruby requis sont installés et actualisés',
    failure_msg:  'La liste des gems n’est pas conforme (cf. ci-dessous)',
    value:        'all_gems_valid?',
    expected:     'true',
    evaluate:     'value === expected',
    solve:        [
      'Se placer dans le dossier de la commande à l’aide de  `cd "%s"`' % [APPFOLDER],
      'Jouer `bundle install` (pour installer tous les gems requis)'
    ]
  },
  tree_grabber: {
    success_msg:  'Commande Tree-Tagger (pour la lemmatisation)',
    failure_msg:  'Commande Tree-Tagger (pour la lemmatisation) introuvable…',
    value:        'File.exist?(File.join("/","usr","local","TreeTagger"))',
    expected:     'true',
    evaluate:     'value == expected',
    solve:        [
      'Charger la commande tree-grabber à partir de http://www.cis.uni-muenchen.de/~schmid/tools/TreeTagger/#parfiles',
      'Placer le dossier téléchargé dans "/usr/local" (utiliser "open /usr/local" dans le Terminal pour l’ouvrir)',
      'Faire un "alias" en tapant le code suivant dans le Terminal : ln -s /usr/local/TreeTagger/cmd/tree-tagger-french /usr/local/bin'
                  ]
  }
}
