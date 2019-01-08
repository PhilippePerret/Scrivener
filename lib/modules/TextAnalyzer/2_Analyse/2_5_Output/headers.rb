# encoding: UTF-8
=begin
  Module des méthodes permettant de construire les entêtes de sortie
=end
class TextAnalyzer
class Analyse
class TableResultats
class Proximite

  def self.classement_name options
    case options[:sorted_by]
    when :distance
      t('sorted.nearest_to_farest')
    else
      t('alphabetical')
    end
  end



end #/Proximite
end #/TableResultats
end #/Analyse
end #/TextAnalyzer

class TextAnalyzer
class Analyse
class TableResultats
class Canon

  def self.classement_name options
    case options[:sorted_by]
    when :mots_count
      t('sorted.by_words_count')
    when :proximites_count, :prox_count
      t('sorted.by_proxs_count')
    else # :alpha
      t('sorted.alphabetical')
    end
  end

end #/Canon
end #/TableResultats
end #/Analyse
end #/TextAnalyzer

class TextAnalyzer
class Analyse
class WholeText
class Mot
  def self.classement_name options
    case options[:sorted_by]
    when :mots_count, :count
      t('sorted.by_occurences_count')
    when :proximites_count, :prox_count
      t('sorted.by_proxs_count')
    else # :alpha
      t('sorted.alphabetical')
    end
  end

end #/Mot
end #/TableResultats
end #/Analyse
end #/TextAnalyzer
