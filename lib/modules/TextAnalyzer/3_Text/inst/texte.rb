# encoding: UTF-8
class TextAnalyzer
class AnalyzedFile
class Text

  # Le contenu du fichier, donc son texte
  # Noter qu'on ajoute ' EOT' à la fin du texte (notamment pour pouvoir
  # traiter les dernières ponctuations)
  def content
    @content ||= begin
      File.read(file.path).force_encoding('utf-8') + ' EOT'
    end
  end

end #/Text
end #/AnalyzedFile
end #/TextAnalyzer
