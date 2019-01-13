# encoding: UTF-8
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
