# encoding: UTF-8
=begin
  Méthodes de classe de TextAnalyzer::Analyse

=end
class TextAnalyzer
class Analyse
class << self

  # Pour recharger une analyse
  def reload analyse
    new_analyse = Marshal.load(File.open(analyse.data_path,'rb'))
    new_analyse.reload # pour les tables, segments, etc.
    return new_analyse
  end

end #/<< self
end #/Analyse
end #/TextAnalyzer
