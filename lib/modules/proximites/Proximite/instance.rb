class Proximite

  attr_accessor :id
  # Instances {ProxMot}
  attr_accessor :mot_avant
  attr_accessor :mot_apres

  def initialize id, prevm, nextm
    self.id = id
    self.mot_avant = prevm
    self.mot_apres = nextm
  end

  # Distance entre les deux mots
  def distance
    @distance ||= mot_apres.offset - mot_avant.offset
  end

  # Retourne TRUE si les deux mots sont dans le même binder-item
  def in_same_file?
    @mot_are_in_same_file ||= mot_apres.binder_item == mot_avant.binder_item
  end
end #/Proximite
