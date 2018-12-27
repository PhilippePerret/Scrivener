# encoding: UTF-8
=begin
  Command 'test' pour tester l'application

=end
if CLI.options[:help]
  aide = <<-EOT
#{'  COMMANDE `scriv test`  '.underlined('-', '  ').gras}

  #{'Description'.underlined('-', '  ')}

    La commande `test` est une commande de programmation qui permet
    de lancer les tests de l'application.

  #{'Paramètres'.underlined('-', '  ')}

    On peut définir en paramètre les dossiers ou les fichiers dont
    il faut lancer les tests.

  EOT
  Scrivener.help(aide)

else
  Scrivener.require_module('test')
  Scrivener.exec_tests
end
