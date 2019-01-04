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
    line && goto(line,column)
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

  def goto line, column
    print("\033[#{line};#{column||1}H")
  end

  # Fonctionne comme la commande `less` en affichant petit à petit le
  # message +msg+
  def less msg
    require 'curses'
    msg = msg.split(String::RC)
    msg_nombre_lignes = msg.count
    nombre_lignes = lines_count - 6
    moitie = nombre_lignes / 2

    indice_first_line = 0
    while
      system('tput civis')
      clear
      # puts "Nombre de lignes affichées : #{nombre_lignes}"
      portion = msg[indice_first_line...(indice_first_line + nombre_lignes)]
      # puts "De ligne #{indice_first_line} à ligne #{indice_first_line + nombre_lignes}"
      nombre_lignes_displayed = portion.count
      puts portion
      system('tput cvvis')

      goto(lines_count - 1, 1)
      touches, invite = touches_et_invite(indice_first_line, msg_nombre_lignes, moitie, nombre_lignes, nombre_lignes_displayed)
      case getc(invite, {expected_keys: touches} )
      when :up_arrow
        indice_first_line -= 1
      when :down_arrow
        indice_first_line += 1
      when 'n'
        indice_first_line += nombre_lignes
      when 'p'
        indice_first_line -= nombre_lignes
        indice_first_line = 0 if indice_first_line < 0
      when 'q'
        break
      end
    end
  end

  def touches_et_invite(indice_first_line, msg_nombre_lignes, moitie, nombre_lignes, nombre_lignes_displayed)
    # Touches possibles
    touches = Array.new
    invite  = Array.new
    if indice_first_line > 0
      touches << :up_arrow
      invite  << 'UP: Remonter'
    end
    if nombre_lignes_displayed >= nombre_lignes - 10
      touches << :down_arrow
      invite  << 'DOWN: Descendre'
    end
    if nombre_lignes_displayed >= nombre_lignes
      touches << 'n'
      invite  << 'n: Page suivante'
    end
    if indice_first_line > 15
      touches << 'p'
      invite  << 'p: Page précédente'
    end
    touches << 'q'
    invite  << 'q: Quitter'

    [touches, invite.join(', ')]
  end

  def lines_count
    @lines_count ||= `tput lines`.to_i
  end
  def columns_count
    `tput columns`.to_i
  end


end #/<< self
end #/Screen
end #/CLI
