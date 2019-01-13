# encoding: UTF-8
=begin

  Commande/module permettant d'afficher la proximité des mots.


=end
class Scrivener

  if help?

    require_texte('commands.watch.help.rb')
    help(AideGeneraleCommandeWatch::MANUEL)

  else

    require_module('prox/watcher')
    project.exec_watch_proximites

  end

end # /Scrivener
