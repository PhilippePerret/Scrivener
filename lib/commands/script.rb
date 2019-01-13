# encoding: UTF-8
=begin
  Command 'help' ou quand on fait simplement `scriv`

  C'est l'aide générale du site
=end
class Scrivener

  if help?

    require_texte('commands.script.help')
    help(AideGeneraleCommandeScript)

  else

    begin
      script_path = File.join(APPFOLDER,'script',CLI.params[1])
      script_path.end_with?('.rb') || script_path.concat('.rb')
      File.exist?(script_path) || rt('files.errors.unfound_file' % {pth: script_path})
      load script_path
    rescue Exception => e
      raise e
    end

  end #/ if

end # /Scrivener
