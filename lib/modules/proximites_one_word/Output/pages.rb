=begin

  Module pour construire les pages à afficher

  Isolé par rapport au projet pour avoir des valeurs d'instance accessibles
  partout.

=end
class Scrivener
class Project
class Output

  TABV = '  ' # Pour "TABulation Vierge"
  TAB = '  '.noirsurblanc

  class << self

    attr_accessor :projet
    attr_accessor :table # correspond à project.tableau_proximites
    # Instance ProxMot du mot dont il faut voir les proximités
    attr_accessor :proxmot

    # Dimension de l'écran courant
    attr_accessor :nombre_colonnes, :nombre_lignes
    # Largeur d'une colonne de texte (avec une gouttière de 4 et des
    # marges de 2 — ou des marges de 2 à droite et à gauche)
    attr_accessor :largeur_colonne

    def affiche_en_deux_page iprojet, proxmot
      self.projet   = iprojet
      self.table    = iprojet.tableau_proximites
      self.proxmot  = proxmot
      define_lines_of_texte
      display_lines_of_texte
    end

    attr_accessor :page_lines   # Liste des lignes à afficher.


    # Maintenant que les lignes de texte ont été établies, on peut les
    # afficher dans la fenêtre, sous forme de deux colonnes. De x lignes
    #
    # Plusieurs cas peuvent se présenter :
    #   Cas 1     Le texte est court (plus court que la hauteur de fenêtre)
    #             => On affiche le texte normalement.
    #   Cas 2     Le texte est plus long, mais il tient dans les deux
    #             colonnes.
    #             => On l'affiche dans les deux colonnes.
    #   Cas 3     Le texte est très long, plus long que les deux colonnes.
    #             => On affiche la partie visible et on attend une touche
    #             pour passer à la suite.
    def display_lines_of_texte
      finalise_lines_of_pages
      ligne_blanche = TAB * 2 + (' ' * largeur_colonne).grisitalsurblanc
      puts String::RC * 10
      puts TABV + ligne_blanche
      reste_lignes = 3

      # Pour le moment, on affiche tout
      puts page_lines.join(String::RC)

      # if page_lines.count < nombre_lignes
      #   # Cas 1
      #   puts page_lines.join(String::RC)
      #   reste_lignes = nombre_lignes - page_lines.count
      # else
      #   # Cas 2 et 3 maintenant qu'on n'affiche que sur une seule
      #   # colonne
      #   page_lines[0...(nombre_lignes - 10)].each do |line|
      #     puts line
      #   end
      #   reste_lignes = 4
      # end

      puts TABV + ligne_blanche
      if reste_lignes > 0
        puts String::RC * reste_lignes
      end
    end
    # /display_lines_of_texte

    # Pour finaliser les lignes, en ajoutant les espaces nécessaires à un
    # affichage correcte
    def finalise_lines_of_pages
      self.page_lines = page_lines.collect { |line| TABV + TAB + line + TAB }
    end
    # /finalise_lines_of_pages


    # Méthode qui affiche le texte avec les proximités dans la fenêtre
    attr_accessor :cur_line     # ligne de texte courante (en traitement)
    attr_accessor :len_cur_line # longeur de la ligne courante
    def define_lines_of_texte

      # Les trois parties de fenêtre à simuler, ici sans passer par
      # Curses, pour avoir des couleurs plus nombreuses et plus facile
      # à manipuler. On se sert juste de Curses pour obtenir le nombre de
      # lignes et de colonnes de l'écran actuel.
      #
      # ---------------------------------------------------------
      # |                            |                          |
      # |          Page 1            |        Page 2            |
      # |                            |                          |
      # |                            |                          |
      # |                            |                          |
      # |                            |                          |
      # |                            |                          |
      # |                            |                          |
      # ---------------------------------------------------------
      # | Partie 3 (footer) pour les informations               |
      # |                                                       |
      # ---------------------------------------------------------

      # Toutes les lignes de la portion étudiée. C'est cette liste que la
      # méthode permet de construire.
      self.page_lines = Array.new


      nombre_cols     = `tput cols`.to_i
      nombre_lines    = `tput lines`.to_i
      self.nombre_colonnes = nombre_cols
      self.nombre_lignes = nombre_lines
      hauteur_footer  = 5 # lignes
      hauteur_page    = nombre_lines - hauteur_footer
      # self.largeur_colonne = (nombre_cols / 2) - 8 # 8 pour une gouttière de 4 et des marges de 2
      self.largeur_colonne = nombre_cols - 16 # affichage en une seule colonne

      data_mot = table[:mots][proxmot.canon]

      # Si aucune proximité n'a été trouvée, on peut s'en retourner
      data_mot[:proximites].count > 0 || begin
        puts "Ce mot ne possède aucune proximité.".bleu
        return nil
      end

      # On ajoute les couleurs aux segments
      projet.define_word_colors_in_segments(data_mot[:proximites], {color_format: :console})


      # On commence par calculer la longueur réelle de chaque segment, en
      # considérant que :
      #   1. Les marques de couleurs ne comptent pas
      #   2. Un mot en proximité avant et arrière aura une longueur double
      #      plus un pour le trait droit.
      projet.segments = projet.segments.collect do |data_segment|
        twocolors = data_segment[:has_color] == 2
        len_seg   = data_segment[:seg].length
        data_segment.merge!(length: twocolors ? (len_seg * 2 + 1) : len_seg)
      end

      # L'idée est de faire des lignes de texte. Vraiment des lignes, de la
      # taille de la largeur d'une page.

      # La ligne actuelle
      self.cur_line      = ''
      self.len_cur_line  = 0

      projet.segments.each_with_index do |data_segment, index_segment|

        # Longueur actuelle de la ligne reconstituée
        # On ne peut pas prendre +cur_line+ car elle contient des marques
        # de couleur.

        # Changement de titre => nouveau document => retourn chariot
        if data_segment[:new_document_title]
          # <= ON arrive sur un nouveau document du manuscrit

          # S'il y avait une ligne courant, il faut l'enregistrer
          if len_cur_line > 0
            add_cur_line_and_reset
          end

          line_title = '--- %s' % data_segment[:new_document_title]
          if line_title.length > largeur_colonne
            line_title = line_title[0...(largeur_colonne - 4)] + '[…]'
          end
          # Ajouter le titre en tant que ligne de texte, en gris
          # page_lines <<  line_title.rgb([40,40,40])
          reste = largeur_colonne - line_title.length
          line_title = (line_title + (' ' * reste))
          page_lines << line_title.grisitalsurblanc
        end

        # Le mot courant (ou intermot, etc.)
        seg = data_segment[:seg]

        # Traitement spécial si le segment contient un retour chariot
        # Dans ce cas, il faut :
        #   1. séparer la donnée en deux segments
        #   2. mettre le début du segment dans la ligne courante
        #   3. enregistrer la ligne courante
        #   4. mettre la fin du segment (if any) dans la nouvelle
        #      ligne.
        if seg.match(/[\n\r]/)
          pseg, nseg = seg.split(/[\n\r]/)
          pseg = nil if pseg == ''
          nseg = nil if nseg == ''
          puts "pseg: #{pseg.inspect} / nseg: #{nseg.inspect}"
          cur_line << pseg.noirsurblanc
          self.len_cur_line += pseg.length
          add_cur_line_and_reset
          unless nseg.nil?
            cur_line << nseg.noirsurblanc
            self.len_cur_line += nseg.length
          end

          next # ON PASSE AU SUIVANT

        else
          added_length = data_segment[:length]
        end


        # Pour mesurer la longueur qu'aurait la ligne en ajoutant le mot
        # courant, il faut aussi considérer que le mot d'après est peut-être
        # une ponctuation ou autre qu'il faut ajouter au segment courant.
        dnext_seg = projet.segments[index_segment + 1]
        if dnext_seg && dnext_seg[:type] == :inter && dnext_seg[:seg].strip != ''
          added_length += dnext_seg[:length]
        end

        # Si en ajoutant le mot courant (seg) à la ligne courante on dépasse
        # la largeur de la page, alors on enregistre la ligne courante et on
        # la réinitialise
        if len_cur_line + added_length >= largeur_colonne
          add_cur_line_and_reset
        end

        # On ajoute toujours la longueur de ce segement qui va être ajouté
        self.len_cur_line += data_segment[:length]

        # On écrit le segment, en le traitant si c'est le mot qu'on
        # veut voir.
        self.cur_line <<
          case data_segment[:type]
          when :inter
            data_segment[:seg].noirsurblanc
          when :mot
            code_pour_mot_segment(data_segment)
          end
      end
      # Fin de boucle sur tous les mots

      # On ajoute ce qui reste
      if cur_line.length > 0
        add_cur_line_and_reset
      end

    rescue Exception => e
      raise e
    end
    # /define_lines_of_texte


    def add_cur_line_and_reset
      # Il faut ajouter les espaces au bout de la ligne pour
      # que la page apparaisse bien. Mais pour ça, on ne peut pas
      # compter la longueur de la ligne, qui contient des marques
      # de couleur. On se sert donc de +len_cur_line+
      reste_espaces = largeur_colonne - len_cur_line
      self.page_lines << (cur_line + (' ' * reste_espaces).noirsurblanc)
      self.cur_line      = ''
      self.len_cur_line  = 0
    end
    # /add_cur_line_and_reset


    # SI +strict+ est vrai, on ne double pas le mot lorsqu'il a une
    # proximité avant et arrière. Pas utilisé pour le moment.
    def code_pour_mot_segment dsegment, strict = false
      dsegment[:has_color] || (return dsegment[:seg].noirsurblanc)
      seg = dsegment[:seg]
      ecol = "\033[0m"
      pcolor = dsegment[:prev_color]
      ncolor = dsegment[:next_color]
      if pcolor && ncolor
        # Avec une proximité avant et une après
        if strict
          seg_moit = seg.length / 2
          pmoit = seg[0...seg_moit]
          nmoit = seg[seg_moit..-1]
          '%s%s%s%s%s%s' % [pcolor, pmoit, ecol, ncolor, nmoit, ecol]
        else
          '%s%s%s|%s%s%s' % [pcolor, seg, ecol, ncolor, seg, ecol]
        end
      elsif pcolor
        '%s%s%s' % [pcolor, seg, ecol]
      else
        '%s%s%s' % [ncolor, seg, ecol]
      end
    end
    # /code_pour_mot_segment

  end#/<< self
end#/Output
end #/Project
end #/Scrivener
