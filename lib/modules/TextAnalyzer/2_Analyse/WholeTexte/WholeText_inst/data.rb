# encoding: UTF-8
=begin

  Classe pour la gestion du texte dans son ensemble, une fois que tous les
  textes d'une analyse ont été rassemblés.

=end
class TextAnalyzer
class Analyse
class WholeText

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
