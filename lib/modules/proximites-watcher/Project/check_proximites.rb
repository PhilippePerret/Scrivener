class Scrivener
  class Project

    attr_accessor :last_tableau

    def check_etat_proximites_et_affiche_differences
      CLI.dbg("-> Scrivener::Project#check_etat_proximites_et_affiche_differences (#{Scrivener.relative_path(__FILE__,__LINE__).gris})")
      # puts "* check proximités…" # pour le moment, pour voir la boucle
      write_log('* check proximités…', :gris_clair, init = true)

      # On initialise un nouveau tableau de proximités
      new_tableau = Proximite.init_table_proximites
      # puts "-- new_tableau : #{new_tableau[:proximites].keys}"
      self.segments = Array.new

      # Assembler le texte des trois binder-items
      assemble_texte(watched_binder_items, watch_whole_texte_path)

      # Lemmatiser et peupler la table TABLE_LEMMATISATION
      lemmatize(watch_whole_texte_path, watch_lemma_file_path)
      peuple_table_lemmatisation_from(watch_lemma_file_path)

      # On peut relever les mots dans chaque binder-item
      watched_binder_items.each do |bitem|
        bitem.releve_mots_in_texte(new_tableau)
      end

      # On procède à la recherche des proximités
      Proximite.calcule_proximites_in(new_tableau)

      # On peut procéder à la comparaison (si un ancien tableau existe)
      msgs_modification = Proximite.compare_tables(new_tableau, load_last_tableau)
      # On actualise le tableau
      self.tableau_proximites = new_tableau
      output_tableau_etat(msgs_modification)

      save_new_tableau(new_tableau)

      CLI.dbg("<--- Scrivener::Project#check_etat_proximites_et_affiche_differences (#{Scrivener.relative_path(__FILE__,__LINE__).gris})")
    rescue Exception => e
      raise_by_mode(e, Scrivener.mode)
    end
    # /check_etat_proximites_et_affiche_differences


    def save_new_tableau tableau
      File.open(last_tableau_path,'wb'){|f| Marshal.dump(tableau, f)}
    end
    def load_last_tableau
      File.exists?(last_tableau_path) || return
      File.open(last_tableau_path,'rb'){|f| Marshal.load(f)}
    end
    def last_tableau_path
      @last_tableau_path ||= File.join(hidden_folder, 'last_tableau_prox.msh')
    end
  end #/Project
end #/Scrivener
