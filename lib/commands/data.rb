# encoding: UTF-8
=begin
  Command 'help' ou quand on fait simplement `scriv`

  C'est l'aide générale du site
=end
if CLI.options[:help]
  aide = <<-EOT
  #{'  COMMANDE `scriv data`  '.underlined('-').gras}

    #{'Description'.underlined('-', '  ')}

        La commande `scriv data` permet d’obtenir les donnée du
        projet Scrivener courant (*).

        (*) « courant » signifie, dans l'ordre :
        - le projet dont le chemin d'accès est spécifié dans la
          commande. Par exemple : `scriv data ~/projets/proj.scriv`
        - le projet contenu par le dossier dans lequel on se
          trouve en ce moment.
        - le dernier projet utilisé par la commande `scriv`.

  EOT
  Scrivener.help(aide)

else
  Scrivener.require_module('Scrivener')
  Scrivener.require_module('data')
  Scrivener::Project.exec_data_projet(project)
end
