class ProxMot

  # L'expression réelle, telle que fournie par le texte
  attr_accessor :real
  attr_accessor :offset
  attr_accessor :binder_item_uuid # UUID du binder-item contenant le mot

  def initialize real_mot, offset, binder_item_uuid
    self.offset = offset
    self.real   = real_mot
    self.binder_item_uuid = binder_item_uuid
  end

  def downcase
    @downcase ||= real.downcase # pour le moment
  end

  # Forme canonique du mot (lemmatisé). Par exemple, "marcherions" aura
  # comme forme canonique "marcher"
  def canonique
    @canonique ||= (TABLE_LEMMATISATION[downcase] || real).downcase
  end

  # Retourne true si le mot est traitable
  # Pour le moment, pour qu'un mot soit traitable, il faut :
  #   - que ce soit vraiment un mot
  #   - que sa longueur soit de au moins 2 caractères
  def treatable?
    @is_treatable ||= !real.start_with?('T_') && real_mot? && canonique.length > 2
  end

  def real_mot?
    @is_real_mot ||= !!downcase.match(/[a-zA-Zçàô]/)
  end

  def length
    @length ||= real.length
  end

  # Retourne TRUE si le mot courant est trop proche du mot +imot+ {ProxMot} qui
  # se trouve (toujours pour le moment) avant le mot.
  def trop_proche_de? imot
    self.offset - imot.offset < distance_minimale
  end

  def distance_minimale
    if Proximites::PROXIMITES_MAX[:mots].key?(canonique)
      Proximites::PROXIMITES_MAX[:mots][canonique]
    else
      DISTANCE_MINIMALE
    end
  end

end
