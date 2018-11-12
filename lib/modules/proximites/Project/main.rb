
TABLE_LEMMATISATION = Hash.new

class Scrivener
  class Project

    attr_accessor :tableau_proximites

    # = main =
    #
    def exec_proximites
      CLI.dbg("-> Scrivener::Project#exec_proximites (#{Scrivener.relative_path(__FILE__,__LINE__).gris})")

      Debug.init

      if CLI.options[:data]
        output_data_proximites
      else
        output_proximites
      end
    end

    # Initialisation de la table géante des proximités
    def init_tableau_proximites
      self.tableau_proximites = Hash.new
      self.tableau_proximites.merge!(
        current_offset: 0,
        mots:           Hash.new, # tous les mots
        binder_items:   Hash.new, # tous les binder-items
        project_path:   self.path,
        # Nombres
        last_id_proximite:            0,
        nombre_proximites_erased:     0,
        nombre_proximites_fixed:      0,
        nombre_proximites_ignored:    0,
        nombre_proximites_added:      0,
        # Dates
        modified_at:    nil, # ou date de dernière modification
        created_at:     Time.now,
        last_saved_at:  nil
      )
    end
    # /init_tableau_proximites

    # Méthode principale qui checke les proximités
    #
    def output_proximites
      CLI.dbg("-> Scrivener::Project#output_proximites (#{Scrivener.relative_path(__FILE__,__LINE__).gris})")
      get_data_proximites || return
      # Sortie en console
      # TODO Plus tard, il faudra pouvoir choisir entre différents types de
      # sorties
      Console.output(tableau_proximites)
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
        CLI.options[:force_calcul] && calcul_proximites(tableau_proximites)
        return true
      else

        check_proximites
      end
    end


    def check_proximites
      CLI.dbg("-> Scrivener::Project#check_proximites (#{Scrivener.relative_path(__FILE__,__LINE__).gris})")
      puts "\n\n---- Check des proximités. Merci de patienter…"

      # --- Initialisation des valeurs ---
      Proximites.traite_listes_rectifiees

      init_tableau_proximites

      binder_items.each do |bitem|
        bitem.treate_proximite(self.tableau_proximites)
      end

      # On traite les proximités
      calcul_proximites(self.tableau_proximites)

      return true
    end
    #/check_proximites

    def set_modified
      self.tableau_proximites[:modified_at] = Time.now
    end
    def modified?
      tb = self.tableau_proximites
      tb[:modified_at] && tb[:last_saved_at] < tb[:modified_at]
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
