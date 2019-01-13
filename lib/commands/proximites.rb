# encoding: UTF-8
class Scrivener

  if help?

    require_texte('commands.proximites.help')
    help(AideGeneraleCommandeProximites::MANUEL)

  else

    require_module('prox/proximites')
    project.exec_proximites

  end

end #/Scrivener
