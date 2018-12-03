class Scrivener
  class Project

    attr_accessor :watched_binder_item_uuid

    attr_accessor :tableau_proximites

    # = main =
    #
    # Méthode qui reçoit dans tous les cas la commande `scriv prox `
    def exec_proximites
      CLI.dbg("-> Scrivener::Project#exec_proximites (#{Scrivener.relative_path(__FILE__,__LINE__).gris})")
      Debug.init
      if CLI.params.key?(:abbreviations)
        Proximite.open_file_abbreviations
      elsif CLI.params.key?(:mot)
        # => Il faut n'afficher que la proximité d'un mot
        Scrivener.require_module('prox/one_word')
        exec_proximites_one_word
      elsif CLI.params.key?(:doc) || CLI.params.key?(:idoc)
        # => Il ne faut afficher que la proximité d'un document
        Scrivener.require_module('prox/one_doc')
        exec_proximites_one_doc
      elsif CLI.options[:maxtomin] || CLI.options[:mintomax]
        Scrivener.require_module('prox/max_to_min')
        exec_max_to_min
      else
        # Sinon, c'est l'affichage de toutes les proximités
        if CLI.options[:data] || self.ask_for_fermeture
          output_proximites
        else
          puts ' Abandon…'.rouge
        end
      end
    end

    def init_proximites
      # --- Initialisation des valeurs ---
      # Prépare les listes constantes du programme aussi bien que les
      # listes propres au projet.
      Proximite.init
      init_tableau_proximites
      init_tableau_segments
    end

    # Initialisation de la table géante des proximités
    def init_tableau_proximites
      self.tableau_proximites = Proximite.init_table_proximites
    end
    # /init_tableau_proximites

    def init_tableau_segments # project.segments
      self.segments = Array.new
    end

    # Appelle la méthode pour traiter les proximités de mots
    # +tableau+ Tableau de résultats ou se trouve déjà les mots, et peut-être
    # aussi les proximites
    def calcul_proximites(tableau)
      CLI.dbg("-> Scrivener::Project#calcul_proximites (#{Scrivener.relative_path(__FILE__,__LINE__).gris})")
      self.tableau_proximites = Proximite.calcule_proximites_in(tableau)
      # On enregistre les résultats dans un fichier
      save_proximites
    end

    # Méthode principale qui checke les proximités
    #
    def output_proximites
      CLI.dbg("-> Scrivener::Project#output_proximites (#{Scrivener.relative_path(__FILE__,__LINE__).gris})")
      Scrivener.require_module('lib/proximites/common')
      get_data_proximites || return
      # Sortie en console
      if CLI.options[:in_file]
        build_proximites_scrivener_file
      elsif CLI.options[:data]
        build_and_display_tableau_resultat_proximites
      elsif CLI.options[:only_calculs]
        something_is_displayed = false
        if CLI.options[:segments]
          # LAISSER CES puts ! Ils font partie du programme
          puts "\n\n\n---- SEGMENTS: \n#{segments.inspect}"
          something_is_displayed = true
        end
        if CLI.options[:proximites]
          # LAISSER CES puts ! Ils font partie du programme
          puts "\n\n\n---- PROXIMITÉS: "
          something_is_displayed = true
        end
        something_is_displayed || puts("Avec --only_calculs, il faut ajouter une option pour voir une liste (--segments, --proximites, etc.)".rouge)
      else
        Console.output(tableau_proximites)
      end
    end


    def check_proximites
      CLI.dbg("-> Scrivener::Project#check_proximites (#{Scrivener.relative_path(__FILE__,__LINE__).gris})")

      # Initialisation, des listes principalement
      init_proximites

      # On procède à la relève
      binder_items.each do |bitem|
        bitem.treate_proximite(self.tableau_proximites)
      end

      # On peut sauver la liste des segments textuels du projet
      save_segments
      # Note : les proximités seront sauvées après leur calcul.

      # On traite les proximités
      calcul_proximites(self.tableau_proximites)

      return true
    end
    #/check_proximites

  end #/Project
end #/Scrivener
