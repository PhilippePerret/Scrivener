# encoding: UTF-8
=begin
  Command 'help' ou quand on fait simplement `scriv`

  C'est l'aide générale du site
=end
if CLI.options[:help]
  aide = <<-EOT
  #{'  COMMANDE `scriv last[s]`  '.underlined('-').gras}

    #{'Description'.underlined('-', '  ')}

        Permet d’obtenir la liste des 10 derniers projets analysés ou
        utilisés par la commande `scriv`.

        Taper l'indice correspondant au projet permet ensuite de le
        mettre en projet courant.

  EOT
  Scrivener.help(aide)

else
  Scrivener.require_module('last')
  Scrivener.exec_last_projects
end
