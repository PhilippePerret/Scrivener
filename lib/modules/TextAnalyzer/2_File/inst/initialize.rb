# encoding: UTF-8
class TextAnalyzer
class AnalyzedFile

  # Chemin d'accès au fichier contenant le texte à analyser
  attr_accessor :path

  # {TextAnalyzer::Analyse} L'analyse en cours, ou nil si le fichier
  # n'est pas analysé dans le cadre d'une analyse de texte
  attr_accessor :analyse

  def initialize path, analyse = nil
    self.path     = path
    self.analyse  = analyse
  end

end #/AnalyzedFile
end #/TextAnalyzer
