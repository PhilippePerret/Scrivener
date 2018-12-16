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

    # Moyenne des éloignements des proximités
    # cf. la méthode `calcule_proximites` qui les calcule
    attr_accessor :moyenne_eloignements
    attr_accessor :moyenne_eloignements_common

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
