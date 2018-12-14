# encoding: UTF-8
=begin
  Module de méthodes définissant les nombres (de mots, de canons, etc.)

  Noter qu'à chaque méthode de la table de résultat correspond une méthode
  équivalente, raccourci, pour l'analyse.
  Par exemple :
    <analyse>.nombre_mots <-> <analyse>.table_resultats.nombre_mots

=end
class TextAnalyzer
class Analyse
  # Méthodes raccourcis pour faire <analyse>.<methode> au lieu de
  # <analyse>.tableau_resultats.<methode>
  def nombre_mots       ; table_resultats.nombre_mots   end
  def nombre_canons     ; table_resultats.nombre_canons   end
  def nombre_proximites ; table_resultats.nombre_proximites   end
  def nombre_mots_differents  ; table_resultats.nombre_mots_differents  end
  def nombre_mots_uniques     ; table_resultats.nombre_mots_uniques     end

class TableResultats

  # Nombre de mots total dans le texte. Ça correspond au nombre d'éléments
  # dans segments divisés par 2
  def nombre_mots
    @nombre_mots ||= segments.count / 2
  end
  # Le nombre de mots différents donc, de clés dans la liste des mots
  def nombre_mots_differents
    @nombre_mots_differents ||= mots.keys.count
  end

  # Retourne le nombre de mots uniques.
  # Cf. liste_mots_uniques
  def nombre_mots_uniques
    @nombre_mots_uniques ||= liste_mots_uniques.count
  end

  # Le nombre de canons, donc de clés dans la liste des canons
  def nombre_canons
    @nombre_canons ||= canons.keys.count
  end
  # Le nombre de proximités
  def nombre_proximites
    @nombre_proximites ||= proximites.count
  end


end #/TableResultats
end #/Analyse
end #/TextAnalyzer
