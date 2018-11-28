=begin
  Modules communs pour trouver les proximités
=end
class Scrivener
  class Project

    # Grande méthode qui prend les binder-items surveillés (ou choisis) et
    # traite les proximités.
    # Noter que la méthode est utilisé pour watch-prox aussi bien que pour
    # l'affichage des proximités d'un mot unique. Mais comme on ne considère
    # ici que les binder-items "autour", donc à peu près 3 pages, ça va
    # assez vite.
    #
    # Retourne la table des proximités, qui peut être mise par exemple dans
    # self.tableau_proximites
    def check_proximites_in_watched_binder_items
      # On initialise un nouveau tableau de proximités
      new_tableau = Proximite.init_table_proximites
      # puts "-- new_tableau : #{new_tableau[:proximites].keys}"
      self.segments = Array.new
      # Assembler le texte des binder-items
      assemble_texte(self.watched_binder_items, watch_whole_texte_path)
      # Lemmatiser et peupler la table TABLE_LEMMATISATION
      lemmatize(watch_whole_texte_path, watch_lemma_file_path)
      peuple_table_lemmatisation_from(watch_lemma_file_path)
      # On peut relever les mots dans chaque binder-item
      self.watched_binder_items.each do |bitem|
        bitem.releve_mots_in_texte(new_tableau)
      end
      Proximite.calcule_proximites_in(new_tableau)
      return new_tableau
    end
    # /check_proximites_in_watched_binder_items

  end #/Project
end #/Scrivener
