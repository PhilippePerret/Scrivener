# encoding: UTF-8
=begin
  Command 'help' ou quand on fait simplement `scriv`

  C'est l'aide générale du site
=end
if CLI.options[:help]
  Scrivener.require_texte('commands/check/help')
  Scrivener.help(AideGeneraleCommandeCheck::MANUEL)
else
  Scrivener.require_module('check')
  Scrivener.exec_check
end
