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

  # Pour définir comment enregistrer la donnée `mots`
  def mots_for_yaml
    mots.data_for_yaml
  end
  # Pour savoir comment traiter les mots en retour (load)
  def mots_from_yaml(hdata)
    mots.data_from_yaml(hdata)
  end

end #/WholeText
end #/Analyse
end #/TextAnalyzer
