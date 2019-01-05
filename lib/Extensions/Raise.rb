


def raise_by_mode err, mode = nil
  mode = :tout_voir if CLI.verbose? # essai non testé
  puts String::RC*3
  case mode
  when :tout_voir # mettre "mode"
    puts ('ERREUR : ' + err.message).rouge
    puts err.backtrace.join(String::RC).rouge
  when :development, :dev, :developpement
    puts ('ERREUR : ' + err.message).rouge
    puts err.backtrace[0..2].join(String::RC).rouge
  else
    puts err.message.rouge
  end
  puts String::RC*3
end
