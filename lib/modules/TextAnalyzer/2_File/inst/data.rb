# encoding: UTF-8
class TextAnalyzer
class File

  # Instance {TextAnalyzer::File::Text} du texte du fichier
  def texte
    @texte ||= TextAnalyzer::File::Text.new(self)
  end

end #/File
end #/TextAnalyzer
