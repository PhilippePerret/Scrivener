# encoding: UTF-8
=begin

  Classe pour la gestion du texte dans son ensemble, une fois que tous les
  textes d'une analyse ont été rassemblés.

=end
class TextAnalyzer
class Analyse
class WholeText

  attr_accessor :analyse

  def initialize instance_analyse
    self.analyse = instance_analyse
  end

  def init
    File.unlink(path) if File.exist?(path)
    @content  = nil
    @length   = 0
  end

end #/WholeText
end #/Analyse
end #/TextAnalyzer
