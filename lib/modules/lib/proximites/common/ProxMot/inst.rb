class ProxMot

  # SURCLASSEMENT
  # -------------
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
    self.class.add(self) # il faut charger le module 'lib_proximites'
  end

end
