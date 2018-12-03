# encoding: UTF-8
=begin
  Command 'infos' pour voir les infos générales du projet courant

  C'est l'aide générale du site
=end
if CLI.options[:help]
  aide = <<-EOT
  #{'  COMMANDE `scriv infos`  '.underlined('-').gras}

    #{'Description'.underlined('-', '  ')}

        La commande `scriv infos` permet d’obtenir les informations
        sur le projet Scrivener courant, c'est-à-dire le dernier
        projet analysés.

        Donne par exemple son chemin d'accès et sa date de dernière
        analyse.

  EOT
  Scrivener.help(aide)

else
  Scrivener.require_module('infos')
  Scrivener::Project.exec_infos_last_projet
end
