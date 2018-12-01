class Scrivener
  class Project

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


  end #/Project
end #/Scrivener
