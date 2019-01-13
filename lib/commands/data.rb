# encoding: UTF-8
class Scrivener

  if help?

    require_texte('commands.data.help')
    help(AideCommandGeneralData::MANUEL)

  else

    require_module('Scrivener')
    require_module('data')
    Project.exec_data_projet(project)

  end

end #/Scrivener
