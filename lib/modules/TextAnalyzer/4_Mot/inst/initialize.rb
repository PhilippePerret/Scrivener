class TextAnalyzer
class AnalyzedFile
class Text
class Mot

  # Instancier un nouveau mot
  # +data+ {Hash} Données du mot. Devrait contenir au minimum :
  #   :index      Son indice dans le texte en tant que mot (0-start)
  #   :offset     Son décalage 0-start dans le texte (complet)
  #   :real_mot   Le mot lui-même
  def initialize data = nil
    data.each { |k,v| self.send("#{k}=".to_sym, v) }
    self.real_init = self.real.freeze
  end

end #/Mot
end #/Text
end #/AnalyzedFile
end #/TextAnalyzer
