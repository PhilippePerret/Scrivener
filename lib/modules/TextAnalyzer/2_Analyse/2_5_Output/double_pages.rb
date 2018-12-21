=begin

  Module pour construire l'affichage des proximités en double page

=end
class TextAnalyzer
class Analyse
class TableResultats
class Output
class Proximite

  TABV          = '  ' # Pour "TABulation Vierge"
  TAB           = '  '.noirsurblanc
  ENDCOLOR      = "\033[0m"
  # Hauteur d'une page artificielle à l'écran
  HAUTEUR_PAGE  = 20 # lignes

  # Les éléments graphiques qui seront calculés en fonction de l'écran et
  # autre.
  GRAPH = {
    white_line:     nil,
    dbl_white_line: nil
  }

  attr_accessor :projet
  attr_accessor :table

  # Instance (quelconque) de l'objet dont il faut afficher les proximités.
  # Ce peut être un mot, un document ou un Binder-item (Scrivener)
  attr_accessor :objet

  # Instance ProxMot du mot dont il faut voir les proximités (if any)
  # TODO À mettre dans un objet plus quelconque, maintenant que TextAnalyzer
  # est détaché de Scrivener
  attr_accessor :proxmot

  # Instance BinderItem du binder-item dont il faut voir les proximités
  # (if any)
  # TODO À mettre dans un objet plus quelconque, maintenant que TextAnalyzer
  # est détaché de Scrivener
  attr_accessor :binder_item

  # Liste des lignes à afficher.
  # Calculées pour faire une largeur maximale de :largeur_colonne, avec
  # des mots qui peuvent être doublés et colorés.
  attr_accessor :page_lines

  # = main =
  # Appelé par Scrivener::Project.affiche_proximites_en_deux_pages pour
  # afficher les proximités d'un élément sur deux pages artificielles en
  # console.
  #
  # +objet+     Objet dont on veut voir la ou les proximités. Ça peut être :
  #               - un ProxMot : un mot dont on veut voir la proximité
  #               - un BinderItem : un document dont on veut afficher toutes
  #                 les proximités.
  #
  # Note que le "filtrage" se fait avant, en fait. Ici, la valeur de
  # 'iprojet.analyse.table_resultats' ne doit contenir que les proximités qui
  # intéressent l'affichage et aucune autre.
  #
  def affiche_en_deux_pages objet
    self.objet = objet

    case objet
    when ProxMot
      self.proxmot = objet
    when Scrivener::Project::BinderItem
      self.binder_item = objet
    else
      raise ERRORS_MSGS[:unproximable_objet] % objet.class.inspect
    end

    init_graph
    define_lines_of_texte
    finalise_lines_of_pages
    display_lines_of_texte

  end


  def init_graph
    GRAPH[:white_line] = TABV + TAB * 2 + (' ' * largeur_colonne).grisitalsurblanc
    GRAPH[:dbl_white_line] = GRAPH[:white_line] * 2
  end

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
    puts String::RC * 10

    # On affiche tout par petite pages virtuelles de HAUTEUR_PAGE hauteur
    until page_lines.empty?
      left_lines  = page_lines.slice!(0, HAUTEUR_PAGE)
      right_lines = page_lines.slice!(0, HAUTEUR_PAGE)
      puts GRAPH[:dbl_white_line]
      while left_line = left_lines.shift
        right_line = right_lines.shift || GRAPH[:white_line]
        puts left_line + right_line
      end
      puts GRAPH[:dbl_white_line]
      puts String::RC
    end

    puts String::RC * 3
  end
  # /display_lines_of_texte

  # Pour finaliser les lignes, en ajoutant les espaces nécessaires à un
  # affichage correcte
  def finalise_lines_of_pages
    self.page_lines = page_lines.collect { |line| TABV + TAB + line + TAB }
  end
  # /finalise_lines_of_pages

  # Retourne la liste des proximités à traiter en fonction
  # du type de l'objet transmis à la méthode
  def proximites
    @proximites ||= begin
      case objet
      when ProxMot
        data_mot = table[:mots][proxmot.canon]
        data_mot[:proximites]
      when Scrivener::Project::BinderItem
        # table[:proximites].values
        # Ici, plutôt que d'envoyer la liste des proximités, on va envoyer
        # la liste des listes de proximités regroupés par mot canonique. De
        # cette manière, les mêmes mots seront colorisés de la même couleur
        table[:mots].collect do |canon, data_canon|
          data_canon[:proximites].empty? && next
          data_canon[:proximites]
        end.compact
      end
    end
  end

  attr_accessor :cur_line     # ligne de texte courante (en traitement)
  attr_accessor :len_cur_line # longeur de la ligne courante

  # Méthode qui définit les lignes de texte en fonction des proximités, en
  # les calculant pour qu'elles tiennent dans des colonnes de largeur
  # `largeur_colonne`
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



    # Si aucune proximité n'a été trouvée, on peut s'en retourner
    proximites.count > 0 || begin
      puts ERRORS_MSGS[:no_proximites].bleu
      return nil
    end


    # On ajoute les couleurs aux segments
    # Avec le format de couleur :console, il sera ajouté au segment d'un
    # mot en proximité la propriété :prev_color et/ou :next_color qui sera
    # l'amorce d'une marque de couleur dans la console, c'est-à-dire
    # quelque chose comme `\033[38;5;34m`.
    # Il faudra donc ajouter `\033[0m` après le mot, ce dont s'occupe
    # la méthode `displayed_code_segment` ci-dessous.
    projet.define_word_colors_in_segments(proximites, {color_format: :console})


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
      # TODO Maintenant, ça ne fonctionne plus comme ça, il faut relever
      # l'offset des documents
      if data_segment[:new_document_title]
        # <= ON arrive sur un nouveau document du manuscrit

        # S'il y avait une ligne courant, il faut l'enregistrer
        if len_cur_line > 0
          add_cur_line_and_reset
        end

        # TODO Cf. ci-dessus
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

      # On écrit le segment, en le traitant si c'est un mot en
      # proximité
      self.cur_line << displayed_code_segment(data_segment)

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

  # Ajoute la ligne courante à la liste des lignes et ré-initialise
  # une nouvelle ligne.
  #
  # Note : des espaces blancs sont ajoutés en fin de ligne pour qu'elle
  # aille jusqu'au bout de la colonne.
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
  #
  # Noter qu'ici passent aussi bien les segments de type :mot que les
  # autres (type :inter)
  def displayed_code_segment dsegment, strict = false
    dsegment[:has_color] || (return dsegment[:seg].noirsurblanc)
    seg = dsegment[:seg]
    pcolor = dsegment[:prev_color]
    ncolor = dsegment[:next_color]
    if pcolor && ncolor
      # Avec une proximité avant et une après
      # EN mode 'strict', on ne double pas le mot (mot|mot), on le coupe
      # en deux pour donner à chaque moitié une couleur.
      if strict
        seg_moit = seg.length / 2
        pmoit = seg[0...seg_moit]
        nmoit = seg[seg_moit..-1]
        '%s%s%s%s%s%s' % [pcolor, pmoit, ENDCOLOR, ncolor, nmoit, ENDCOLOR]
      else
        '%s%s%s|%s%s%s' % [pcolor, seg, ENDCOLOR, ncolor, seg, ENDCOLOR]
      end
    elsif pcolor
      '%s%s%s' % [pcolor, seg, ENDCOLOR]
    else
      '%s%s%s' % [ncolor, seg, ENDCOLOR]
    end
  end
  # /code_pour_mot_segment


  # ---------------------------------------------------------------------
  #   MÉTHODES DE DIMENSION

  def nombre_colonnes
    @nombre_colonnes ||= `tput cols`.to_i
  end
  def nombre_lignes
    @nombre_lignes ||= `tput lines`.to_i
  end

  # Largeur de la colonne
  def largeur_colonne
    @largeur_colonne ||= (nombre_colonnes / 2) - 8
    # 8 pour une gouttière de 4 et des marges de 2
  end

  def hauteur_page
    @hauteur_page ||= nombre_lignes - hauteur_footer
  end

  def hauteur_footer
    @hauteur_footer ||= 5
  end

end #/Proximite
end #/Output
end #/TableResultats
end #/Analyse
end #/TextAnalyzer
