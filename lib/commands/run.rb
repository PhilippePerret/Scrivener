# encoding: UTF-8
=begin
  Command 'help' ou quand on fait simplement `scriv`

  C'est l'aide générale du site
=end
if CLI.options[:help]
  aide = <<-EOT
  #{'  COMMANDE `scriv run`  '.underlined('-').gras}

    #{'Description'.underlined('-', '  ')}

        La commande `scriv run` permet de jouer du code ruby dans le
        programme, par rapport au projet courant.


  EOT
  Scrivener.help(aide)

else

  begin
    code = CLI.params[1].strip
    eval (code)
  rescue Exception => e
    puts e.message.rouge
    puts e.backtrace[0..2].join(String::RC).rouge
  end

end
