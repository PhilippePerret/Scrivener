# encoding: UTF-8
=begin

=end
class TextAnalyzer
class Analyse
class Data
class << self

  # Rechargement des données de l'analyse
  # Doit retourner une instance TextAnalyzer::Analyse::Data
  # NOTE : je ne suis pas sûr qu'il soit encore nécessaire de passer par
  # là maintenant que les données sont enregistrées en YAML.
  def load analyse
    idata = TextAnalyzer::Analyse::Data.new(analyse)
    idata.load
    return idata
  end


end #/<< self
end #/Data
end #/Analyse
end #/TextAnalyzer
