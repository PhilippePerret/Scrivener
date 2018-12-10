# encoding: UTF-8
class TextAnalyzer
class File

  # Index du File dans son analyse. Pour pouvoir les récupérer dans
  # l'ordre, entendu que Analyse#files est une table avec l'object_id
  # du File en clé et l'instance en valeur.
  attr_accessor :index

  # Instance {TextAnalyzer::File::Text} du texte du fichier
  def texte
    @texte ||= TextAnalyzer::File::Text.new(self)
  end

end #/File
end #/TextAnalyzer
