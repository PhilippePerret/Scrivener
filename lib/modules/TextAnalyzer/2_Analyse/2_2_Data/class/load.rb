# encoding: UTF-8
=begin

=end
class TextAnalyzer
class Analyse
class Data
class << self

  # Rechargement des données de l'analyse
  def load analyse
    Marshal.load(File.open(File.join(analyse.hidden_folder,'data.msh'),'rb'))
  end

end #/<< self
end #/Data
end #/Analyse
end #/TextAnalyzer
