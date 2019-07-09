# frozen_string_literal: true
# encoding: UTF-8
=begin



=end
INDENT        = '  '
DBLINDENT     = INDENT * 2
INDENT_TIRET  = INDENT + '– '

class CLI
class Screen
class << self

  # Nettoyer l'écran
  def clear
    puts "\033c"
  end

  # +options+
  #     :underlined   If true (or caracter string), add a underline (not slowly)
  #                   under the +str+
  #     :newline     If false, no new line after +str+
  #     :line         Line number for +str+ (default: 1)
  #     :column       Column number for +str+ (default: 1)
  def write_slowly str, options = nil
    options ||= Hash.new
    options.key?(:newline) || options.merge!(newline: true)
    options[:line] && goto(options[:line],options[:column]||1)
    if CLI.mode_interactif? && !CLI.options[:no_slowly] && !CLI.options[:fast]
      print INDENT
      str.split('').each do |let|
        print let
        sleep 0.04
      end
    else
      print str
    end
    if options[:underlined]
      options[:underlined].is_a?(String) || options[:underlined] = '-'
      print String::RC + INDENT + (options[:underlined] * str.length)
    end
    print String::RC if options[:newline]
  end

  def goto line, column
    print("\033[#{line};#{column||1}H")
  end

  # Pour choisir dans une liste de valeur, par l'index de cette valeur
  # dans la liste.
  # La touche 'q' permet toujours de sortir. Mais elle doit être traitée
  # par la méthode appelante, elle renvoie nil.
  # Sinon, c'est le choix 0-start qui est retourné.
  #
  # +liste+       Liste des valeurs. Ce sont des Hash.
  #               Si Liste est un Hash, on prend ses values.
  #
  # +options+
  #   :ktitle     La clé (propriété) qui contient le texte à écrire dans la
  #               liste de choix. :item par défaut
  #   :multiple   Plusieurs choix possibles (séparés par des virgules)
  #               TODO À implémenter
  def select_in liste, options = nil
    options ||= Hash.new
    options.key?(:ktitle) || options.merge!(ktitle: :item)
    options.key?(:invite) || options.merge!(invite: INDENT+'Votre choix')
    liste.is_a?(Hash) && liste = liste.values
    ekeys = Array.new
    puts String::RC*2
    liste.each_with_index do |d, idx|
      lettre = (97+idx).chr
      puts INDENT * 2 + '%s : %s' % [lettre, d[options[:ktitle]]]
      ekeys << lettre
    end
    ekeys << 'q'
    puts String::RC*2
    choix = getc(options[:invite], {expected_keys: ekeys})
    if choix != 'q'
      choix.ord - 97
    else
      nil
    end
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
