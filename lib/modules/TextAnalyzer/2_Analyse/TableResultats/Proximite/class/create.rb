class TextAnalyzer
class Analyse
class TableResultats
class Proximite
  class << self

    # Création d'une proximité nouvelle entre le mot +mot_avant+ et
    # le mot +mot_apres+ dans le tableau de proximités +tableau+
    def create table, mot_avant, mot_apres
      table.last_id_proximite += 1
      new_prox_id = table.last_id_proximite.to_i
      canon       = mot_avant.canon

      new_prox = new(new_prox_id, mot_avant, mot_apres)
      table.proximites << new_prox
      table.canons.add_proximite(mot_avant, new_prox)

      # On associe les mots à leur proximité
      mot_avant.proximite_apres= new_prox
      mot_apres.proximite_avant= new_prox

      # On retourne la nouvelle proximité créée
      return new_prox
    end
    # /create
  end #/ << self
end #/Proximite
end #/TableResultats
end #/Analyse
end #/TextAnalyzer
