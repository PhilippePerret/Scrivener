# encoding: UTF-8
=begin
  Module contenant les méthodes de propriétés
=end
class TextAnalyzer
class Analyse
class TableResultats
  class Proximite

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
  end #/Proximite
end #/TableResultats
end #/Analyse
end #/TextAnalyzer
