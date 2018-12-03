class Scrivener
  class Project

    attr_accessor :last_tableau
    attr_accessor :tables_comparaison

    def check_etat_proximites_et_affiche_differences
      CLI.dbg("-> Scrivener::Project#check_etat_proximites_et_affiche_differences (#{Scrivener.relative_path(__FILE__,__LINE__).gris})")

      # Écrit un message d'attente à l'écran
      write_log('* check proximités…', :gris_clair, init = true)
      new_tableau = check_proximites_in_watched_binder_items

      # On peut procéder à la comparaison (si un ancien tableau existe)
      Proximite.compare_tables(new_tableau, load_last_tableau_or_default)

      # On sauve la nouvelle table des proximités
      self.tableau_proximites = new_tableau
      save_new_tableau(self.tableau_proximites.merge!(watched_document_title: self.watched_document_title))

      # Affichage à l'écran de l'état des proximités
      output_tableau_etat()
      tables_comparaison.display_changes_in(winlog)

      CLI.dbg("<--- Scrivener::Project#check_etat_proximites_et_affiche_differences (#{Scrivener.relative_path(__FILE__,__LINE__).gris})")
    rescue Exception => e
      raise_by_mode(e, Scrivener.mode)
    end
    # /check_etat_proximites_et_affiche_differences


    def save_new_tableau tableau
      File.open(last_tableau_path,'wb'){|f| Marshal.dump(tableau, f)}
    end
    # Retourne soit le dernier tableau d'analyse des proximités s'il existe
    # et s'il correspond au document analysés, ou un tableau par défaut, vide
    def load_last_tableau_or_default
      if File.exists?(last_tableau_path)
        tbl = load_last_tableau
        if tbl && tbl[:watched_document_title] == self.watched_document_title
          return tbl
        end
      end
      return table_par_default
    end
    def table_par_default
      @table_par_default ||= {mots: Hash.new, proximites: Hash.new}
    end
    def load_last_tableau
      File.open(last_tableau_path,'rb'){|f| Marshal.load(f)}
    end
    def last_tableau_path
      @last_tableau_path ||= File.join(hidden_folder, 'last_tableau_prox.msh')
    end
  end #/Project
end #/Scrivener