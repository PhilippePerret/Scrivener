# encoding: UTF-8
=begin
  Module des méthodes permettant de construire les entêtes de sortie
=end
class TextAnalyzer
class Analyse
class TableResultats
class << self
  def classement_name options
    case options[:sorted_by]
    when :mots_count
      t('sorted.by_words_count')
    when :proximites_count, :prox_count
      t('sorted.by_proxs_count')
    when :distance
      t('sorted.nearest_to_farest')
    else
      t('sorted.alphabetically')
    end
  end

end # << self
end #/TableResultats
end #/Analyse
end #/TextAnalyzer
