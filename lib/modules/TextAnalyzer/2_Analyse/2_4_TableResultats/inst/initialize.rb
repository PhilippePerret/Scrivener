# encoding: UTF-8
class TextAnalyzer
class Analyse
class TableResultats

  attr_accessor :analyse

  # Une table de résultats
  #
  # Normalement, elle ne reçoit rien à l'instanciation, elle ne doit être liée
  # ni à un fichier, ni à un texte, ni même à un projet Scrivener car on doit
  # pouvoir l'utiliser en dehors de Scrivener
  #
  # Les intances {TextAnalyzer::File} sont des éléments de cette table de
  # résultat.
  def initialize instance_analyse
    self.analyse = instance_analyse
  end

end #/TableResultats
end #/Analyse
end #/TextAnalyzer
