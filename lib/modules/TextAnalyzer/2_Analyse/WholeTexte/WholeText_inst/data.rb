# encoding: UTF-8
=begin

  Classe pour la gestion du texte dans son ensemble, une fois que tous les
  textes d'une analyse ont été rassemblés.

=end
class TextAnalyzer
class Analyse
class WholeText

  attr_accessor :created_at, :updated_at

  # Chemin d'accès au fichier contenant tout le texte
  def path
    @path ||= File.join(analyse.hidden_folder,'texte_entier.txt')
  end

  # Chemin d'accès au fichier produit par tree-tagger
  def lemma_file_path
    @lemma_file_path ||= File.join(analyse.hidden_folder,'texte_entier_lemmatized.txt')
  end

  # Longueur du texte
  def length
    @length ||= File.stat(path).size
  end

  # Retourne le nombre de pages, estimées soit d'après le nombre de signes,
  # si per = :signes, soit d'après le nombre de mots si per = :mots et soit
  # d'après une moyenne des deux si per = nil
  def pages_count per = nil
    @pages_count ||= Hash.new
    if (per.nil? || per == :signes) && @pages_count[:signes].nil?
      @pages_count.merge!(signes: (length / NUMBER_SIGNES_PER_PAGE) + 1)
    end
    if (per.nil? || per == :mots) && @pages_count[:mots].nil?
      @pages_count.merge!(mots: (mots.count / NUMBER_MOTS_PER_PAGE) + 1)
    end
    if per.nil?
      @pages_count.merge!(moy: (@pages_count[:signes] + @pages_count[:mots]) / 2)
      per = :moy
    end
    return @pages_count[per]
  end

end #/WholeText
end #/Analyse
end #/TextAnalyzer
