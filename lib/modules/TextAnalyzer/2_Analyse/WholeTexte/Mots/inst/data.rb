# encoding: UTF-8
=begin

=end
class TextAnalyzer
class Analyse
class WholeText
class Mots

  # {TextAnalyzer::Analyse::WholeText} Instance du texte entier
  attr_accessor :texte_entier

  # {Hash} Liste des mots du texte. En clé, l'index (unique) du mot, en
  # valeur, son instance WholeText::Mot
  # Cf. la méthode `create` pour voir comment ils sont créés
  attr_accessor :items

end #/Mots
end #/WholeText
end #/Analyse
end #/TextAnalyzer
