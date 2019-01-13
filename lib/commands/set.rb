# encoding: UTF-8
class Scrivener

  require_module('Scrivener')
  require_module('set') # même pour l'aide

  if help?

    require_texte('commands.set.help')
    help(AideGeneraleCommandeSet::MANUEL + Project.aide_commande_set)

  else

    Project.exec_set

  end

end # /Scrivener
