class ProxMot

  # L'expression réelle, telle que fournie par le texte
  attr_accessor :real
  attr_accessor :offset
  attr_accessor :binder_item_uuid # UUID du binder-item contenant le mot
  attr_accessor :index # index dans le texte total (aka dans project.segments)

  # Identifiant de la proximité du mot avec un mot avant ou après
  # La propriété volatile `proximite_avant|apres` permet de la retrouver
  # `proximite_avant` désigne la proximité qu'entretient le mot avec un
  # mot avant dans le texte. `proximite_apres` désigne la proximité qu'entre-
  # tient le mot avec un mot après dans le texte.
  attr_accessor :proximite_avant_id, :proximite_apres_id

  # Lorsqu'il est corrigé, le mot est remplacé par son nouveau mot, dans `real`
  # On conserve toujours le mot initial
  attr_accessor :init_real

  def initialize real_mot, offset, index, binder_item_uuid
    self.offset     = offset
    self.index      = index
    self.real       = real_mot
    self.init_real  = real_mot.freeze
    self.binder_item_uuid = binder_item_uuid
  end

  # Redéfinition
  def inspect
    return '<<ProxMot(mon inspect) @index=%i @offset=%i @real=%s @binder_item_uuid=%s, @proximite_avant_id=%s @proximite_apres_id=%s @length=%i>>' %
      [self.index, self.offset, self.real, self.binder_item_uuid,
      self.proximite_avant_id.inspect, self.proximite_apres_id.inspect, self.length]
  end

  def reset
    self.real   = nil
    [:downcase, :canonique, :length, :is_treatable, :is_real_mot, :distance_minimale
    ].each do |prop|
      self.instance_variable_set("@#{prop}", nil)
    end
  end

  def downcase
    @downcase ||= real.downcase # pour le moment
  end

  # Forme canonique du mot (lemmatisé). Par exemple, "marcherions" aura
  # comme forme canonique "marcher"
  def canonique
    @canonique ||= (TABLE_LEMMATISATION[downcase] || real).downcase
  end

  # ---------------------------------------------------------------------

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

  def proximite_avant
    @proximite_avant ||= begin
      project.tableau_proximites[:proximites][proximite_avant_id]
    end
  end
  def proximite_apres
    @proximite_apres ||= begin
      project.tableau_proximites[:proximites][proximite_apres_id]
    end
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

  def distance_minimale
    @distance_minimale ||= begin
      if Proximites::PROXIMITES_MAX[:mots].key?(canonique)
        Proximites::PROXIMITES_MAX[:mots][canonique]
      else
        DISTANCE_MINIMALE
      end
    end
  end

end
