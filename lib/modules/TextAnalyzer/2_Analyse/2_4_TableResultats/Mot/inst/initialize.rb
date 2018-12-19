# encoding: UTF-8
=begin
  Classe TextAnalyzer::Analyse::TableResultats::Mot
  ---------------------------------------------------
  Instance pour les mots (pour UN mot de résultat)
  )
=end
class TextAnalyzer
class Analyse
class TableResultats
class Mot

  def initialize imot, data = nil
    self.real     = imot.real
    self.downcase = imot.downcase
    self.sortish  = imot.downcase.normalize
    self.data     = data
    self.indexes  = Array.new
  end

  # Ajout d'un mot (on ajoute son index. On pourra retrouver le mot avec
  # <analyse>.mots[<index])
  def << imot
    self.indexes << imot.index
  end

end #/Mot
end #/TableResultats
end #/Analyse
end #/TextAnalyzer
