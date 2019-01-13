# encoding: UTF-8
=begin
  Command 'help' ou quand on fait simplement `scriv`

  C'est l'aide générale du site
=end
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
