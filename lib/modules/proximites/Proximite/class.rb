class Proximite
class << self

  # Création d'une proximité nouvelle entre le mot +mot_avant+ et
  # le mot +mot_apres+ dans le projet +projet+
  def create iproj, mot_avant, mot_apres
    iproj.tableau_proximites[:last_id_proximite] += 1
    new_prox_id = iproj.tableau_proximites[:last_id_proximite].to_i
    canon       = mot_avant.canonique

    tb_proximites = iproj.tableau_proximites[:proximites]
    tb_proxs_mot  = iproj.tableau_proximites[:mots][canon][:proximites]

    new_prox = new(new_prox_id, mot_avant, mot_apres)
    # On associe les mots à leur proximité
    mot_avant.proximite_apres= new_prox
    mot_apres.proximite_avant= new_prox
    # On met dans la liste
    # iproj.tableau_proximites[:proximites].merge!(new_prox.id => new_prox)
    tb_proximites.merge!(new_prox.id => new_prox)

    # On met la nouvelle proximité dans la liste des proximités du mot
    # canonique, en la plaçant en fonction de son offset.
    last_prox_id  = tb_proxs_mot.last
    last_prox     = last_prox_id ? tb_proximites[last_prox_id] : nil

    debug('= Liste des IDs de proximités du mot «%s» AVANT : %s' %
      [canon, iproj.tableau_proximites[:mots][canon][:proximites].inspect])

    if last_prox.nil? || mot_avant.offset > last_prox.mot_avant.offset
      # <= Il n'y a pas de dernière proximité, ou l'offset du mot de la
      #    nouvelle proximité est supérieure à l'offset du premier mot
      #    de la dernière proximité.
      # => On met l'ID à la fin.
      # iproj.tableau_proximites[:mots][canon][:proximites] << new_prox_id
      tb_proxs_mot << new_prox_id
    else
      # <= La proximité se trouve avant ou après une autre proximité
      # => Il faut chercher l'emplacement de la nouvelle proximité.
      indexin = -1
      tb_proxs_mot.each_with_index do |pid, indexp|
        if mot_avant.offset < tb_proximites[pid].mot_avant.offset
          indexin = indexp
          break
        end
      end
      # iproj.tableau_proximites[:mots][canon][:proximites].insert(indexin, new_prox_id)
      tb_proxs_mot.insert(indexin, new_prox_id)
    end

    debug('= Liste des IDs de proximités du mot «%s» APRÈS : %s' %
      [canon, iproj.tableau_proximites[:mots][canon][:proximites].inspect])

    # On retourne la nouvelle proximité créée
    return new_prox
  end

end #/ << self
end #/Proximite
