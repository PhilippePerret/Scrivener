class Proximite
class << self

  # Création d'une proximité nouvelle entre le mot +mot_avant+ et
  # le mot +mot_apres+ dans le projet +projet+
  def create iproj, mot_avant, mot_apres
    iproj.tableau_proximites[:last_id_proximite] += 1
    new_prox_id = iproj.tableau_proximites[:last_id_proximite].to_i

    new_prox = new(new_prox_id, mot_avant, mot_apres)
    # On associe les mots à leur proximité
    mot_avant.proximite_apres= new_prox
    mot_apres.proximite_avant= new_prox
    # On met dans la liste
    iproj.tableau_proximites[:proximites].merge!(new_prox.id => new_prox)
    # TODO IL FAUT METTRE L'ID DE LA PROXIMITÉ DANS LA LISTE DES PROXIMITÉS DU MOT
    # CANONIQUE
    # TODO VOIR COMMENT RECALCULER LES POINTEURS DE MOTS ET DE PROXIMITÉ EN
    # FONCTION DE CES CHANGEMENTS.
    # On retourne la nouvelle proximité créée
    return new_prox
  end

end #/ << self
end #/Proximite
