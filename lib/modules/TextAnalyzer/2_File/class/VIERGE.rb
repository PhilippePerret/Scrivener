# encoding: UTF-8
class TextAnalyzer
class File
class << self

  # +analyse+     Instance TextAnalyzer::Analyse de l'analyse dont il faut
  #               obtenir le fichier.
  # +object_id+   OjectID du fichier (qui correspond à sa première instancia-
  #               tion)
  def get analyse, object_id
    @items ||= Hash.new
    @items[analyse.object_id] ||= Hash.new
    @items[analyse.object_id][object_id] ||= begin
      analyse.get_file(object_id)
    end
  end

end #/<< self
end #/File
end #/TextAnalyzer
