# encoding: UTF-8
class Scrivener

  if help?

    require_texte('commands.check.help')
    help(AideGeneraleCommandeCheck::MANUEL)

  else

    require_module('check')
    exec_check

  end

end#/Scrivener
