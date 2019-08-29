# encoding: UTF-8
=begin


=end
class Scrivener
class Project
  attr_accessor :tdm
  def tdm
    @tdm ||= TDM.new(self)
  end

  class TDM

    NOMBRE_SIGNES_PER_PAGE  = 1750
    TITLE_IDENTATION        = '  '

    attr_accessor :projet

    # {Array} des éléments de la table des matières
    # Chaque item est une instance {BinderItem}
    attr_accessor :elements

    # L'objectif général (pour correspondre à la même propriété dans les
    # binder-item)
    attr_accessor :objectif

    # {Symbol} Sortie de la table des matières
    # :console, :html, :file, :scrivener
    attr_accessor :output

    # {SWP} Pour gérer la taille de la table des matières (pour correspondre
    # avec la même propriété dans les binder-items)
    attr_accessor :size

    # {SWP} Pour suivre l'avancée de la pagination
    attr_accessor :current_size, :current_objectif

    # {Array of String} Toutes les lignes qu'il faut écrire dans la
    # table des matières finale.
    attr_accessor :lines

    # Pour que l'affichage de la table des matières avec pagination soit
    # optimisée.
    attr_accessor :title_width
    # Largeur pour un numéro de page (écrite)
    attr_accessor :wri_page_number_width

    # {Integer} Numéro de la dernière page (écrite)
    attr_accessor :wri_last_page_number

    def initialize iprojet
      self.projet = iprojet
    end

    # Pour ouvrir la table des matières, en HTML ou en fichier Simple text
    # (avec l'option `--open`)
    def open
      `open "#{tdm_file_path}"`
    end

    # Avant de commencer l'opération de mise en table des matières,
    # on doit définir les éléments.
    # On va mettre dans self.elements les éléments de la table des matières,
    # par imbrication.
    def define_elements
      self.elements = Array.new
      self.size     = SWP.new(0)
      self.objectif = SWP.new(0)
      projet.all_binder_items_of(:draft_folder, deep: false).each do |bitem|
        bitem.treate_as_tdm_item(self, self)
      end
    end
    #/define_elements


    # Largeur pour un numéro de page (objectif)
    def obj_page_number_width
      @obj_page_number_width ||= obj_last_page_number.to_s.length
    end
    # {Finum} Numéro de la dernière page (suivant les objectifs)
    def obj_last_page_number
      @obj_last_page_number ||= self.objectif.page
    end
    # Largeur pour un numéro de page (objectif)
    def wri_page_number_width
      @wri_page_number_width ||= wri_last_page_number.to_s.length
    end
    # {Finum} Numéro de la dernière page (suivant les objectifs)
    def wri_last_page_number
      @wri_last_page_number ||= self.size.page
    end
    # La plus grande largeur pour l'indication des objectifs en
    # nombre de caractères (signes). Calculé d'après les pages
    def obj_chars_count_width
      @obj_chars_count_width ||= begin
        (obj_last_page_number * String::PAGE_WIDTH.to_i).to_s.length
      end
    end
    def wri_chars_count_width
      @wri_chars_count_width ||= (wri_last_page_number * String::PAGE_WIDTH).to_s.length
    end


    # Méthode qui définit les mesures à utiliser, à savoir :
    #   * la largeur max pour le titre
    #   * la largeur max pour le nombre de pages (objectif et écrites)
    #   * la largeur max pour le nombre de signes, pages, etc.
    #
    def define_mesures
      self.title_width = 0
      self.elements.each do |bitem|
        bitem.build_formated_title(self, indentation = 1)
      end
      self.title_width >= 42 || self.title_width = 42
    end
    #/define_mesures

    # = main =
    #
    # Construction de la table des matières (en fonction du format
    # de sortie). Appelée par le projet au tout départ pour construire
    # la table.
    #
    def build_table_of_content
      define_elements
      verbose_line(t('count.elements'), elements.count)
      define_mesures
      [
        :title_width, :obj_page_number_width, :obj_last_page_number,
        :wri_last_page_number, :wri_page_number_width,
        :wri_chars_count_width, :obj_chars_count_width
      ].each do |prop|
        verbose_line(prop.inspect, send(prop).inspect)
      end
      self.lines = Array.new
      add_lines_titre
      self.current_size     = SWP.new(0)
      self.current_objectif = SWP.new(0)
      self.elements.each do |bitem|
        bitem.add_ligne_pagination()
      end
    end
    #/build_table_of_content

    def verbose_line libelle, valeur
      CLI.verbose? || return
      puts '-- %s : %s' % [libelle.to_s.ljust(28), valeur]
    end

  end #/TDM
end #/Project
end #/Scrivener
