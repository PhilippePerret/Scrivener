# encoding: UTF-8
=begin
  Pour gérer l'affichage de proximité en proxmité
=end
class Scrivener
class Project
class Console

  POINTEURS = Hash.new

class << self

  def mot_canonique_at(indice)
    POINTEURS[:mots_canoniques][indice]
  end
  # Retourne true si un mot canonique existe à la position 0-start +indice+
  def mot_canonique_at_exists? indice
    !mot_canonique_at(indice).nil?
  end


  def update_pointeurs
    POINTEURS.merge!(
      liste_mots: project.tableau_proximites[:mots]
    )
    POINTEURS.merge!(
      mots_canoniques: POINTEURS[:liste_mots].keys
    )
    POINTEURS.merge!(
      nombre_mots: POINTEURS[:mots_canoniques].count
    )
  end

  def init_pointeurs
    update_pointeurs
    POINTEURS.merge!(
      mot:    0,
      prox:   nil,
      nombre_proximites_mot: nil
    )
  end

  # Retourne la proximité courante correspondant au pointeur, donc
  # à l'index du mot canonique et l'index de la proximité
  def get_proximite_courante
    prox_id = POINTEURS[:data_canonique][:proximites][POINTEURS[:prox]]
    project.analyse.table_resultats.proximites[prox_id]
  end

  def pointe_premier_mot_avec_proximites
    POINTEURS[:mot] = -1
    cherche_mot_suivant_avec_proximites
  end

  # +return TRUE si un mot a pu être trouvé,
  #         FALSE dans le cas contraire
  def cherche_mot_suivant_avec_proximites
    index_suivant     = POINTEURS[:mot] + 1
    index_dernier_mot = POINTEURS[:nombre_mots] - 1
    (index_suivant..index_dernier_mot).each do |index_tested|
      if mot_canonique_at_avec_proximites?(index_tested)
        reset_pointeurs_pour_mot_at(index_tested)
        return true # pour indiquer qu'on l'a trouvé
      end
    end
    return false
  end

  # +Return TRUE si un mot précédent avec des proximités a été trouvé
  #         FALSE dans le cas contraire
  def cherche_mot_precedent_avec_proximites commence_par_last_prox = false
    index_mot_precedent = POINTEURS[:mot] - 1
    (0..index_mot_precedent).each do |sous|
      index_tested = index_mot_precedent - sous
      if mot_canonique_at_avec_proximites?(index_tested)
        reset_pointeurs_pour_mot_at(index_tested, commence_par_last_prox)
        return true # pour indiquer qu'on l'a trouvé
      end
    end
    return false # pour indique qu'on ne l'a pas trouvé
  end

  # Renvoie TRUE si le mot d'index +index_tested+ possède des
  # proximités.
  def mot_canonique_at_avec_proximites?(index_tested)
    canon = POINTEURS[:mots_canoniques][index_tested]
    POINTEURS[:liste_mots][canon][:proximites].count > 0
  end


  # Reset les pointeurs pour un nouveau mot (le plus couramment : le mot
  # suivant).
  def reset_pointeurs_pour_mot_at index, from_last_prox = false
    canon = POINTEURS[:mots_canoniques][index]
    POINTEURS.merge!(
      mot_canonique:          canon,
      mot:                    index,
      data_canonique:         POINTEURS[:liste_mots][canon],
      data_mots:              POINTEURS[:liste_mots][canon][:items],
      nombre_proximites_mot:  POINTEURS[:liste_mots][canon][:proximites].count
    )
    POINTEURS.merge!(
      prox: from_last_prox ? POINTEURS[:nombre_proximites_mot] - 1 : 0
    )
  end

end #/self
end #/Console
end #/Project
end #/Scrivener
