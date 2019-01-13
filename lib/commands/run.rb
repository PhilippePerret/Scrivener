# encoding: UTF-8
class Scrivener

  if help?

    require_texte('commands/run/help')
    help(AideGeneraleCommandeRun::MANUEL)

  else

    begin
      code = CLI.params[1].strip
      puts "Code à évaluer : #{code.inspect}"
      eval (code)
    rescue Exception => e
      puts e.message.rouge
      puts e.backtrace[0..2].join(String::RC).rouge
    end

  end

end # /Scrivener
