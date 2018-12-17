# encoding: UTF-8
class TextAnalyzer
class Analyse


  # Raccourci de table_resultats.output qui gère la sortie des résultats
  def output
    table_resultats.output
  end

  def mots
    table_resultats.mots
  end

  def all_mots
    texte_entier.mots
  end

  def canons
    table_resultats.canons
  end

  def proximites
    table_resultats.proximites
  end

end #/Analyse
end #/TextAnalyzer
