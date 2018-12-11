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
    @path ||= ::File.join(analyse.hidden_folder,'texte_entier.txt')
  end

end #/WholeText
end #/Analyse
end #/TextAnalyzer
