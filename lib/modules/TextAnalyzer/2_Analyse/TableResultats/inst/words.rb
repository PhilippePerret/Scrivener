# encoding: UTF-8
class TextAnalyzer
class Analyse
class TableResultats

  # Ajouter un mot (traitable ou non) à la table des résultats
  def add_word(mot)
    mot.treatable? && add_treatable_word(mot)
    add_real_word(mot)
  end

  # Ajoute l'instance +mot+ à la table des résultats
  def add_treatable_word(mot)
    canon = mot.canon
    # Si la liste des mots actuelle ne connait pas ce canon, il faut
    # l'ajouter
    self.canons.key?(mot.canon) || begin
      self.canons.merge!(mot.canon => {items: Array.new, proximites: Array.new})
    end
    # Placer le mot au bon endroit dans la liste des items
    if canon_of(mot)[:items].empty? || canon_of(mot)[:items].last.offset < mot.offset
      # S'il n'y a pas encore d'item ou que le dernier item a un offset inférieur
      # au mot courant, on met le mot courant à la fin.
      self.canons[mot.canon][:items] << mot
    else
      # Sinon, il faut trouver où mettre l'item (TODO reprendre le code ci-dessous)
      canon_of(mot)[:items].each_with_index do |imot, index_mot|
        if imot.offset > mot.offset
          self.canons[mot.canon][:items].insert(index_mot, mot)
        end
      end
    end
  end
  # /add_treatable_word

  # Ajouter le mot quoi qu'il en soit (traitable ou pas)
  def add_real_word(mot)
    self.mots.key?(mot.downcase) || begin
      self.mots.merge!(mot.downcase => Array.new)
    end
    self.mots[mot.downcase] << mot.index
  end
  # /add_real_word

  # Pour obtenir les données du canon du mot +mot+
  def canon_of(mot)
    self.canons[mot.canon]
  end

end #/TableResultats
end #/Analyse
end #/TextAnalyzer
