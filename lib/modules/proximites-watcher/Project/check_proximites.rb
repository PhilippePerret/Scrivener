class Scrivener
  class Project

    attr_accessor :last_tableau

    def check_etat_proximites_et_affiche_differences
      puts "---> check des proximités" # pour le moment, pour voir la boucle

      # On initialise un nouveau tableau de proximités
      new_tableau = Proximite.init_table_proximites
      self.segments = Array.new

      # Assembler le texte des trois binder-items
      assemble_texte(watched_binder_items, watch_whole_texte_path)

      # Lemmatiser et peupler la table TABLE_LEMMATISATION
      lemmatize(watch_whole_texte_path, watch_lemma_file_path)
      peuple_table_lemmatisation_from(watch_lemma_file_path)

      # On peut relever les mots dans chaque binder-item
      watched_binder_items.each do |bitem|
        bitem.releve_mots_in_texte(new_tableau)
        bitem.treate_proximite(new_tableau)
      end

      # On procède à la recherche des proximités
      Proximite.calcule_proximites_in(new_tableau)

      # On peut procéder à la comparaison (si un ancien tableau existe)
      last_tableau && Proximite.compare(new_tableau, last_tableau)

      self.last_tableau = new_tableau
    end
    # /check_etat_proximites_et_affiche_differences

  end #/Project
end #/Scrivener
