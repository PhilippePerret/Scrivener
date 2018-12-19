# encoding: UTF-8
class TextAnalyzer
class Analyse
class TableResultats

  # Initialisation du tableau de résultat
  #
  # Doit être appelé avant chaque analyse.
  def init
    self.current_offset     = 0
    self.current_index_mot  = -1
    self.last_id_proximite  = -1
    self.paths = Array.new
  end

end #/TableResultats
end #/Analyse
end #/TextAnalyzer
