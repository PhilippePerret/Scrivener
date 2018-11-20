=begin

  Extension de la classe Curses

=end
module Curses


  def self.init options = nil
    options = default_options(options)
    self.init_screen
    self.curs_set(options[:cursor])  # Curseur invisible (par défaut : 0)
    self.start_color
    self.send(options[:echo] ? :echo : :noecho)
    self.init_custom_color # une de mes méthodes (cf. plus bas)
  end

  def self.default_options options
    options ||= Hash.new
    options.key?(:cursor) || options.merge!(cursor: 0)
    options.key?(:echo)   || options.merge!(echo: false)
    return options
  end

  # la class Curses::Console::Window permet de gérer plus facilement les
  # fenêtre.
  #
  # Pour initialiser une fenêtre Console::Window, NE PAS UTILISER Curses::Window
  # qui est une classe propre à Curses (et qu'on ne doit pas toucher ici)
  # Utiliser plutôt : Curses::Console::Window.new
  class Console
    class Window


      # ---------------------------------------------------------------------

      # La fenêtre Curses
      attr_accessor :cwindow
      attr_accessor :nombre_lignes

      def initialize nombre_lignes, options = nil
        options ||= Hash.new
        top   = options[:top] || 0
        left  = options[:left] || options[:col] || 0
        self.nombre_lignes = nombre_lignes
        self.cwindow = Curses::Window.new(nombre_lignes, Curses.cols - left, top, left)
        options[:background] && self.cwindow.bkgdset(options[:background])
        self.cwindow.clear
        self.cwindow.refresh
      end

      def clear_line num_line
        num_line >= 0 || num_line = nombre_lignes - num_line
        self.cwindow.setpos(num_line, 0)
        self.cwindow.deleteln
      end

      def puts str, options = nil
        affiche(str + String::RC, options)
      end
      # Écrit en ajoutant un retour chariot devant
      def sput str, options = nil
        affiche((options && options[:norc] ? '' : String::RC) + str, options)
      end
      # Affiche le texte +str+ dans la fenêtre.
      # Options peut contenir :
      #   :line   Numéro de la ligne
      #   :col    Colonne
      #   :style    Le style ou les styles (par exemple :rouge, :gras, etc.)
      def affiche str, options = nil
        options ||= Hash.new
        line = options[:line]
        if line && line < 0
          line = self.nombre_lignes + line
        end
        col  = options[:col]
        if options[:position]
          line, col = options[:position]
        end

        col ||= 2
        line && self.cwindow.setpos(line, col)
        if options.key?(:style)
          str = str.to_s
          self.cwindow.attron(Curses.disp_attributes(options[:style])) do
            ecrire_lignes(str, col)
          end
        else
          ecrire_lignes(str, col)
        end

        self.cwindow.refresh
      end
      # /affiche

      def ecrire_lignes(str, col)
        if str.index("\n")
          arr = str.split("\n")
          str = arr.first
          arr[1..-1].nil? || str += "\n" + arr[1..-1].collect{|s| "#{' '*col}#{s}"}.join("\n")
        end
        self.cwindow.addstr(str)
      end

      def clear
        cwindow.clear
      end

      def close
        cwindow.close
      end

    end #/Window
  end #/Console


  # Pour les couleurs, en deuxième chiffre
  # En deuxième chiffre:
  # 3: cacad'oie, 4: bleu
  # 5: mauve, 6: bleu ciel
  # 7: gris clair /blanc ?
  # 8: gris
  # 9: rouge vif
  # 10: vert flashy
  # 11: jaune
  # 12: bleu
  # 14: bleu flash
  # 15: blanc (à peine cassé)
  # 17: bleu très foncé
  # 23: vert foncé
  # 34: bleu clair
  # 51: bleu flashy
  # 53: marron
  # Curses.init_pair(5, 8,   15) # gris


  # Classe permettant de gérer les messages à l'utilisateur (en général)
  # en bas de la fenêtre active.
  #
  # Pour la créer, utiliser la méthode Curses::MessageWindow.create(top: <ligne>)
  # donc en indiquant sur quelle ligne doit se mettre la fenêtre.
  # Ce sera une fenêtre d'une seule ligne.
  #
  # Ensuite, utiliser Curses::MessageWindow.message/error pour envoyer des
  # message (créer un raccourci dans l'application)
  class MessageWindow

    class << self
      attr_accessor :window_message

      DEFAULT_OPTIONS_MESSAGE = {
        style: [:blue]
      }
      # Écrit un message dans la fenêtre des messages
      # @param options Hash | Symbol
      #   Si c'est un symbole, c'est le type d'affichage (:notice, :info, :action)

      def message str, options = nil
        options.is_a?(Symbol) && options = {type: options}
        options ||= DEFAULT_OPTIONS_MESSAGE
        window_message || raise("Il faut définir la fenêtre qui doit afficher les messages (Curses::Window.window_message = <...>)")

        options[:style] =
          case options[:type]
          when :notice  then :bleu_sur_noir
          when :action  then :vert_sur_noir
          when :info    then :gris_tres_clair_sur_noir
          when :warning then :rouge_sur_noir
          else :blanc_sur_noir
          end

        sleep_time = options[:sleep].to_i
        begin
          window_message.clear
          window_message.attron(Curses.disp_attributes(options[:style])) do
            window_message.setpos(0,2)
            window_message.addstr(str + (sleep_time > 0 ? " (#{sleep_time})" : ''))
            window_message.refresh
            sleep_time > 0 && begin
              sleep 1
              sleep_time -= 1
            end
          end
        end while sleep_time > 0
        # Quand on a utilisé un sleep-time, on efface le message tout
        # de suite
        options[:sleep].nil? || message('')

      end

      # Crée la fenêtre des messages
      # @param attrs Hash
      #   :top, :left, :nombre_lignes, :nombre_colonnes, :background
      def create attrs = nil
        attrs ||= Hash.new
        top       = attrs[:top] || 0
        left      = attrs[:left] || 0
        nb_lignes = attrs[:nombre_lignes] || 1
        nb_colons = attrs[:nombre_colonnes] || Curses.cols
        wnd = Curses::Window.new(nb_lignes, nb_colons, top, left)
        attrs[:background] && wnd.bkgdset(attrs[:background])
        wnd.clear
        wnd.refresh
        self.window_message = wnd
      end

    end #/<< self
  end #/Window


  # ---------------------------------------------------------------------
  #   Module Curses
  # ---------------------------------------------------------------------

  CUSTOM_COLORS = Hash.new

  def self.default_message_window=(wnd)
    @default_message_window = wnd
  end
  def self.default_message_window
    @default_message_window
  end

  def self.init_custom_color
    # On prépare les couleurs
    init_color(COLOR_BLACK, 0, 0, 0)

    # sleep 2
    init_pair(9, COLOR_BLACK,  15)
    init_pair(1, 196, 15)
    init_pair(2, COLOR_BLUE,   15)
    init_pair(4, COLOR_GREEN,  15) # 2
    init_pair(5, 146,   15) # gris sur blanc
    init_pair(10, 39,   COLOR_BLACK) # bleu sur noir
    init_pair(11, 48,   COLOR_BLACK) # vert sur noir
    init_pair(12, 210,  COLOR_BLACK) # gris sur blanc
    init_pair(13, 196,  COLOR_BLACK) # rouge sur noir
    init_pair(15, 15,   COLOR_BLACK) # blanc sur noir
    init_pair(20, 15,   160) # blanc sur rouge # aussi 196
    init_pair(21, 15,   28) # blanc sur vert

    init_pair(30, 196, COLOR_BLACK)
    CUSTOM_COLORS.merge!(
      noir_sur_blanc:             color_pair(9),
      gris_sur_blanc:             color_pair(5),
      rouge_sur_blanc:            color_pair(1),
      bleu_sur_blanc:             color_pair(2),
      vert_sur_blanc:             color_pair(4),
      bleu_sur_noir:              color_pair(10),
      bleu:                       color_pair(10),
      vert_sur_noir:              color_pair(11),
      vert:                       color_pair(11),
      blanc_sur_noir:             color_pair(15),
      blanc:                      color_pair(15),
      gris_tres_clair_sur_noir:   color_pair(12),
      gris_clair:                 color_pair(12),
      rouge_sur_noir:             color_pair(13),
      rouge:                      color_pair(13),
      exergue_rouge:              color_pair(20),
      exergue_vert:               color_pair(21)
    )
  end

  # Construit la valeur à utiliser dans window.attron(...)
  def self.disp_attributes attrs
    attrs.is_a?(Array) || attrs = [attrs]
    curses_attrs = 0
    attrs.each do |attr|
      curses_attrs =
        case attr
        when :defaut, :default  then curses_attrs | color_pair(9)
        when :red               then curses_attrs | color_pair(1)
        when :blue              then curses_attrs | color_pair(2)
        when :green             then curses_attrs | color_pair(4)
        when :gris, :grey       then curses_attrs | color_pair(5)
        when :gras, :bold       then curses_attrs | A_BOLD
        else
          if CUSTOM_COLORS.key?(attr)
            curses_attrs | CUSTOM_COLORS[attr]
          end
        end
    end
    return curses_attrs
  end
  # /disp_attributes


  # Permet de choisir une couleur en les passant en revue
  #
  # Placer cet appel à un endroit du programme où la couleur
  # a déjà été utilisée, puis envoyer l'indice couleur (premier chiffre
  # de `init_pair`).
  # @param color    Indice couleur
  # @param win      Curses::Window pour pouvoir écrire l'indice
  # @param options  Hash
  #   :background     Fond à utiliser (15 par défaut => blanc)
  #   :start_color    Indice de départ (1 par défaut)
  #   :among          Une liste d'indices parmi lesquels choisir (on les
  #                   passe en revue en boucle)
  def self.choose_color indice_color, win, options = nil
    options ||= Hash.new
    options.key?(:background) || options.merge!(background: 15)
    if win.respond_to?(:cwindow)
      win = win.cwindow
    end
    begin
      icolor =
        if options.key?(:start_color)
          options[:start_color]
        elsif options.key?(:among)
          @iamong ||= 0
          options[:among][0]
        else
          1
        end
      begin
        init_pair(indice_color, icolor,  options[:background])
        win.setpos(0,0)
        win.addstr("Indice couleur : #{icolor} (touche => suivant, 'q' => arrêter)")
        # choix = wait_for_commande(win)
        choix = win.getch
        if choix == 'q'
          win.setpos(0,0)
          win.deleteln
          return
        end
        icolor =
          if options.key?(:among)
            @iamong += 1
            @iamong < options[:among].count || @iamong = 0
            options[:among][@iamong]
          else
            icolor + 1
            icolor < 257 || icolor = 1
          end
      end while true
    rescue Exception => e
      win.addstr("ERROR: #{e.message}")
      sleep 4
    end
  end
  # Permet de choisir une couleur DE FOND en les passant en revue
  #
  # Placer cet appel à un endroit du programme où la couleur
  # a déjà été utilisée, puis envoyer l'indice couleur (premier chiffre
  # de `init_pair`).
  # @param color    Indice couleur
  # @param win      Curses::Window pour pouvoir écrire l'indice
  # @param options  Hash
  #   :foreground     Couleur de police à utiliser (noir par défaut)
  #   :start_color    Indice de départ (1 par défaut)
  #   :among          Une liste d'indices parmi lesquels choisir (on les
  #                   passe en revue en boucle)
  def self.choose_background indice_color, win, options = nil
    options ||= Hash.new
    options.key?(:foreground) || options.merge!(foreground: COLOR_BLACK)
    if win.respond_to?(:cwindow)
      win = win.cwindow
    end
    begin
      icolor =
        if options.key?(:start_color)
          options[:start_color]
        elsif options.key?(:among)
          @iamong ||= 0
          options[:among][0]
        else
          1
        end
      begin
        init_pair(indice_color, options[:foreground], icolor)
        win.setpos(0,0)
        win.addstr("Indice couleur : #{icolor} (touche => suivant, 'q' => arrêter)")
        win.refresh
        # choix = wait_for_commande(win)
        choix = win.getch
        if choix == 'q'
          win.setpos(0,0)
          win.deleteln
          return
        end
        if options.key?(:among)
          @iamong += 1
          @iamong < options[:among].count || @iamong = 0
          icolor = options[:among][@iamong]
        else
          icolor += 1
          icolor < 257 || icolor = 1
        end
      end while true
    rescue Exception => e
      win.addstr("ERROR: #{e.message}")
      sleep 4
    end
  end

end #/Curses
