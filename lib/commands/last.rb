# encoding: UTF-8
=begin
  Command 'help' ou quand on fait simplement `scriv`

  C'est l'aide générale du site
=end
class Scrivener

  if help?

    require_texte('commands.last.help')
    help(AideGeneraleCommandeLast::MANUEL)

  else

    require_module('last')
    exec_last_projects

  end

end #/Scrivener
