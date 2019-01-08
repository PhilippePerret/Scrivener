# encoding: UTF-8
=begin
  Command 'help' ou quand on fait simplement `scriv`

  C'est l'aide générale du site
=end
if CLI.options[:help]
  aide = t('commands.data.help')
  Scrivener.help(aide)
else
  Scrivener.require_module('Scrivener')
  Scrivener.require_module('data')
  Scrivener::Project.exec_data_projet(project)
end
