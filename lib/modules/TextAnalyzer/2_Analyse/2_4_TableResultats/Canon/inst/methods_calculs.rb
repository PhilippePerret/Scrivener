# encoding: UTF-8
=begin
  Classe TextAnalyzer::Analyse::TableResultats::Canon
  ---------------------------------------------------
  Instance pour les canons (pour UN canon
  )
=end
class TextAnalyzer
class Analyse
class TableResultats
class Canon

  def calc_moyenne_distances
    if nombre_proximites > 0
      total_distances = 0
      proximites.each do |prox_id|
        total_distances += analyse.proximites[prox_id].distance
      end
      total_distances / nombre_proximites
    else
      '---'
    end
  end

  # Retourne la distance minimale pour ce canon
  def distance_minimale
    @distance_minimale ||= begin
      TextAnalyzer::Analyse::WholeText::Mot.distance_minimale(self.canon)
    end
  end

end #/Canon
end #/TableResultats
end #/Analyse
end #/TextAnalyzer
