# encoding: UTF-8
class TextAnalyzer
class AnalyzedFile
class << self

  # +analyse+     Instance TextAnalyzer::Analyse de l'analyse dont il faut
  #               obtenir le fichier.
  # +object_id+   OjectID du fichier (qui correspond à sa première instancia-
  #               tion)
  def get analyse, file_id
    @items ||= Hash.new
    @items[analyse.object_id] ||= Hash.new
    @items[analyse.object_id][file_id] ||= begin
      analyse.get_file(file_id)
    end
  end

end #/<< self
end #/AnalyzedFile
end #/TextAnalyzer
