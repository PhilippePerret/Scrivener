# encoding: UTF-8
=begin



=end
class CLI
class Screen
class << self

  def clear
    puts "\033c"
  end

  # +line+ Numéro de ligne où il faut écrire le texte
  def write_slowly str, line = nil, column = nil
    line && print("\033[#{line};#{column||1}H")
    if CLI.mode_interactif?
      print '  '
      str.split('').each do |let|
        print let
        sleep 0.04
      end
    else
      print str
    end
  end


end #/<< self
end #/Screen
end #/CLI
