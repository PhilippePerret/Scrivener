class TextAnalyzer
class Analyse
class WholeText
class Mot

  # Instancier un nouveau mot
  # +data+ {Hash} Données du mot. Devrait contenir au minimum :
  #   :index      Son indice dans le texte en tant que mot (0-start)
  #   :offset     Son décalage 0-start dans le texte (complet)
  #   :real_mot   Le mot lui-même
  def initialize data = nil
    # puts "-- data: #{data.inspect}"
    unless data.nil?
      data.each { |k,v| self.send("#{k}=".to_sym, v) }
      self.real_init = self.real.freeze
    end
  end

end #/Mot
end #/WholeText
end #/Analyse
end #/TextAnalyzer
