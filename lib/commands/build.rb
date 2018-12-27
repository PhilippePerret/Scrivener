# encoding: UTF-8
=begin
  Command 'build' pour voir les infos générales du projet courant

  C'est l'aide générale du site
=end

# def puts str
#   puts_rf.write(str + String::RC)
# end
# def puts_rf
#   @puts_rf ||= File.open(puts_rf_path,'a+')
# end
# def puts_rf_path
#   @puts_rf_path ||= File.join(APPFOLDER,'LOG.LOG')
# end

if CLI.options[:help]
  aide = <<-EOT
  #{'AIDE DE LA COMMANDE `scriv build`  '.underlined('-','  ').gras}

    #{'Description'.underlined('-', '  ')}

        La commande `scriv build` permet de construire des éléments
        dans le projet scrivener courant.

  EOT
  Scrivener.help(aide)

else
  Scrivener.require_module('Scrivener')
  Scrivener.require_module('build')
  Scrivener::Project.exec_build
end
