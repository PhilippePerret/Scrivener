class Proximite

  attr_accessor :id

  # Instances {ProxMot}
  attr_accessor :mot_avant
  attr_accessor :mot_apres

  # Pour indiquer que cette proximité a été corrigée, supprimée ou ignorée
  attr_accessor :fixed, :erased, :ignored

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

  def fixed?
    self.fixed == true
  end
  def erased?
    self.erased == true
  end

  def destroy
    self.erased = true
    self.mot_avant.proximite_apres= nil
    self.mot_apres.proximite_avant= nil
    project.tableau_proximites[:proximites].delete(self.id)
    project.tableau_proximites[:nombre_proximites_erased] += 1
    project.tableau_proximited[:modified_at] = Time.now
  end

end #/Proximite
