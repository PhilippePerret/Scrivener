# encoding: UTF-8
=begin
  Command 'help' ou quand on fait simplement `scriv`

  C'est l'aide générale du site
=end
class Scrivener
  if help?
    require_texte('commands.check.help')
    help(AideGeneraleCommandeCheck::MANUEL)
  else
    require_module('check')
    exec_check
  end
end#/Scrivener
