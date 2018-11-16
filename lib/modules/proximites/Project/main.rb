class Scrivener
  class Project

    attr_accessor :tableau_proximites

    # = main =
    #
    def exec_proximites
      CLI.dbg("-> Scrivener::Project#exec_proximites (#{Scrivener.relative_path(__FILE__,__LINE__).gris})")
      Debug.init
      output_proximites
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
      get_data_proximites || return
      # Sortie en console
      if CLI.options[:in_file]
        build_proximites_scrivener_file
      elsif CLI.options[:data]
        build_tableau_resultat_proximites
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

    # On récupère les données de proximités
    # Soit on les prend des fichiers déjà produits et enregistrés s'ils
    # existent, soient on calcule tout.
    def get_data_proximites
      CLI.dbg("-> Scrivener::Project#get_data_proximites (#{Scrivener.relative_path(__FILE__,__LINE__).gris})")
      if File.exists?(path_table_lemmatisation) && !CLI.options[:force]
        TABLE_LEMMATISATION.merge!(reload_table_lemmatisation)
      else
        prepare_lemmatisation
      end
      if File.exists?(path_proximites) && !CLI.options[:force]
        self.tableau_proximites = reload_proximites
        self.segments           = reload_segments
        CLI.options[:force_calcul] && calcul_proximites(tableau_proximites)
        return true
      else
        check_proximites
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

    # Pour sauver tout le projet
    def save
      save_proximites
      save_segments
    end

    def set_modified
      self.tableau_proximites[:modified_at] = Time.now
    end
    def modified?
      tb = self.tableau_proximites
      tb[:modified_at] && tb[:last_saved_at] < tb[:modified_at]
    end

    def save_segments
      CLI.dbg("-> Scrivener::Project#save_segments (#{Scrivener.relative_path(__FILE__,__LINE__).gris})")
      File.exists?(path_segments) && File.unlink(path_segments)
      File.open(path_segments,'wb'){|f| Marshal.dump(self.segments,f)}
    end
    def reload_segments
      CLI.dbg("-> Scrivener::Project#reload_segments (#{Scrivener.relative_path(__FILE__,__LINE__).gris})")
      File.open(path_segments,'rb'){|f| Marshal.load(f)}
    end
    def path_segments
      @path_segments ||= File.join(project.hidden_folder, 'table_segments.msh')
    end
    def save_proximites
      CLI.dbg("-> Scrivener::Project#save_proximites (#{Scrivener.relative_path(__FILE__,__LINE__).gris})")
      File.exists?(path_proximites) && File.unlink(path_proximites)
      self.tableau_proximites[:last_saved_at] = Time.now
      self.tableau_proximites[:modified_at]   = nil
      File.open(path_proximites,'wb'){|f| Marshal.dump(self.tableau_proximites,f)}
    end
    # Retourne la table des proximités
    def reload_proximites
      CLI.dbg("-> Scrivener::Project#reload_proximites (#{Scrivener.relative_path(__FILE__,__LINE__).gris})")
      File.open(path_proximites,'rb'){|f| Marshal.load(f)}
    end

    def path_proximites
      @path_proximites ||= File.join(project.hidden_folder, 'tableau_proximites.msh')
    end


  end #/Project
end #/Scrivener
