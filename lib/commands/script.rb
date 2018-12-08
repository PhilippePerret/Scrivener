# encoding: UTF-8
=begin
  Command 'help' ou quand on fait simplement `scriv`

  C'est l'aide générale du site
=end
if CLI.options[:help]
  aide = <<-EOT
  #{'  COMMANDE `scriv script <name>`  '.underlined('-').gras}

    #{'Description'.underlined('-', '  ')}

        La commande `scriv script <name>` joue le script qui est
        défini dans le dossier `./script`. C'est une commande
        plutôt réservée aux programmateurs.

  EOT
  Scrivener.help(aide)

else
  begin
    script_path = File.join(APPFOLDER,'script',CLI.params[1])
    script_path.end_with?('.rb') || script_path.concat('.rb')
    # puts '-- Jouer le script « %s »' % script_path
    File.exist?(script_path) || raise('Le fichier `%s` est introuvable.' % script_path)
    load script_path
  rescue Exception => e
    raise e
  end
end
