# encoding: UTF-8
class Scrivener

  if help?

    require_texte('commands.pagination.help')
    help(AideGeneraleCommandePagination::MANUEL)

  else

    require_module('pagination')
    project.exec_pagination

  end

end #/ Scrivener
