class ProxMot

  # Note : les arguments sont devenus facultatifs (sauf le premier) pour
  # pouvoir instancier un mot quelconque et obtenir sa valeur canonique, comme
  # c'est le cas par exemple lorsque l'on veut voir les proximités d'un unique
  # mot.
  def initialize real_mot, offset = nil, index = nil, binder_item_uuid = nil
    self.offset     = offset
    self.index      = index
    self.real       = real_mot
    self.real_init  = real_mot.freeze
    self.binder_item_uuid = binder_item_uuid
  end

  # ---------------------------------------------------------------------

  # Retourne true si le mot est traitable
  # Pour le moment, pour qu'un mot soit traitable, il faut :
  #   - que ce soit vraiment un mot
  #   - que sa longueur soit de au moins 2 caractères
  def treatable?
    @is_treatable ||= !real.start_with?('T_') && real_mot? && canonique.length > 2
  end

  def proximite_avant= iprox
    self.proximite_avant_id =
      if iprox.nil?
        nil
      else
        iprox.id
      end
  end
  def proximite_apres= iprox
    self.proximite_apres_id =
      if iprox.nil?
        nil
      else
        iprox.id
      end
  end

  # Retourne TRUE si le mot courant est trop proche du mot +imot+ {ProxMot} qui
  # se trouve (toujours pour le moment) avant le mot.
  def trop_proche_de? imot
    self.offset - imot.offset < distance_minimale
  end
end
