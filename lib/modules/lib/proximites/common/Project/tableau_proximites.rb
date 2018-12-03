=begin

  Module gérant de façon commune les données du tableau de proximités
  à commencer par la méthode qui charge le dernier tableau enregistré
  pour le projet courant.

=end
class Scrivener
  class Project

    # Recharge :
    #   - La table de lemmatisation
    #   - la table des proximités
    #   - la liste de tous les segments
    def reload_all_data_project
      TABLE_LEMMATISATION.merge!(reload_table_lemmatisation)
      self.tableau_proximites = reload_proximites
      self.segments           = reload_segments
    end

    # Retourne la table des proximités
    def reload_proximites
      CLI.dbg("-> Scrivener::Project#reload_proximites (#{Scrivener.relative_path(__FILE__,__LINE__).gris})")
      File.open(path_proximites,'rb'){|f| Marshal.load(f)}
    end

  end #/Project
end #/Scrivener
