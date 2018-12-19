# encoding: UTF-8
=begin

=end
class TextAnalyzer
class Analyse
class TableResultats
class Mot

  attr_accessor :real, :downcase
  # Valeur pour pouvoir le trier
  attr_accessor :sortish
  attr_accessor :data

  # Liste des index du mot
  attr_accessor :indexes


  def count
    @count ||= indexes.count
  end

end #/Mot
end #/TableResultats
end #/Analyse
end #/TextAnalyzer
