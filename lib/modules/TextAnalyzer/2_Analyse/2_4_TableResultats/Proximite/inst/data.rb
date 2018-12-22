# encoding: UTF-8
=begin
  Module contenant les méthodes de propriétés
=end
class TextAnalyzer
class Analyse
class TableResultats
class Proximite

  # Pour indiquer que cette proximité a été corrigée, supprimée ou ignorée
  attr_accessor :fixed, :erased, :ignored

  # retourne la distance, en caractères, entre les deux mots (de la fin
  # du premier au début du deuxième)
  def distance
    @distance ||= mot_apres.offset - (mot_avant.offset + mot_avant.length)
  end

  # La distance minimale pour cette proximité
  def distance_minimale
    @distance_minimale ||= begin
      TextAnalyzer::Analyse::WholeText::Mot.distance_minimale(mot_avant.canon)
    end
  end

  # Transforme l'instance en hash, pour l'utilisation par exemple dans les
  # string-interpolation
  # Note : puisque ces valeurs sont destinées à servir pour les interpolations,
  # on cherche la valeur string qui peut être affichée (cf. les mot_avant et
  # mot_apres par exemple)
  def to_h
    {
      mot_avant: "#{mot_avant.real} [#{mot_avant.index}]",
      mot_apres: "#{mot_apres.real} [#{mot_apres.index}]",
      distance: distance, distance_minimale: distance_minimale,
      id: id
    }
  end
  alias :to_hash :to_h
end #/Proximite
end #/TableResultats
end #/Analyse
end #/TextAnalyzer
