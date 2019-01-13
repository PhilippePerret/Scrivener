# encoding: UTF-8
=begin
  Command 'infos' pour voir les infos générales du projet courant

  C'est l'aide générale du site
=end
class Scrivener

  if help?

    require_texte('commands.infos.help')
    help(AideGeneraleCommandeInfos::MANUEL)

  else

    require_module('Scrivener')
    require_module('infos')
    Project.exec_infos_last_projet

  end

end #/ Scrivener
