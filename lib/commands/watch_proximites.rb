# encoding: UTF-8
class Scrivener

  if help?

    require_texte('commands.watch.help')
    help(AideGeneraleCommandeWatch::MANUEL)

  else

    require_module('prox/watcher')
    project.exec_watch_proximites

  end

end # /Scrivener
