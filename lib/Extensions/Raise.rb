


def raise_by_mode err, mode = nil
  puts String::RC*3
  case mode
  when :pour_tout_voir # mettre "mode"
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
