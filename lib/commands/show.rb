# encoding: UTF-8
=begin
  Command 'help' ou quand on fait simplement `scriv`

  C'est l'aide générale du site
=end
class Scrivener

  if help?

    require_texte('commands.show.help')
    help(AideGeneraleCommandeShow::MANUEL)

  else

    require_module('Scrivener')
    require_module('show')
    Project.exec_show(project)

  end

end # /Scrivener
