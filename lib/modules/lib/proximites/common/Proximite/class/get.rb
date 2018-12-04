class Proximite
class << self

  # Pour récupérer l'instance proximité d'identifiant +prox_id+
  def get prox_id
    @items ||= Hash.new
    @items[prox_id] ||= project.tableau_proximites[:proximites][prox_id]
  end

end #/ << self
end #/Proximite
