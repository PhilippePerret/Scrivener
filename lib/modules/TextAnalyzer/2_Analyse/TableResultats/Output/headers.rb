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
      'de la plus proche à la plus éloignée'
    else
      'alphabétiquement'
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
      'par nombre de mots'
    when :proximites_count
      'par nombre de proximités'
    else # :alpha
      'alphabétiquement'
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
    when :mots_count
      'par nombre d’occurences'
    when :proximites_count
      'par nombre de proximités'
    else # :alpha
      'alphabétiquement'
    end
  end

end #/Mot
end #/TableResultats
end #/Analyse
end #/TextAnalyzer
