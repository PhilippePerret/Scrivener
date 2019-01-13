# encoding: UTF-8
class Scrivener

  if help?

    require_texte('commands.open.help')
    help(AideGeneraleCommandeOpen::MANUEL)

  else

    require_module('open')
    Project.exec_open_chose(CLI.params[1])

  end

end #/Scrivener
