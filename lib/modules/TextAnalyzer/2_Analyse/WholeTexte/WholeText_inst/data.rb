# encoding: UTF-8
=begin

  Classe pour la gestion du texte dans son ensemble, une fois que tous les
  textes d'une analyse ont été rassemblés.

=end
class TextAnalyzer
class Analyse
class WholeText

  # La classe Mot, pour pouvoir faire des choses comme :
  #   <analyse>.texte_entier.mots[<index mot>]
  def mots
    @mots ||= TextAnalyzer::Analyse::WholeText::Mots.new(self)
  end

  def mot index_mot
    mots.get_by_index(index_mot)
  end

  # Chemin d'accès au fichier contenant tout le texte
  def path
    @path ||= File.join(analyse.hidden_folder,'texte_entier.txt')
  end

  # Chemin d'accès au fichier produit par tree-tagger
  def lemma_file_path
    @lemma_file_path ||= File.join(analyse.hidden_folder,'texte_entier_lemmatized.txt')
  end

  # Ne pas le mettre en propriété @length, car on s'en sert pour connaitre
  # l'offset de chaque file au moment de l'assemblage des textes.
  def length
    @length ||= File.stat(path).size
  end

end #/WholeText
end #/Analyse
end #/TextAnalyzer
