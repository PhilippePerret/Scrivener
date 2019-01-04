# encoding: UTF-8
=begin
  Command 'help' ou quand on fait simplement `scriv`

  C'est l'aide générale du site
=end
if CLI.options[:help]
aide = <<-EOT
#{'  COMMANDE `scriv check[ chose]`  '.underlined('-', '  ').gras}

#{'  Description'.underlined('-', '  ')}

    La commande check permet de checker différentes choses, à commen-
    cer par la validité de l'installation.

#{'  Choses checkables'.underlined('-','  ')}

  #{'scriv check install[attion]'.jaune}


EOT
  Scrivener.help(aide)

else
  Scrivener.require_module('check')
  Scrivener.exec_check
end
