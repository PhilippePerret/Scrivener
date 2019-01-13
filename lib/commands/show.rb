# encoding: UTF-8
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
