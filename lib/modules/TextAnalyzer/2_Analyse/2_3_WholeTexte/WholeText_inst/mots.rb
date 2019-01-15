# encoding: UTF-8
=begin

  Classe pour la gestion du texte dans son ensemble, une fois que tous les
  textes d'une analyse ont été rassemblés.

=end
class TextAnalyzer
class Analyse
class WholeText

  def mots
    @mots ||= TextAnalyzer::Analyse::WholeText::Mots.new(self)
  end

  def mot index_mot
    mots[index_mot]
  end

end #/WholeText
end #/Analyse
end #/TextAnalyzer
