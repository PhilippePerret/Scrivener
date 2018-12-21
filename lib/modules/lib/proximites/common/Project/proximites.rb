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
  # Retourne la table des résultats de l'analyse
  def check_proximites_in_watched_binder_items
    paths = create_binder_items_text_files(self.watched_binder_items)
    @analyse = nil # Pour forcer une nouvelle analyse
    analyse.exec(paths)
  end
  # /check_proximites_in_watched_binder_items

end #/Project
end #/Scrivener
