# encoding: UTF-8
class Scrivener

  if help?

    require_texte('commands.last.help')
    help(AideGeneraleCommandeLast::MANUEL)

  else

    require_module('last')
    exec_last_projects

  end

end #/Scrivener
