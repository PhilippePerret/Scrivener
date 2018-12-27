# encoding: UTF-8
=begin
  Command 'build' pour voir les infos générales du projet courant

  C'est l'aide générale du site
=end

if CLI.options[:help]
  aide = <<-EOT
  #{'AIDE DE LA COMMANDE `scriv build`  '.underlined('-','  ').gras}

    #{'Description'.underlined('-', '  ')}

        La commande `scriv build` permet de construire des éléments
        dans le projet scrivener courant. Cette commande ne peut pas
        s'appeler seule. Il lui faut forcément un premier paramètre
        en argument. Ces paramètres définissent ce qui doit être
        construit :

        `documents`   Construit les dossiers et documents à partir
                      d'un fichier csv défini avec l'option `--from`
                      ou `--depuis`

  EOT
  Scrivener.help(aide)

else
  Scrivener.require_module('Scrivener')
  Scrivener.require_module('build')
  Scrivener::Project.exec_build
end
