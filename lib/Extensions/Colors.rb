=begin

  Colors for colors
  Version: 1.2.1
  Author:  philippe.perret@yahoo.fr

  # Note sur version 1.2.1
    Définition de la liste LIGHT_COLORS des couleurs claires (à utiliser sur
    fond sombre/noir).

=end
module Colors

  COLORS = {
    black:            [0, 0, 0],
    # Gris
    almost_black:     [10, 10, 10],
    dark_grey:        [20, 20, 20],
    blue_grey:        [120, 110, 140],
    very_light_grey:  [230, 240, 230],
    # Marrons
    brown:            [120, 70, 30],
    dark_brown:       [80, 30, 60],
    other_brown:      [150, 110, 20],
    # Blanck
    white:            [255, 255, 255],
    # Rouges
    red:              [255, 0, 0],
    light_red:        [250, 20, 20],
    bordeau:          [150, 20, 40],
    dark_bordeau:     [120, 10, 20],
    mauve:            [150, 30, 250],
    red_voiled:       [250, 30, 80],
    # Oranges
    orange:           [240, 120, 30],
    dark_orange:      [240, 90, 20],
    # Jaunes
    yellow:           [230, 250, 40],
    # Bleus
    blue:             [0, 20, 250],
    pretty_blue:      [20, 0, 150],
    dark_blue:        [0, 0, 80],
    hard_dark_blue:   [10, 0, 60],
    # Verts
    green:            [0, 120, 20],
    pretty_green:     [20, 120, 50],
    hard_green:       [0, 60, 10],
    pale_dark_green:  [0, 80, 90],
    cacadoie:         [110, 140, 120],
    dark_cacadoie:    [70, 80, 0]
  }

  DARK_COLORS = [
    :red_voiled,
    :blue,
    :hard_green,
    :dark_grey,
    :dark_bordeau,
    :almost_black,
    :dark_brown,
    :pretty_blue,
    :red,
    :dark_blue,
    :orange,
    :pale_dark_green,
    :brown,
    :hard_dark_blue,
    :bordeau,
    :light_red,
    :green,
    :dark_orange,
    :mauve,
    :pretty_green,
    :dark_cacadoie,
    :blue_grey,
    :other_brown,
    :cacadoie,
    :black
  ]

  LIGHT_COLORS = [
    # Les couleurs qui ne vont pas :
    # :pretty_blue
    :red,
    :blue_grey,
    :green,
    :orange,
    :yellow,
    :blue,
    :light_red,
    :cacadoie,
    :white,
    :very_light_grey,
    :pale_dark_green
  ]

  # Une méthode pour créer un cycle de couleurs
  #
  #   # Pour instancier le cycle
  #   cycle = Colors::Cycle.new([<options>])
  #         # Les options définissent le type du retour, la liste de départ,
  #         # etc.
  #         :format   Le format de retour.
  #                     :rtf      Code pour définition des couleurs RTF
  #                     :hexa     En code héxadécimal (p.e. 'FF0012')
  #                     :html     En code HTML (p.e. '#FF0012')
  #                     :console  Pour la ligne de commande
  #         :in     La liste des couleurs à utiliser
  #                 • par défaut, les valeurs de la table Colors::COLORS
  #                 Sinon,
  #                 • Soit une liste des identifiants de couleur, par exemple
  #                 [:black, :white[, etc.]]
  #                 • Soit l'identifiant d'une liste prédéfinies
  #                   Par exemple : :dark_colors, qui va reprendre la
  #                   liste Colors::DARK_COLORS
  #                 • Soit une liste de triolet [rouge, vert, bleu] définissant
  #                   chaque couleur, de 0 à 255.
  #   # Pour obtenir la couleur suivante
  #   next_color = cycle.next
  #
  class Cycle
    attr_accessor :format
    def initialize options = nil
      options || raise('Colors::Cycle.new attend la définition du cycle de couleurs.')
      self.format = options[:format]
      define_liste_couleurs(options[:in])
      @icolor = -1 # pour commencer à 0
    end
    # Retourne la couleur suivante
    def next
      case format
      when :rtf         then Colors.color_as_rtf(next_item)
      when :hexa        then Colors.color_as_hexa(next_item)
      when :html, nil   then Colors.color_as_hexa(next_item, '#')
      when :console     then Colors.color_for_console(next_item)
      end
    end
    def next_item
      liste_couleurs[next_icolor]
      # puts "- next-item couleur (@icolor = #{@icolor}) : #{nitem.inspect}"
      # return nitem
    end
    def next_icolor
      @icolor += 1
      @icolor < nombre_couleurs || @icolor = 0
      @icolor
    end
    def liste_couleurs
      @liste_couleurs ||= Colors::COLORS.values
    end
    def nombre_couleurs
      @nombre_couleurs ||= liste_couleurs.count
    end
    def define_liste_couleurs(value)
      case value
      when Array
        if value.first.is_a?(Symbol)
          color_keys = value.collect{|kcolor| COLORS[kcolor]}
        else
          @liste_couleurs = value
          return
        end
      when Symbol
        color_keys =
          case value
          when :dark_colors  then Colors::DARK_COLORS
          when :light_colors then Colors::LIGHT_COLORS
          end
      else
        return # => liste par défaut
      end
      @liste_couleurs = color_keys.collect { |kcolor| COLORS[kcolor] }
    end
  end #/Cycle


  # Pour construire un nuancier HTML
  #
  # @usage
  #     nuancier = Colors::Nuancier.new()
  #     nuancier.build
  #     # Construit un nuancier sous forme de fichier HTML sur le bureau
  #     # de l'utilisateur courant.
  class Nuancier

    attr_reader :code_nuancier

    attr_accessor :pas

    attr_accessor :options

    # +options+
    #   :open     Si false, n'ouvre pas le fichier à la fin
    #   :pas      Le pas entre les couleurs
    #   :upto     Faire le nuancier seulement jusqu'à cette couleur
    #   :from     Partir de cette couleur
    #
    def initialize options = nil
      options ||= Hash.new
      self.options = options
      set_default_options
    end

    def set_default_options
      options.key?(:open) || options.merge!(open: true)
      self.pas = options[:pas] || 10
    end

    # Pour construire un nuancier HTML
    def build

      begin

        ref_desktop_file.write(code_html_start)

        @code_nuancier = ''
        # @code_nuancier = '<div>Pour essayer</div>'
        (0..255).step(pas).each do |ired|
          (0..255).step(pas).each do |igreen|
            (0..255).step(pas).each do |iblue|
              add_cell_couleur([ired, igreen, iblue])
              flush_code_nuancier_if_needed
            end#/blue
          end#/green
        end#/red

        # Finir le code HTML
        ref_desktop_file.write(code_html_fin)

      ensure
        ref_desktop_file.close
      end

      options[:open] && open_desktop_file

      puts "Fichier nuancier construit sur le bureau (nuancier.html)"
    end

    # Construction d'une cellule du nuancier
    def add_cell_couleur trio
      hexa = Colors.color_as_hexa(trio, '#')
      cell = code_cell % [hexa, trio.inspect, hexa]
      @code_nuancier << cell
    end

    # On écrit le code du nuancier au fur et à mesure
    def flush_code_nuancier_if_needed
      code_nuancier.length > 40000 || return
      ref_desktop_file.write(code_nuancier)
      @code_nuancier = ''
    end

    # Pour ouvrir le fichier
    def open_desktop_file
      `open "#{desktop_file}"`
    end

    def code_cell
      @code_cell ||= '<div class="cellc '+(options[:background] ? 'bg' : 'fg')+'" style="'+key_color+':%s;">TEXTE - Texte - %s - %s</div>'
    end

    def key_color
      @key_color ||= options[:background] ? 'background-color' : 'color'
    end

    def code_html_start
      <<-HTML
<!DOCTYPE html>
<html lang="fr" dir="ltr">
  <head>
    <meta charset="utf-8">
    <title>Nuancier</title>
    <style media="screen">
      div.cellc {
        display: inline-block;
        width:    140px;
        font-size:  14pt;
        padding:    5px 12px;
        margin:     2px 8px;
      }
      /* Quand c'est le background qu'on check */
      div.bg {
        color: #{options[:foreground_color] ? options[:foreground_color] : 'white'};
      }
      div.fg {
        background-color:  #{options[:background_color] ? options[:background_color] : 'white'};
      }
    </style>
  </head>
  <body>
    HTML
    end

    def code_html_fin
      <<-HTML
  </body>
</html>
      HTML
    end

    def ref_desktop_file
      @ref_desktop_file ||= begin
        File.unlink(desktop_file) if File.exist?(desktop_file)
        File.open(desktop_file,'ab')
      end
    end
    def desktop_file
      @desktop_file ||= File.expand_path(File.join(Dir.home,'Desktop','nuancier.html'))
    end
  end #/Colors::Nuancier


  # Prend le triolet RVB et retourne la couleur en hexadécimales
  #   [0,0,255] => '0000FF'
  def self.color_as_hexa vcolors, prefix = ''
    prefix + vcolors.map{|i| i.to_s(16).rjust(2,'0')}.join.upcase
  end

  def self.color_as_rtf vcolors
    '\red%i\green%i\blue%i' % vcolors
  end

  # Note : penser à ajouter "\x1B[0m" à la fin (avec guillemets doubles)
  def self.color_for_console(vcolors)
    "\033[38;5;%im" % [convert_to_ansi(vcolors)]
  end


  # Convertit un trio [R, G, B] en valeur ANSI utilisable dans un
  # code comme :
  # ansi = Colors.convert_to_ansi([255, 40, 0])
  # puts `echo "\033[38;5;#{ansi}mMON TEXTE EN COULEUR\033[0m"`
  def self.convert_to_ansi vcolors
    r, g, b = vcolors

    # we use the extended greyscale palette here, with the exception of
    # black and white. normal palette only has 4 greyscale shades.
    if r === g && g === b
      if r < 8
        return 16
      end

      if r > 248
        return 231
      end

      return (((r - 8).to_f / 247) * 24).round + 232
    end

    ansi = 16 +
      (36 * (r.to_f / 255 * 5).round) +
      (6 * (g.to_f / 255 * 5).round) +
      (b.to_f / 255 * 5).round

    return ansi
  end
end
